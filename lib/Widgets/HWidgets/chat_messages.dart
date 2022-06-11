import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';
import 'package:date_format/date_format.dart';

class ChatMessages extends StatefulWidget {
  final OurUser recipient;
  final String chatRoomId;

  ChatMessages(
    this.recipient,
    this.chatRoomId,
  );

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  Stream? messageStream;
  ScrollController? scrollController;

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
                    height: MediaQuery.of(context).size.height * 0.25,
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
                    height: MediaQuery.of(context).size.height * 0.25,
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
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (scrollController!.hasClients) {
            scrollController!.animateTo(
              scrollController!.position.maxScrollExtent,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          }
        });

        return snapshot.hasData
            ? q!.docs.isNotEmpty
                ? ListView.builder(
                    itemCount: q.docs.length + 1,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == q.docs.length) {
                        return Container(
                          height: 100,
                        );
                      }
                      bool isSameDate = true;
                      DateTime dt = DateTime.parse(q.docs[index]['ts']
                          .toDate()
                          .toString()
                          .substring(0, 10));
                      if (index == 0) {
                        isSameDate = false;
                      } else {
                        DateTime dte = DateTime.parse(q.docs[index - 1]['ts']
                            .toDate()
                            .toString()
                            .substring(0, 10));
                        isSameDate = dt.compareTo(dte) == 0 ? true : false;
                      }

                      if (index == 0 || !(isSameDate)) {
                        DateTime dt = DateTime.parse(q.docs[index]['ts']
                            .toDate()
                            .toString()
                            .substring(0, 10));
                        DateTime dtTime = DateTime.parse(
                            q.docs[index]['ts'].toDate().toString());
                        String time =
                            formatDate(dtTime, [hh, ':', nn, ' ', am]);
                        DateTime dateNow = DateTime.parse(
                            DateTime.now().toString().substring(0, 10));
                        String date = dt.compareTo(dateNow) == 0
                            ? "Today"
                            : "${dt.year} ${dt.month} ${dt.day}" ==
                                    "${dateNow.year} ${dateNow.month} ${(dateNow.day) - 1}"
                                ? "Yesterday"
                                : formatDate(dt, [M, ' ', dd, ', ', yyyy]);
                        return Column(children: [
                          SizedBox(height: 8),
                          Text(
                            date,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          //ListTile(title: Text('item $index'))
                          q.docs[index]['type'] == 'text'
                              ? Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              q.docs[index]["sendByUid"]
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        chatMessageTile(
                                          q.docs[index]["message"],
                                          FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              q.docs[index]["sendByUid"],
                                          h,
                                          w,
                                        ),
                                        Padding(
                                          padding: FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  q.docs[index]["sendByUid"]
                                              ? const EdgeInsets.only(
                                                  right: 15.0)
                                              : const EdgeInsets.only(
                                                  left: 15.0),
                                          child: Text(
                                            time,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment:
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              q.docs[index]["sendByUid"]
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    imageMessageTile(
                                        q.docs[index]['photoUrl'],
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            q.docs[index]["sendByUid"]),
                                    Padding(
                                      padding: FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              q.docs[index]["sendByUid"]
                                          ? const EdgeInsets.only(right: 15.0)
                                          : const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        time,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                        ]);
                      } else {
                        DateTime dtTime = DateTime.parse(
                            q.docs[index]['ts'].toDate().toString());
                        String time =
                            formatDate(dtTime, [hh, ':', nn, ' ', am]);
                        return q.docs[index]['type'] == 'text'
                            ? Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            q.docs[index]["sendByUid"]
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      chatMessageTile(
                                        q.docs[index]["message"],
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            q.docs[index]["sendByUid"],
                                        h,
                                        w,
                                      ),
                                      Padding(
                                        padding: FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                q.docs[index]["sendByUid"]
                                            ? const EdgeInsets.only(right: 15.0)
                                            : const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          time,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment:
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            q.docs[index]["sendByUid"]
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  imageMessageTile(
                                      q.docs[index]['photoUrl'],
                                      FirebaseAuth.instance.currentUser!.uid ==
                                          q.docs[index]["sendByUid"]),
                                  Padding(
                                    padding: FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            q.docs[index]["sendByUid"]
                                        ? const EdgeInsets.only(right: 15.0)
                                        : const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      time,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                      }
                    }, // optional // optional
                  )
                : Center(
                    child: Text("No messages to show"),
                  )
            : Center(
                child: Container(
                child: CircularProgressIndicator(),
              ));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    messageStream = Database().getChatRoomMessages(widget.chatRoomId);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: chatMessages(
            h,
            w,
          ),
        ),
        SizedBox(
          height: 88.2,
        )
      ],
    ));
  }
}

/*const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}*/
