import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/guide_user.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';

class InterestedSelling extends StatefulWidget {
  _InterestedSellingState createState() => _InterestedSellingState();
}

class _InterestedSellingState extends State<InterestedSelling> {
  late UserController _currentUser;

  bool yes = false;
  bool no = false;

  getCurrentUser() async {
    await _currentUser.getCurrentUserInfo();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _currentUser = Provider.of<UserController>(context, listen: false);
      getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              //height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 140,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PoppinsText(
                      text: "Are you interested in selling your lunch time?",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      clr: Colors.grey,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        !yes
                            ? GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff00AEFF),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: PoppinsText(
                                      text: "YES",
                                      clr: Color(0xff00AEFF),
                                      fontWeight: FontWeight.bold,
                                      align: TextAlign.center,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    yes = !yes;
                                  });

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: GuideUser(),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        !no
                            ? GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 15),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff00AEFF),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PoppinsText(
                                          text: "NO",
                                          clr: Color(0xff00AEFF),
                                          fontWeight: FontWeight.bold,
                                          align: TextAlign.center,
                                          fontSize: 30,
                                        ),
                                        PoppinsText(
                                          text:
                                              "(You can set it up later if you change your mind)",
                                          clr: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          align: TextAlign.center,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    no = !no;
                                  });

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: BottomNavBar(),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 50,
                              child: GradientButton(
                                title: "Continue",
                                clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                                fontSize: 16,
                                letterSpacing: 0,
                                onpressed: () {
                                  if (no == true) {
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.rightToLeft,
                                    //     duration: Duration(milliseconds: 200),
                                    //     curve: Curves.easeIn,
                                    //     child: Profile(),
                                    //   ),
                                    // );
                                  } else {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                        child: GuideUser(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          MeeterAppbar(
            title: "Setup a sellers listing?",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
