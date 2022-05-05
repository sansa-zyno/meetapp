import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessages extends StatefulWidget {
  final OurUser recipient;
  final String chatRoomId;

  ChatMessages(this.recipient, this.chatRoomId);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  Stream? messageStream;
  String myUserName = "";

  getMyInfoFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUserName = prefs.getString('userName')!;
  }

  getAndSetMessages() async {
    messageStream = await Database().getChatRoomMessages(widget.chatRoomId);
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe, h, w) {
    return !sendByMe
        ? message != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container()
        : message != ""
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container();
  }

  Widget imageMessageTile(String url, bool sendByMe) {
    return sendByMe
        ? url != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon(Icons.phone,color: const Color(0xff7672c9),),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.only(
                      right: 15,
                      top: 10,
                      bottom: 10,
                    ),
                    child:
                        FittedBox(fit: BoxFit.fill, child: Image.network(url)),
                  ),
                ],
              )
            : Container()
        : url != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon(Icons.phone,color: const Color(0xff7672c9),),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.only(
                      left: 15,
                      top: 10,
                      bottom: 10,
                    ),
                    child:
                        FittedBox(fit: BoxFit.fill, child: Image.network(url)),
                  ),
                ],
              )
            : Container();
  }

  Widget chatMessages(
    h,
    w,
  ) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        QuerySnapshot? q = snapshot.data as QuerySnapshot?;
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: q!.docs.length,
                physics: ClampingScrollPhysics(),
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = q.docs[index];
                  return ds['type'] == 'text'
                      ? chatMessageTile(
                          ds["message"],
                          myUserName == ds["sendBy"],
                          h,
                          w,
                        )
                      : imageMessageTile(
                          ds['photoUrl'], myUserName == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    await getAndSetMessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThisOnLaunch();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Column(
        children: [
          chatMessages(
            h,
            w,
          ),
          SizedBox(height: 30)
        ],
      ),
    );
  }
}
