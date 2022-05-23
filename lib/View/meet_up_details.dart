import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/View/Profile/profile_screen_others.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/View/edit_request_offer_screen.dart';
import 'package:meeter/View/timer_screen.dart';
import 'package:meeter/View/chat_screen.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar_buyer.dart';
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
  String deleter = "";
  UserController userController = UserController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();

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
      event.data() != null
          ? {}
          : AchievementView(
              context,
              color: Colors.green,
              icon: Icon(
                FontAwesomeIcons.check,
                color: Colors.white,
              ),
              title: deleter == FirebaseAuth.instance.currentUser!.uid
                  ? "Success!"
                  : "Alert!",
              elevation: 20,
              subTitle: deleter == FirebaseAuth.instance.currentUser!.uid
                  ? "This request was deleted successfully"
                  : "This request was deleted by the other party",
              isCircle: true,
            ).show();
      event.data() != null ? {} : Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<UserController>(context);
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return Scaffold(
      key: _scacffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
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
                                : TextSpan(text: 'me'),
                          ],
                        ),
                      )
                      /*Text(" By ${widget.request['seller_name']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))*/
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("${widget.request['desc']}",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                  SizedBox(height: 20),
                  Row(children: [
                    Icon(Icons.calendar_view_day),
                    SizedBox(width: 8),
                    Text(
                      "${widget.request['price']}",
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
                  Row(children: [
                    widget.request['location'] == "Physical"
                        ? Text("${widget.request['location_address']}")
                        : Text("Virtual")
                  ]),
                  SizedBox(height: 50),
                  widget.request.exists
                      ? Center(
                          child: Column(
                            children: [
                              widget.request['declinedBy'] == "" ||
                                      widget.request['declinedBy'] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("requests")
                                          .doc(widget.request['seller_id'])
                                          .collection('request')
                                          .doc(widget.request.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        DocumentSnapshot? doc =
                                            snapshot.data as DocumentSnapshot?;
                                        return snapshot.hasData &&
                                                doc!.data() != null
                                            ? !(doc['accepted'] ?? false)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      await Database()
                                                          .acceptRequest(
                                                              widget.request[
                                                                  'seller_id'],
                                                              widget.request.id,
                                                              widget.request[
                                                                  'buyer_id']);
                                                      AchievementView(
                                                        context,
                                                        color: Colors.green,
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .check,
                                                          color: Colors.white,
                                                        ),
                                                        title: "Succesfull !",
                                                        elevation: 20,
                                                        subTitle:
                                                            "Request accepted succesfully",
                                                        isCircle: true,
                                                      ).show();
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: widget.clr),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: widget.clr,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Accept',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                            : Container();
                                      })
                                  : Container(),
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
                                    return snapshot.hasData &&
                                            doc!.data() != null
                                        ? (doc['accepted'] ?? false)
                                            ? GestureDetector(
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Are you sure to cancel meeting ?'),
                                                            actions: [
                                                              FlatButton(
                                                                child:
                                                                    Text("Yes"),
                                                                onPressed:
                                                                    () async {
                                                                  await Database()
                                                                      .cancelRequest(
                                                                    widget.request[
                                                                        'seller_id'],
                                                                    widget
                                                                        .request
                                                                        .id,
                                                                  );
                                                                  AchievementView(
                                                                    context,
                                                                    color: Colors
                                                                        .green,
                                                                    icon: Icon(
                                                                      FontAwesomeIcons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    title:
                                                                        "Succesfull!",
                                                                    elevation:
                                                                        20,
                                                                    subTitle:
                                                                        "Request Cancelled succesfully",
                                                                    isCircle:
                                                                        true,
                                                                  )..show();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child:
                                                                    Text("No"),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )
                                                            ],
                                                          ));
                                                },
                                                child: Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: widget.clr),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: widget.clr,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('Cancel',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Container();
                                  }),
                              SizedBox(height: 15),
                              widget.request["accepted"] == null ||
                                      widget.request["accepted"] == true
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
                                  : Container(),
                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: () async {
                                  if (_currentUser.getCurrentUser.uid ==
                                      widget.request['seller_id']) {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    String userName =
                                        preferences.getString('userName')!;
                                    if (buyerDetails != null) {
                                      var chatroomId = getChatRoomIdByUsernames(
                                          userName, buyerDetails.displayName!);
                                      Map<String, dynamic> chatroomInfo = {
                                        "users": [
                                          userName,
                                          buyerDetails.displayName
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
                                          doc.data() as Map<String, dynamic>?;
                                      if (map != null) {
                                        if (map
                                            .containsKey("lastMessageSendBy")) {
                                          if (doc['lastMessageSendBy'] !=
                                              userName) {
                                            //get all messages that havent been read
                                            QuerySnapshot q =
                                                await FirebaseFirestore.instance
                                                    .collection("chatrooms")
                                                    .doc(chatroomId)
                                                    .collection('chats')
                                                    .where("read",
                                                        isEqualTo: false)
                                                    .get();
                                            //turn to read to pevent showing as unread in chat history
                                            for (int i = 0;
                                                i < q.docs.length;
                                                i++) {
                                              await FirebaseFirestore.instance
                                                  .collection("chatrooms")
                                                  .doc(chatroomId)
                                                  .collection('chats')
                                                  .doc(q.docs[i].id)
                                                  .update({"read": true});
                                            }

                                            //turn to read to prevent showing here again
                                            await FirebaseFirestore.instance
                                                .collection("chatrooms")
                                                .doc(chatroomId)
                                                .update({"read": true});
                                          }
                                        }
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              buyerDetails, chatroomId),
                                        ),
                                      );
                                    } else {}
                                    ;
                                  } else {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    String userName =
                                        preferences.getString('userName')!;
                                    if (sellerDetails != null) {
                                      var chatroomId = getChatRoomIdByUsernames(
                                          userName, sellerDetails.displayName!);
                                      Map<String, dynamic> chatroomInfo = {
                                        "users": [
                                          userName,
                                          sellerDetails.displayName
                                        ]
                                      };
                                      Database().createChatRoom(
                                          chatroomId, chatroomInfo);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              sellerDetails, chatroomId),
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
                                    borderRadius: BorderRadius.circular(15),
                                    color: widget.clr,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Chat',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              widget.request["accepted"] == null ||
                                      widget.request["accepted"] == true
                                  ? GestureDetector(
                                      onTap: () async {
                                        /* SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        String userName =
                                            preferences.getString('userName')!;

                                        if (widget.request['seller_id'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          var connectionRoomId =
                                              getChatRoomIdByUsernames(userName,
                                                  widget.request['buyer_id']);
                                          Map<String, dynamic>
                                              connectionRoomInfo = {
                                            "users": [
                                              userName,
                                              widget.request['buyer_name']
                                            ]
                                          };
                                          Database().createChatRoom(
                                              connectionRoomId,
                                              connectionRoomInfo);
                                        } else if (widget.request['buyer_id'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          var connectionRoomId =
                                              getChatRoomIdByUsernames(userName,
                                                  widget.request['seller_id']);
                                          Map<String, dynamic>
                                              connectionRoomInfo = {
                                            "users": [
                                              userName,
                                              widget.request['seller_name']
                                            ]
                                          };
                                          Database().createChatRoom(
                                              connectionRoomId,
                                              connectionRoomInfo);
                                        }*/

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
                                  : Container(),
                              SizedBox(height: 15),
                              widget.request["accepted"] != null &&
                                      widget.request["accepted"] == false
                                  ? GestureDetector(
                                      onTap: () async {
                                        deleter = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        setState(() {});
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(widget.request['seller_id'])
                                            .collection('request')
                                            .doc(widget.request.id)
                                            .delete();
                                        Navigator.pop(context);
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
                                          child: Text('Delete',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: 30),
                  widget.request["accepted"] == null ||
                          widget.request["accepted"] == true
                      ? Text(
                          "Warning: Modification will not be available from 24 hours before the meeting")
                      : Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 7,
                              left: MediaQuery.of(context).size.width / 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                "This meet up request has been cancelled",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 16),
                              ))
                            ],
                          ),
                        ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          widget.clr == Colors.blue
              ? MeeterAppbar(
                  title: "Meet Up Details",
                  icon: Icons.arrow_back_rounded,
                )
              : MeeterAppbarBuyer(
                  title: "Meet Up Details",
                  icon: Icons.arrow_back_rounded,
                )
        ],
      ),
    );
  }
}
