import 'package:flutter/material.dart';
import 'package:meeter/View/Profile/love_confirm.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoveSetup extends StatefulWidget {
  _LoveSetupState createState() => _LoveSetupState();
}

class _LoveSetupState extends State<LoveSetup> {
  //bool fitness = false;
  //bool startup = false;
  //bool lifeskills = false;
  //bool dating = false;
  //bool academic = false;
  //bool employement = false;
  //bool advice = false;

  List<String> pop = [];

  List<dynamic> values = [];
  late int val;

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
                      text: "Pop the items which you are interested in",
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
                                    .collection("InterestDynamic")
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
                                    .collection("InterestDynamic")
                                    .doc("dynamic")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.data() != null) {
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
                                                    print(pop);
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
                            child: LoveConfirm(
                              choices: pop,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          MeeterAppbar(
            title: "Select your interests!",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
