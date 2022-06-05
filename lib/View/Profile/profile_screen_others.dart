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

  getUserDetails() async {
    userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .get();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: userDoc != null ? 230 : kToolbarHeight,
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
                            child: Image.network(
                          userDoc!['bannerImage'],
                          fit: BoxFit.fitWidth,
                        )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: CircularProfileAvatar(
                          userDoc!['avatarUrl'] ?? '',
                          backgroundColor: Colors.black,
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
                          borderColor: Colors.black,
                          borderWidth: 5,
                          elevation: 10,
                          radius: 50,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      body: userDoc != null
          ? Container(
              child: SingleChildScrollView(
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
                                title: "Connection",
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
                                title: "Achievement",
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
                    about == true ? About(userDoc!, widget.id) : Container(),
                    service == true ? Services(widget.id) : Container(),
                    review == true ? Review() : Container(),
                  ],
                ),
              ),
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
