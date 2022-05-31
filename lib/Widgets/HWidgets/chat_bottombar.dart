import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/Services/image_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBottomBar extends StatefulWidget {
  final OurUser recipient;
  final String chatRoomId;
  ChatBottomBar(this.recipient, this.chatRoomId);

  @override
  _ChatBottomBarState createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  TextEditingController messageTextEdittingController = TextEditingController();

  addMessage(bool sendClicked, context) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;
      UserController _currentUser =
          Provider.of<UserController>(context, listen: false);
      OurUser user = _currentUser.getCurrentUser;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "type": 'text',
        "read": false,
        "message": message,
        "sendBy": user.displayName,
        "sendByUid": user.uid,
        "ts": lastMessageTs,
        "imgUrl": user.avatarUrl
      };

      Database().addMessage(widget.chatRoomId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "type": 'text',
          "read": false,
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": user.displayName,
          "lastMessageSendByUid": user.uid,
          "lastMessageSendByImgUrl": user.avatarUrl
        };

        Database().updateLastMessageSend(widget.chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          // messageId = "";
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Container(
        height: h * 11.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xff00AEFF),
            width: w * 0.2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextField(
                  controller: messageTextEdittingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white60,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    hintText: 'Type a message...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        addMessage(true, context);
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ImageService().uploadImage(widget.chatRoomId);
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
