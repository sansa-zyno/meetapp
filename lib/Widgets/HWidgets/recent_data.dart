import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/View/meet_up_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/View/chat_screen.dart';

class RecentData extends StatefulWidget {
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
  State<RecentData> createState() => _RecentDataState();
}

class _RecentDataState extends State<RecentData> {
  String startTime = "";
  String endTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.request != null) {
      startTime = formatDate(
          widget.request!['startDateTime'].toDate(), [hh, ':', nn, '', am]);
      endTime = formatDate(
          widget.request!['endDateTime'].toDate(), [hh, ':', nn, '', am]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return widget.text == "new"
        ? widget.request!['seller_id'] == FirebaseAuth.instance.currentUser!.uid
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 60),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection("requests")
                        .doc(widget.request!['seller_id'])
                        .collection("request")
                        .doc(widget.request!.id)
                        .update({"read": true});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                MeetUpDetails(widget.request!, widget.clr)));
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: height / 8,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 40, vertical: height / 10),
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
                                widget.request!['buyer_image'],
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
                                              color: widget.request!["read"]
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
                                            child: Text(
                                              '🕒$startTime-$endTime',
                                              style: TextStyle(
                                                color: widget.request!["read"]
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
                                      'You received a meet up request from ${widget.request!["buyer_name"]}',
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: widget.request!["read"]
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
        : widget.text == "msg"
            ? widget.msg!["lastMessageSendByUid"] !=
                    FirebaseAuth.instance.currentUser!.uid
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 60),
                    child: GestureDetector(
                      onTap: () async {
                        QuerySnapshot _doc = await FirebaseFirestore.instance
                            .collection('users')
                            .where('uid',
                                isEqualTo: widget.msg!["lastMessageSendByUid"])
                            .get();
                        OurUser user = OurUser.fromFireStore(_doc.docs[0]);
                        //get all messages that havent been read
                        QuerySnapshot q = await FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.msg!.id)
                            .collection('chats')
                            .where("read", isEqualTo: false)
                            .get();
                        //turn to read to pevent showing as unread in chat history
                        for (int i = 0; i < q.docs.length; i++) {
                          await FirebaseFirestore.instance
                              .collection("chatrooms")
                              .doc(widget.msg!.id)
                              .collection('chats')
                              .doc(q.docs[i].id)
                              .update({"read": true});
                        }
                        //turn to read to prevent showing here again
                        await FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.msg!.id)
                            .update({"read": true});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    ChatScreen(user, widget.msg!.id)));
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
                                    widget.msg!['lastMessageSendByImgUrl'],
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
                                                  color: widget.msg!["read"]
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
                                          'You received a new message from ${widget.msg!["lastMessageSendBy"]}',
                                          //overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: widget.msg!["read"]
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
            : widget.text == "modified"
                ? widget.request!['modifiedBy'] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                        widget.request!['buyer_id'] ==
                            FirebaseAuth.instance.currentUser!.uid
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 60),
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection("requests")
                                .doc(widget.request!['seller_id'])
                                .collection("request")
                                .doc(widget.request!.id)
                                .update({"read": true});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MeetUpDetails(
                                        widget.request!, widget.clr)));
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
                                        widget.request!['seller_image'],
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
                                                      color: widget
                                                              .request!["read"]
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
                                                      '🕒$startTime-$endTime',
                                                      style: TextStyle(
                                                        color: widget.request![
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
                                              'You received a meet up modification from ${widget.request!["seller_name"]}',
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: widget.request!["read"]
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
                    : widget.request!['modifiedBy'] !=
                                FirebaseAuth.instance.currentUser!.uid &&
                            widget.request!['seller_id'] ==
                                FirebaseAuth.instance.currentUser!.uid
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 60),
                            child: GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc(widget.request!['seller_id'])
                                    .collection("request")
                                    .doc(widget.request!.id)
                                    .update({"read": true});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MeetUpDetails(
                                            widget.request!, widget.clr)));
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
                                            widget.request!['buyer_image'],
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
                                                          color: widget
                                                                      .request![
                                                                  "read"]
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width / 60),
                                                        child: Text(
                                                          '🕒$startTime-$endTime',
                                                          style: TextStyle(
                                                            color:
                                                                widget.request![
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
                                                  'You received a meet up modification from ${widget.request!["buyer_name"]}',
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        widget.request!["read"]
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
                : widget.text == "accepted"
                    ? widget.request!['acceptedBy'] !=
                                FirebaseAuth.instance.currentUser!.uid &&
                            widget.request!['buyer_id'] ==
                                FirebaseAuth.instance.currentUser!.uid
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 60),
                            child: GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc(widget.request!['seller_id'])
                                    .collection("request")
                                    .doc(widget.request!.id)
                                    .update({"read": true});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MeetUpDetails(
                                            widget.request!, widget.clr)));
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
                                            widget.request!['seller_image'],
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
                                                          color: widget
                                                                      .request![
                                                                  "read"]
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width / 60),
                                                        child: Text(
                                                          '🕒$startTime-$endTime',
                                                          style: TextStyle(
                                                            color:
                                                                widget.request![
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
                                                  'Your meet up request was accepted by ${widget.request!["seller_name"]}',
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        widget.request!["read"]
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
                        : widget.request!['acceptedBy'] !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                widget.request!['seller_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 60),
                                child: GestureDetector(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("requests")
                                        .doc(widget.request!['seller_id'])
                                        .collection("request")
                                        .doc(widget.request!.id)
                                        .update({"read": true});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => MeetUpDetails(
                                                widget.request!, widget.clr)));
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
                                                widget.request!['buyer_image'],
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
                                                              color: widget
                                                                          .request![
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
                                                                '🕒$startTime-$endTime',
                                                                style:
                                                                    TextStyle(
                                                                  color: widget
                                                                              .request![
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
                                                      'Modified meet up request was accepted by ${widget.request!["buyer_name"]}',
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: widget.request![
                                                                "read"]
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
                    : widget.text == "declined"
                        ? widget.request!['declinedBy'] !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                widget.request!['buyer_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 60),
                                child: GestureDetector(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("requests")
                                        .doc(widget.request!['seller_id'])
                                        .collection("request")
                                        .doc(widget.request!.id)
                                        .update({"read": true});
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => MeetUpDetails(
                                                widget.request!, widget.clr)));
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
                                                widget.request!['seller_image'],
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
                                                            'Meet up request declined',
                                                            style: TextStyle(
                                                              color: widget
                                                                          .request![
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
                                                              '🕒$startTime-$endTime',
                                                              style: TextStyle(
                                                                color: widget.request![
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
                                                      'Your meet up request was declined by ${widget.request!["seller_name"]}',
                                                      //overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: widget.request![
                                                                "read"]
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
                            : widget.request!['declinedBy'] !=
                                        FirebaseAuth
                                            .instance.currentUser!.uid &&
                                    widget.request!['seller_id'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                60),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection("requests")
                                            .doc(widget.request!['seller_id'])
                                            .collection("request")
                                            .doc(widget.request!.id)
                                            .update({"read": true});

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => MeetUpDetails(
                                                    widget.request!,
                                                    widget.clr)));
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
                                                    widget.request![
                                                        'buyer_image'],
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
                                                                'Meet up request declined',
                                                                style:
                                                                    TextStyle(
                                                                  color: widget
                                                                              .request![
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
                                                                  '🕒$startTime-$endTime',
                                                                  style:
                                                                      TextStyle(
                                                                    color: widget.request![
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
                                                          'Meet up declined by ${widget.request!["buyer_name"]}',
                                                          //overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color:
                                                                widget.request![
                                                                        "read"]
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .black,
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
