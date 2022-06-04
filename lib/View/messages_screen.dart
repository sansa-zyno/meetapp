import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';

import 'chat_screen.dart';

class Messages extends StatefulWidget {
  Messages({Key? key}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Stream? chatroomStream;
  getChatRooms() async {
    chatroomStream = await Database().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xff00AEFF),
                width: 1,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Inbox",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff00AEFF),
                        fontSize: w * 6.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: chatroomStream,
          builder: (ctx, snapshot) {
            QuerySnapshot? q = snapshot.data as QuerySnapshot?;
<<<<<<< HEAD
            return snapshot.hasData
                ? q!.docs.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(5),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: q.docs.length,
                        itemBuilder: (cxt, index) {
                          DocumentSnapshot ds = q.docs[index];
                          return ChatRoomListTile(
                              ds["lastMessage"],
                              ds['type'],
                              ds['lastMessageSendByUid'],
                              ds.id,
                              ds['read'],
                              ds["users"]);
                        },
                        separatorBuilder: (ctx, index) => Divider(
                          thickness: 5,
                        ),
                      )
                    : Center(child: Container(child: Text("No chat history")))
                : Center(
                    child: CircularProgressIndicator(),
                  );
=======
            return snapshot.hasData && q!.docs.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.all(5),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: q.docs.length,
                    itemBuilder: (cxt, index) {
                      DocumentSnapshot ds = q.docs[index];
                      return ChatRoomListTile(
                          ds["lastMessage"],
                          ds['type'],
                          ds['lastMessageSendByUid'],
                          ds.id,
                          ds['read'],
                          ds["users"]);
                    },
                    separatorBuilder: (ctx, index) => Divider(
                      thickness: 5,
                    ),
                  )
                : Center(child: Container(child: Text("No chat history")));
>>>>>>> ab42009eebeb719801c1c60e2864f4222fb5b12c
          }),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, type, sentByUid, chatRoomId;
  final bool read;
  final List users;
  ChatRoomListTile(this.lastMessage, this.type, this.sentByUid, this.chatRoomId,
      this.read, this.users);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", productName = "";
  OurUser? user;

  getOtherPersonInfoAndProductName() async {
    String productId =
        widget.chatRoomId.substring(widget.chatRoomId.length - 20);
    setState(() {});

    for (int i = 0; i < widget.users.length; i++) {
      if (widget.users[i] != FirebaseAuth.instance.currentUser!.uid) {
        QuerySnapshot _doc = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.users[i])
            .get();
        user = OurUser.fromFireStore(_doc.docs[0]);
        profilePicUrl = user!.avatarUrl!;
        //name = username;
        setState(() {});
      }
    }

    QuerySnapshot q1 =
        await FirebaseFirestore.instance.collectionGroup("meeter").get();
    QuerySnapshot q2 =
        await FirebaseFirestore.instance.collectionGroup("demand").get();

    if (q1.docs.isNotEmpty) {
      for (int i = 0; i < q1.docs.length; i++) {
        if (q1.docs[i].id == productId) {
          productName = q1.docs[i]["meetup_title"];
          setState(() {});
        }
      }
    }
    if (q2.docs.isNotEmpty) {
      for (int i = 0; i < q2.docs.length; i++) {
        if (q2.docs[i].id == productId) {
          productName = q2.docs[i]["demand_title"];
          setState(() {});
        }
      }
    }
  }

  @override
  void initState() {
    getOtherPersonInfoAndProductName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? GestureDetector(
            onTap: () async {
              if (widget.sentByUid != FirebaseAuth.instance.currentUser!.uid) {
                //get all messages that havent been read
                QuerySnapshot q = await FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .where("read", isEqualTo: false)
                    .get();
                //turn to read to turn number of unread to zero
                for (int i = 0; i < q.docs.length; i++) {
                  await FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoomId)
                      .collection('chats')
                      .doc(q.docs[i].id)
                      .update({"read": true});
                }
                //turn to read to prevent it showing as notification in activity/request
                await FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomId)
                    .update({"read": true});
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(user!, widget.chatRoomId)));
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
                      widget.sentByUid != FirebaseAuth.instance.currentUser!.uid
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("chatrooms")
                                  .doc(widget.chatRoomId)
                                  .collection('chats')
                                  .where("read", isEqualTo: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                QuerySnapshot? q =
                                    snapshot.data as QuerySnapshot?;
                                return q != null && q.docs.isNotEmpty
                                    ? Positioned(
                                        top: 0,
                                        right: 2,
                                        child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red),
                                            child: snapshot.hasData
                                                ? Center(
                                                    child: Text(
                                                        '${q.docs.length}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                                : Container()))
                                    : Container();
                              })
                          : Container()
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.indigoAccent,
                              Colors.blue,
                              Colors.green
                            ]).createShader(rect),
                        child: Text(
                          productName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
