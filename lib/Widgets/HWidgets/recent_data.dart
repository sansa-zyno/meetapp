import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/View/meet_up_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/View/chat_screen.dart';

class RecentData extends StatelessWidget {
  final Color clr;
  final DocumentSnapshot? request;
  final DocumentSnapshot? msg;
  final String text;
  RecentData({
    required this.clr,
    this.request,
    this.msg,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return text == "new"
        ? request!['seller_id'] == FirebaseAuth.instance.currentUser!.uid
            ? Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 60),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection("requests")
                        .doc(request!['seller_id'])
                        .collection("request")
                        .doc(request!.id)
                        .update({"read": true});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => MeetUpDetails(request!, clr)));
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: height / 8,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 40, vertical: height / 100),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            height: height / 13,
                            width: width / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                request!['buyer_image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 100.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Meet up request',
                                            style: TextStyle(
                                              color: request!["read"]
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: width / 21,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width / 60),
                                            child: Container(
                                              width: 500,
                                              child: Text(
                                                '🕒${request!['time']}',
                                                style: TextStyle(
                                                  color: request!["read"]
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      'You received a meet up request from ${request!["buyer_name"]}',
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: request!["read"]
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: width / 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container()
        : text == "msg"
            ? msg!["lastMessageSendByUid"] !=
                    FirebaseAuth.instance.currentUser!.uid
                ? Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 60),
                    child: GestureDetector(
                      onTap: () async {
                        QuerySnapshot _doc = await FirebaseFirestore.instance
                            .collection('users')
                            .where('uid',
                                isEqualTo: msg!["lastMessageSendByUid"])
                            .get();
                        OurUser user = OurUser.fromFireStore(_doc.docs[0]);
                        //get all messages that havent been read
                        QuerySnapshot q = await FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(msg!.id)
                            .collection('chats')
                            .where("read", isEqualTo: false)
                            .get();
                        //turn to read to pevent showing as unread in chat history
                        for (int i = 0; i < q.docs.length; i++) {
                          await FirebaseFirestore.instance
                              .collection("chatrooms")
                              .doc(msg!.id)
                              .collection('chats')
                              .doc(q.docs[i].id)
                              .update({"read": true});
                        }
                        //turn to read to prevent showing here again
                        await FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(msg!.id)
                            .update({"read": true});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ChatScreen(user, msg!.id)));
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: height / 8,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 40,
                                  vertical: height / 100),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                ),
                                height: height / 13,
                                width: width / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    msg!['lastMessageSendByImgUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height / 100.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'New message',
                                                style: TextStyle(
                                                  color: msg!["read"]
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: width / 21,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          'You received a new message from ${msg!["lastMessageSendBy"]}',
                                          //overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: msg!["read"]
                                                ? Colors.grey
                                                : Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: width / 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
            : text == "modified"
                ? request!['modifiedBy'] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                        request!['buyer_id'] ==
                            FirebaseAuth.instance.currentUser!.uid
                    ? Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection("requests")
                                .doc(request!['seller_id'])
                                .collection("request")
                                .doc(request!.id)
                                .update({"read": true});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        MeetUpDetails(request!, clr)));
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: height / 6.8,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 40,
                                      vertical: height / 100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10),
                                      ),
                                    ),
                                    height: height / 13,
                                    width: width / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        request!['seller_image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 100.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Meet up request modified',
                                                    style: TextStyle(
                                                      color: request!["read"]
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: width / 21,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width / 60),
                                                    child: Text(
                                                      '🕒${request!['time']}',
                                                      style: TextStyle(
                                                        color: request!["read"]
                                                            ? Colors.grey
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              'You received a meet up modification from ${request!["seller_name"]}',
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: request!["read"]
                                                    ? Colors.grey
                                                    : Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: width / 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : request!['modifiedBy'] !=
                                FirebaseAuth.instance.currentUser!.uid &&
                            request!['seller_id'] ==
                                FirebaseAuth.instance.currentUser!.uid
                        ? Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 60),
                            child: GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc(request!['seller_id'])
                                    .collection("request")
                                    .doc(request!.id)
                                    .update({"read": true});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            MeetUpDetails(request!, clr)));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: height / 6.8,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 40,
                                          vertical: height / 100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        height: height / 13,
                                        width: width / 9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            request!['buyer_image'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height / 100.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Meet up request modified',
                                                        style: TextStyle(
                                                          color:
                                                              request!["read"]
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: width / 21,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width / 60),
                                                        child: Text(
                                                          '🕒${request!['time']}',
                                                          style: TextStyle(
                                                            color: request![
                                                                    "read"]
                                                                ? Colors.grey
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  'You received a meet up modification from ${request!["buyer_name"]}',
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: request!["read"]
                                                        ? Colors.grey
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: width / 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                : text == "accepted"
                    ? request!['acceptedBy'] !=
                                FirebaseAuth.instance.currentUser!.uid &&
                            request!['buyer_id'] ==
                                FirebaseAuth.instance.currentUser!.uid
                        ? Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 60),
                            child: GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc(request!['seller_id'])
                                    .collection("request")
                                    .doc(request!.id)
                                    .update({"read": true});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            MeetUpDetails(request!, clr)));
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: height / 6.8,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 50,
                                          vertical: height / 100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        height: height / 13,
                                        width: width / 9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            request!['seller_image'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height / 120.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Meet up request accepted',
                                                        style: TextStyle(
                                                          color:
                                                              request!["read"]
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: width / 21,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width / 60),
                                                        child: Text(
                                                          '🕒${request!['time']}',
                                                          style: TextStyle(
                                                            color: request![
                                                                    "read"]
                                                                ? Colors.grey
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  'Your meet up request was accepted by ${request!["seller_name"]}',
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: request!["read"]
                                                        ? Colors.grey
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: width / 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : request!['acceptedBy'] !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                request!['seller_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 60),
                                child: GestureDetector(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("requests")
                                        .doc(request!['seller_id'])
                                        .collection("request")
                                        .doc(request!.id)
                                        .update({"read": true});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                MeetUpDetails(request!, clr)));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: height / 6.8,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 50,
                                              vertical: height / 100),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(10),
                                              ),
                                            ),
                                            height: height / 13,
                                            width: width / 9,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                request!['buyer_image'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: height / 120.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Meet up request accepted',
                                                            style: TextStyle(
                                                              color: request![
                                                                      "read"]
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize:
                                                                  width / 21,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        width /
                                                                            60),
                                                            child: Text(
                                                                '🕒${request!['time']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: request![
                                                                          "read"]
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      'Meet up request was re-accepted by ${request!["buyer_name"]}',
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: request!["read"]
                                                            ? Colors.grey
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: width / 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                    : text == "cancelled"
                        ? request!['declinedBy'] !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                request!['buyer_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 60),
                                child: GestureDetector(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("requests")
                                        .doc(request!['seller_id'])
                                        .collection("request")
                                        .doc(request!.id)
                                        .update({"read": true});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                MeetUpDetails(request!, clr)));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: height / 6.8,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 40,
                                              vertical: height / 100),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(10),
                                              ),
                                            ),
                                            height: height / 13,
                                            width: width / 9,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                request!['seller_image'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: height / 100.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Meet up request cancelled',
                                                            style: TextStyle(
                                                              color: request![
                                                                      "read"]
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize:
                                                                  width / 21,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        width /
                                                                            60),
                                                            child: Text(
                                                              '🕒${request!['time']}',
                                                              style: TextStyle(
                                                                color: request![
                                                                        "read"]
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      'Your meet up request was declined by ${request!["seller_name"]}',
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: request!["read"]
                                                            ? Colors.grey
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: width / 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : request!['declinedBy'] !=
                                        FirebaseAuth
                                            .instance.currentUser!.uid &&
                                    request!['seller_id'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                ? Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width / 60),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection("requests")
                                            .doc(request!['seller_id'])
                                            .collection("request")
                                            .doc(request!.id)
                                            .update({"read": true});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => MeetUpDetails(
                                                    request!, clr)));
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 6.8,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 40,
                                                  vertical: height / 100),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    bottom: Radius.circular(10),
                                                  ),
                                                ),
                                                height: height / 13,
                                                width: width / 9,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    request!['buyer_image'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: height / 100.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                'Meet up request cancelled',
                                                                style:
                                                                    TextStyle(
                                                                  color: request![
                                                                          "read"]
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      width /
                                                                          21,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                60),
                                                                child: Text(
                                                                  '🕒${request!['time']}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: request![
                                                                            "read"]
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          'Meet up declined by ${request!["buyer_name"]}',
                                                          //overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: request![
                                                                    "read"]
                                                                ? Colors.grey
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize:
                                                                width / 24,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                        : Container();
  }
}
