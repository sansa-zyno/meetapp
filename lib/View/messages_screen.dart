import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class Messages extends StatefulWidget {
  Messages({Key? key}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String? myName;
  getMyName() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    myName = _pref.getString('userName')!;
    setState(() {});
  }

  Stream? chatroomStream;
  getChatRooms() async {
    chatroomStream = await Database().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatRooms();
    getMyName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          //leading: Icon(Icons.notifications, color: Colors.black87,),
          title: Text(
            'Inbox',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
            stream: chatroomStream,
            builder: (ctx, snapshot) {
              QuerySnapshot? q = snapshot.data as QuerySnapshot?;
              return snapshot.hasData
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: q!.docs.length,
                      itemBuilder: (cxt, index) {
                        DocumentSnapshot ds = q.docs[index];
                        return ChatRoomListTile(
                            ds["lastMessage"],
                            ds['type'],
                            ds['read'],
                            ds['lastMessageSendBy'],
                            ds.id,
                            myName!);
                      })
                  : Container();
            }),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, type, chatRoomId, myUsername, sentBy;
  final bool read;
  ChatRoomListTile(this.lastMessage, this.type, this.read, this.sentBy,
      this.chatRoomId, this.myUsername);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "";
  OurUser? user;

  getUserInfo() async {
    String username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot _doc = await FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isEqualTo: username)
        .get();
    user = OurUser.fromFireStore(_doc.docs[0]);

    profilePicUrl = user!.avatarUrl!;
    name = username;
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null && widget.sentBy != widget.myUsername
        ? GestureDetector(
            onTap: () async {
              QuerySnapshot q = await FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(widget.chatRoomId)
                  .collection('chats')
                  .where("read", isEqualTo: false)
                  .get();
              for (int i = 0; i < q.docs.length; i++) {
                await FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .doc(q.docs[i].id)
                    .update({"read": true});
              }

              await FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(widget.chatRoomId)
                  .update({"read": true});

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen(user!)));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            profilePicUrl,
                            fit: BoxFit.fill,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 2,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("chatrooms")
                                  .doc(widget.chatRoomId)
                                  .collection('chats')
                                  .where("read", isEqualTo: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                QuerySnapshot? q =
                                    snapshot.data as QuerySnapshot?;
                                return snapshot.hasData
                                    ? Center(child: Text('${q!.docs.length}'))
                                    : Container();
                              },
                            ),
                          ))
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF166138)),
                      ),
                      SizedBox(height: 5),
                      widget.type == "text"
                          ? Container(
                              width: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.lastMessage,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: widget.read
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.lastMessage,
                                height: 60,
                                width: 60,
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
