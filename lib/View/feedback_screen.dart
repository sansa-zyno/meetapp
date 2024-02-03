import 'package:achievement_view/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  String id;
  String name;
  String image;
  FeedbackScreen(this.id, this.name, this.image);
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late UserController _currentUser;
  TextEditingController commentController = TextEditingController();
  bool positive = false;
  bool neutral = true;
  bool negative = false;
  int ratedValue = 0;
  String ratedValueString = "Neutral";
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
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
                      "Feedback",
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
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "How do you rate ${widget.name}?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(widget.image, fit: BoxFit.cover)),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              positive = true;
                              negative = false;
                              neutral = false;
                              ratedValue = 1;
                              ratedValueString = "Positive";
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                  ),
                                  color: Colors.white),
                              child: Text(
                                "Positive",
                                style: TextStyle(
                                    color:
                                        positive ? Colors.blue : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              positive = false;
                              negative = false;
                              neutral = true;
                              ratedValue = 0;
                              ratedValueString = "Neutral";
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.zero,
                                  color: Colors.white),
                              child: Text(
                                "Neutral",
                                style: TextStyle(
                                    color: neutral ? Colors.blue : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              positive = false;
                              negative = true;
                              neutral = false;
                              ratedValue = -1;
                              ratedValueString = "Negative";
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                  ),
                                  color: Colors.white),
                              child: Text(
                                "Negative",
                                style: TextStyle(
                                    color:
                                        negative ? Colors.blue : Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: "Leave a comment here"),
                              controller: commentController,
                              maxLines: 10,
                              maxLength: 450,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    greatBuyer = true;
                    friendly = false;
                    option = "Great buyer to deal with!";
                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Great buyer to deal with!",
                        style: TextStyle(
                            color: greatBuyer ? Colors.blue : Colors.black,
                            fontSize: 16),
                      )),
                )),
                SizedBox(width: 5),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    greatBuyer = false;
                    friendly = true;
                    option = "Friendly and delightful!";
                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Friendly and delightful!",
                        style: TextStyle(
                            color: friendly ? Colors.blue : Colors.black,
                            fontSize: 16),
                      )),
                ))
              ]),
            ),*/
            SizedBox(height: 30),
            Container(
              width: 220,
              height: 50,
              child: GradientButton(
                title: "Submit",
                clrs: [Colors.blue, Colors.blue],
                onpressed: () async {
                  if (submitted == false) {
                    submitted = true;
                    DocumentReference docRef = FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.id);
                    DocumentSnapshot doc = await docRef.get();
                    List ratings = doc["ratings"];
                    ratings.add(ratedValue);
                    await docRef.update({"ratings": ratings});

                    await FirebaseFirestore.instance
                        .collection("reviews")
                        .doc(widget.id)
                        .set({"r": "r"});
                    await FirebaseFirestore.instance
                        .collection("reviews")
                        .doc(widget.id)
                        .collection("review")
                        .add({
                      "ts": DateTime.now(),
                      "rating": ratedValueString,
                      "comment": commentController.text,
                      "raterName": _currentUser.getCurrentUser.displayName,
                      "raterImage": _currentUser.getCurrentUser.avatarUrl,
                      "raterId": _currentUser.getCurrentUser.uid,
                      "raterCountry": _currentUser.getCurrentUser.country
                    });
                    AchievementView(
                      color: Colors.green,
                      icon: Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                      ),
                      title: "Thank you!",
                      elevation: 20,
                      subTitle: "Your feedback was sent successfully",
                      isCircle: true,
                    ).show(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (ctx) => BottomNavBar()),
                        (route) => false);
                  } else {}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
