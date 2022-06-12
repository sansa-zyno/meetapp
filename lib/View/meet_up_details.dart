import 'dart:async';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/View/Profile/profile_screen_others.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/View/edit_request_offer_screen.dart';
import 'package:meeter/View/timer_screen.dart';
import 'package:meeter/View/chat_screen.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Providers/user_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeetUpDetails extends StatefulWidget {
  final DocumentSnapshot request;
  final Color clr;
  const MeetUpDetails(this.request, this.clr);

  @override
  _MeetUpDetailsState createState() => _MeetUpDetailsState();
}

class _MeetUpDetailsState extends State<MeetUpDetails> {
  late OurUser buyerDetails;
  late OurUser sellerDetails;
  UserController userController = UserController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a\_${widget.request["product_id"]}";
    } else if (a.substring(0, 1).codeUnitAt(0) ==
        b.substring(0, 1).codeUnitAt(0)) {
      if (a == buyerDetails.displayName) {
        return "$a\_$b\_${widget.request["product_id"]}";
      } else {
        return "$b\_$a\_${widget.request["product_id"]}";
      }
    } else {
      return "$a\_$b\_${widget.request["product_id"]}";
    }
  }

  getBuyerDetails() async {
    buyerDetails = await userController.getUserInfo(widget.request['buyer_id']);
    setState(() {});
  }

  getSellerDetails() async {
    sellerDetails =
        await userController.getUserInfo(widget.request['seller_id']);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBuyerDetails();
    getSellerDetails();
    FirebaseFirestore.instance
        .collection("requests")
        .doc(widget.request['seller_id'])
        .collection('request')
        .doc(widget.request.id)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        List meeters = event["meeters"];
        if (meeters.isEmpty) {
          AchievementView(
            context,
            color: Colors.green,
            icon: Icon(
              FontAwesomeIcons.cancel,
              color: Colors.white,
            ),
            title: "Declined",
            elevation: 20,
            subTitle: "This meetup request was declined",
            isCircle: true,
          ).show();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<UserController>(context);
    TextStyle defaultStyle = TextStyle(color: Colors.black, fontSize: 18.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      key: _scacffoldKey,
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
                      "MeetUp Details",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style: defaultStyle,
                      children: <TextSpan>[
                        TextSpan(text: 'Requested by '),
                        FirebaseAuth.instance.currentUser!.uid !=
                                widget.request['buyer_id']
                            ? TextSpan(
                                text: "${widget.request['buyer_name']}",
                                style: linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ProfileScreenOther(
                                                  id: widget
                                                      .request['buyer_id'],
                                                )));
                                  })
                            : TextSpan(
                                text: 'me',
                                style: linkStyle,
                              ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${widget.request['title']}",
                      style: TextStyle(
                          color: widget.clr,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              widget.request['question'] == ""
                  ? Container()
                  : SizedBox(height: 5),
              widget.request['question'] == ""
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Question: ${widget.request['question']}",
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
              SizedBox(height: 20),
              Row(children: [
                Icon(Icons.calendar_view_day),
                SizedBox(width: 8),
                Text(
                  "\$${widget.request['price']}",
                ),
              ]),
              SizedBox(height: 30),
              Row(children: [
                Icon(Icons.alarm),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.request['date']}"),
                    SizedBox(height: 3),
                    Text("${widget.request['time']}"),
                  ],
                ),
              ]),
              SizedBox(height: 20),
              widget.request['location'] == "Physical"
                  ? StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("requests")
                          .doc(widget.request['seller_id'])
                          .collection('request')
                          .doc(widget.request.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? snapshot.data!["accepted"] != false
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Location: ${widget.request['location_address']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                            : Container();
                      })
                  : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("requests")
                          .doc(widget.request['seller_id'])
                          .collection('request')
                          .doc(widget.request.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? snapshot.data!["accepted"] != false
                                ? Row(
                                    children: [
                                      Text(
                                        "Location: Virtual",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                    ],
                                  )
                                : Container()
                            : Container();
                      }),
              SizedBox(height: 5),
              widget.request['location'] == "Physical"
                  ? StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("requests")
                          .doc(widget.request['seller_id'])
                          .collection('request')
                          .doc(widget.request.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? snapshot.data!["accepted"] != false
                                ? Container(
                                    height: 300.0,
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      markers: Set<Marker>.of([
                                        Marker(
                                            markerId: MarkerId(widget
                                                .request['location_address']),
                                            draggable: false,
                                            visible: true,
                                            infoWindow: InfoWindow(
                                                title: widget.request[
                                                    'location_address'],
                                                snippet: null),
                                            position: LatLng(
                                                widget.request['placeLat']
                                                    .toDouble(),
                                                widget.request['placeLng']
                                                    .toDouble()))
                                      ]),
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            widget.request['placeLat']
                                                .toDouble(),
                                            widget.request['placeLng']
                                                .toDouble()),
                                        zoom: 14,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _mapController.complete(controller);
                                      },
                                    ))
                                : Container()
                            : Container();
                      })
                  : Container(),
              SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("requests")
                            .doc(widget.request['seller_id'])
                            .collection('request')
                            .doc(widget.request.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          DocumentSnapshot? doc =
                              snapshot.data as DocumentSnapshot?;
                          return snapshot.hasData && doc!.data() != null
                              ? doc['accepted'] == null
                                  ? GestureDetector(
                                      onTap: () async {
                                        await Database().acceptRequest(
                                            widget.request['seller_id'],
                                            widget.request.id,
                                            widget.request['buyer_id']);
                                        AchievementView(
                                          context,
                                          color: Colors.green,
                                          icon: Icon(
                                            FontAwesomeIcons.check,
                                            color: Colors.white,
                                          ),
                                          title: "Succesfull !",
                                          elevation: 20,
                                          subTitle:
                                              "Meetup request accepted succesfully",
                                          isCircle: true,
                                        ).show();
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget.clr),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: widget.clr,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Accept',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container();
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("requests")
                            .doc(widget.request['seller_id'])
                            .collection('request')
                            .doc(widget.request.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          DocumentSnapshot? doc =
                              snapshot.data as DocumentSnapshot?;
                          return snapshot.hasData && doc!.data() != null
                              ? (doc['accepted'] ?? true)
                                  ? GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'Are you sure to decline meeting ?'),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("Yes"),
                                                      onPressed: () async {
                                                        await Database()
                                                            .cancelRequest(
                                                          widget.request[
                                                              'seller_id'],
                                                          widget.request.id,
                                                        );
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ));
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget.clr),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: widget.clr,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Decline',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container();
                        }),
                    SizedBox(height: 15),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("requests")
                            .doc(widget.request['seller_id'])
                            .collection('request')
                            .doc(widget.request.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? snapshot.data!["accepted"] != false
                                  ? GestureDetector(
                                      onTap: () {
                                        String date = widget.request['date'];
                                        int duration =
                                            widget.request['duration'];
                                        int startHour =
                                            widget.request['startTime']['hour'];
                                        int startMin =
                                            widget.request['startTime']['min'];
                                        int timeInMin = (startHour * 60) +
                                            startMin +
                                            duration;
                                        String endTime =
                                            "${(timeInMin ~/ 60).floor() < 10 ? "0" : ""}${(timeInMin ~/ 60).floor()}:${(timeInMin % 60).floor() < 10 ? "0" : ""}${(timeInMin % 60).floor()}";
                                        String formattedString =
                                            "$date $endTime";
                                        DateTime dateTime =
                                            DateTime.parse(formattedString);
                                        if (dateTime
                                                .difference(DateTime.now()) >
                                            Duration(hours: 24)) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      EditRequestOffer(
                                                          doc: widget.request,
                                                          clr: widget.clr)));
                                        } else {
                                          _scacffoldKey.currentState!
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'Not available from 24 hours before the meeting',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget.clr),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: widget.clr,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Modify',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container();
                        }),
                    SizedBox(height: 15),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("requests")
                            .doc(widget.request['seller_id'])
                            .collection('request')
                            .doc(widget.request.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? snapshot.data!["accepted"] != false
                                  ? GestureDetector(
                                      onTap: () async {
                                        if (_currentUser.getCurrentUser.uid ==
                                            widget.request['seller_id']) {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          String userName = preferences
                                              .getString('userName')!;
                                          if (buyerDetails != null) {
                                            var chatroomId =
                                                getChatRoomIdByUsernames(
                                                    userName,
                                                    buyerDetails.displayName!);
                                            Map<String, dynamic> chatroomInfo =
                                                {
                                              "users": [
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                buyerDetails.uid
                                              ]
                                            };
                                            Database().createChatRoom(
                                                chatroomId, chatroomInfo);

                                            DocumentSnapshot doc =
                                                await FirebaseFirestore.instance
                                                    .collection("chatrooms")
                                                    .doc(chatroomId)
                                                    .get();
                                            Map<String, dynamic>? map =
                                                doc.data()
                                                    as Map<String, dynamic>?;
                                            if (map != null) {
                                              if (map.containsKey(
                                                  "lastMessageSendByUid")) {
                                                if (doc['lastMessageSendByUid'] !=
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  //get all messages that havent been read
                                                  QuerySnapshot q =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "chatrooms")
                                                          .doc(chatroomId)
                                                          .collection('chats')
                                                          .where("read",
                                                              isEqualTo: false)
                                                          .get();
                                                  //turn to read to pevent showing as unread in chat history
                                                  for (int i = 0;
                                                      i < q.docs.length;
                                                      i++) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("chatrooms")
                                                        .doc(chatroomId)
                                                        .collection('chats')
                                                        .doc(q.docs[i].id)
                                                        .update({"read": true});
                                                  }

                                                  //turn to read to prevent showing here again
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("chatrooms")
                                                      .doc(chatroomId)
                                                      .update({"read": true});
                                                }
                                              }
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(buyerDetails,
                                                        chatroomId),
                                              ),
                                            );
                                          } else {}
                                          ;
                                        } else {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          String userName = preferences
                                              .getString('userName')!;
                                          if (sellerDetails != null) {
                                            var chatroomId =
                                                getChatRoomIdByUsernames(
                                                    userName,
                                                    sellerDetails.displayName!);
                                            Map<String, dynamic> chatroomInfo =
                                                {
                                              "users": [
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                sellerDetails.uid
                                              ]
                                            };
                                            Database().createChatRoom(
                                                chatroomId, chatroomInfo);

                                            DocumentSnapshot doc =
                                                await FirebaseFirestore.instance
                                                    .collection("chatrooms")
                                                    .doc(chatroomId)
                                                    .get();
                                            Map<String, dynamic>? map =
                                                doc.data()
                                                    as Map<String, dynamic>?;
                                            if (map != null) {
                                              if (map.containsKey(
                                                  "lastMessageSendByUid")) {
                                                if (doc['lastMessageSendByUid'] !=
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  //get all messages that havent been read
                                                  QuerySnapshot q =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "chatrooms")
                                                          .doc(chatroomId)
                                                          .collection('chats')
                                                          .where("read",
                                                              isEqualTo: false)
                                                          .get();
                                                  //turn to read to pevent showing as unread in chat history
                                                  for (int i = 0;
                                                      i < q.docs.length;
                                                      i++) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("chatrooms")
                                                        .doc(chatroomId)
                                                        .collection('chats')
                                                        .doc(q.docs[i].id)
                                                        .update({"read": true});
                                                  }

                                                  //turn to read to prevent showing here again
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("chatrooms")
                                                      .doc(chatroomId)
                                                      .update({"read": true});
                                                }
                                              }
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(sellerDetails,
                                                        chatroomId),
                                              ),
                                            );
                                          } else {}
                                          ;
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget.clr),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: widget.clr,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Chat',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container();
                        }),
                    SizedBox(height: 15),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("requests")
                            .doc(widget.request['seller_id'])
                            .collection('request')
                            .doc(widget.request.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? snapshot.data!["accepted"] != null &&
                                      snapshot.data!["accepted"] != false
                                  ? GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                Timer(widget.request),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget.clr),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: widget.clr,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Start Meeting',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container();
                        })
                  ],
                ),
              ),
              widget.request['accepted'] == false
                  ? SizedBox(height: 50)
                  : Container(),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("requests")
                      .doc(widget.request['seller_id'])
                      .collection('request')
                      .doc(widget.request.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? snapshot.data!['accepted'] == false
                            ? Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    AchievementView(
                                      context,
                                      color: Colors.green,
                                      icon: Icon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                      ),
                                      title: "Deleted",
                                      elevation: 20,
                                      subTitle:
                                          "This meetup request was deleted successfully",
                                      isCircle: true,
                                    ).show();
                                    Navigator.pop(context);
                                    await FirebaseFirestore.instance
                                        .collection('requests')
                                        .doc(widget.request['seller_id'])
                                        .collection('request')
                                        .doc(widget.request.id)
                                        .delete();
                                  },
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: widget.clr),
                                      borderRadius: BorderRadius.circular(15),
                                      color: widget.clr,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Delete',
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        : Container();
                  }),
              SizedBox(height: 30),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("requests")
                      .doc(widget.request['seller_id'])
                      .collection('request')
                      .doc(widget.request.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? snapshot.data!["accepted"] != false
                            ? Text(
                                "Warning: Modification will not be available from 24 hours before the meeting")
                            : Container()
                        : Container();
                  }),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
