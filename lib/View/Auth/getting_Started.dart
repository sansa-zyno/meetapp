import 'package:flutter/material.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:page_transition/page_transition.dart';
import 'authMain.dart';

class GettingStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: PoppinsText(
                              text:
                                  "“Life-changing encounter, one Meeter away”",
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              clr: Color(0xff00AEFF),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(25),
                            child: Image.asset(
                                "assets/images/Videoconferencing.png")),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: PoppinsText(
                              text: "Welcome to Meeter",
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              clr: Color(0xff00AEFF),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: PoppinsText(
                                text:
                                    "Making Every Connection Just A Meeter Away",
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                                clr: Colors.grey),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 50,
                          child: Hero(
                            tag: "Login",
                            child: GradientButton(
                                title: "Sign in",
                                clrs: const [
                                  Color(0xff00AEFF),
                                  Color(0xff00AEFF)
                                ],
                                onpressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: AuthMain(),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
