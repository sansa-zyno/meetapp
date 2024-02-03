import 'package:flutter/material.dart';
import 'package:meeter/View/Profile/about_you_confirm.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YouSetup extends StatefulWidget {
  _YouSetupState createState() => _YouSetupState();
}

class _YouSetupState extends State<YouSetup> {
  //bool parent = false;
  //bool scholar = false;
  //bool student = false;
  // bool entrepreneur = false;
  //bool job = false;
  //bool freelancer = false;
  //bool employeer = false;

  List<dynamic> values = [];
  late int val;

  List<String> pop = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 180,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PoppinsText(
                      text: "TELL US ABOUT YOURSELF",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      clr: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("AboutDynamic")
                                    .doc("dynamic")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.data() != null) {
                                    values = snapshot.data!["values"];
                                    val = values.length;
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: val % 2 == 0
                                          ? (val / 2).toInt()
                                          : (val / 2).toInt() + 1,
                                      itemBuilder: (context, index) {
                                        return pop.contains(values[val % 2 == 0
                                                ? index
                                                : index + 1])
                                            ? Container()
                                            : GestureDetector(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 15),
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff00AEFF),
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: PoppinsText(
                                                      text: values[index],
                                                      clr: Color(0xff00AEFF),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    pop.add(values[val % 2 == 0
                                                        ? index
                                                        : index + 1]);
                                                  });
                                                },
                                              );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("AboutDynamic")
                                    .doc("dynamic")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.data() != null) {
                                    values = snapshot.data!["values"];
                                    val = values.length;
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: (val / 2).toInt(),
                                      itemBuilder: (context, index) {
                                        return pop.contains(values[
                                                (val / 2).toInt() + index])
                                            ? Container()
                                            : GestureDetector(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 15),
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff00AEFF),
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: PoppinsText(
                                                      text: values[val % 2 == 0
                                                          ? (val / 2).toInt() +
                                                              index
                                                          : (val / 2).toInt() +
                                                              1 +
                                                              index],
                                                      clr: Color(0xff00AEFF),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    pop.add(values[
                                                        (val / 2).toInt() +
                                                            index]);
                                                  });
                                                },
                                              );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 270,
                    height: 50,
                    child: GradientButton(
                      title: "Continue",
                      fontSize: 12,
                      clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                      onpressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: AboutYouConfirm(
                              choices: pop,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          MeeterAppbar(
            title: "Click on all which applies to you!",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
