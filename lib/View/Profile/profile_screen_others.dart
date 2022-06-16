import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:meeter/View/Profile/profile_screen_others_widgets/about.dart';
import 'package:meeter/View/Profile/profile_screen_others_widgets/achievement.dart';
import 'package:meeter/View/Profile/profile_screen_others_widgets/connection.dart';
import 'package:meeter/View/Profile/profile_screen_others_widgets/reviews.dart';
import 'package:meeter/View/Profile/profile_screen_others_widgets/service.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenOther extends StatefulWidget {
  final String id;
  ProfileScreenOther({required this.id});

  @override
  _ProfileScreenOtherState createState() => _ProfileScreenOtherState();
}

class _ProfileScreenOtherState extends State<ProfileScreenOther> {
  final controller = PageController();
  DocumentSnapshot? userDoc;

  List<String> count = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
    "Seventh",
    "Eightth",
    "Nineth",
    "Tenth"
  ];

  bool about = true;
  bool service = false;
  bool review = false;
  String? recentMeetingDate;

  getUserDetails() async {
    userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .get();
    setState(() {});
  }

  getRecentMeeting() async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("connections")
        .where("meeters", arrayContains: widget.id)
        .orderBy("ts", descending: true)
        .get();
    recentMeetingDate = q.docs.isNotEmpty ? q.docs[0]["date"] : null;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    getRecentMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 230,
        flexibleSpace: SafeArea(
          child: userDoc != null
              ? Stack(
                  children: [
                    Container(
                      height: 230,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        child: Container(
                            child: userDoc!['bannerImage'] != null
                                ? Image.network(
                                    userDoc!['bannerImage'],
                                    fit: BoxFit.fitWidth,
                                  )
                                : Container()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: CircularProfileAvatar(
                          userDoc!['avatarUrl'] ?? '',
                          backgroundColor: Color(0xffDCf0EF),
                          initialsText: Text(
                            "+",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w900,
                                fontSize: 21,
                                color: Colors.white),
                          ),
                          cacheImage: true,
                          borderWidth: 2,
                          elevation: 10,
                          radius: 50,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.transparent,
      ),
      body: userDoc != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: PoppinsText(
                      text: userDoc!['displayName'] ?? '',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Positive',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PoppinsText(
                    text: userDoc!['country'] ?? '',
                    fontSize: 12,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 50,
                            child: GradientButton(
                              title: "Connections",
                              clrs: [Colors.blue, Colors.blue],
                              fontSize: 12,
                              letterSpacing: 0,
                              onpressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            Connection(widget.id)));
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 50,
                            child: GradientButton(
                              fontSize: 12,
                              letterSpacing: 0,
                              title: "Achievements",
                              textClr: Color(0xff00AEFF),
                              clrs: [Colors.white, Colors.white],
                              border: Border.all(color: Colors.blue),
                              onpressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => Achievement()));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              border: about == true
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Color(0xff00AEFF),
                                        width: 2,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: PoppinsText(
                                text: "About",
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              about = true;
                              service = false;
                              review = false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              border: service == true
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Color(0xff00AEFF),
                                        width: 2,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: PoppinsText(
                                text: "Services ",
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              about = false;
                              service = true;
                              review = false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              border: review == true
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Color(0xff00AEFF),
                                        width: 2,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: PoppinsText(
                                text: "Reviews ",
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              about = false;
                              service = false;
                              review = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  about == true
                      ? About(userDoc!, widget.id, recentMeetingDate)
                      : Container(),
                  service == true ? Services(widget.id) : Container(),
                  review == true ? Review() : Container(),
                ],
              ),
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
