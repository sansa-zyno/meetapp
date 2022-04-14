import 'package:flutter/material.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:page_transition/page_transition.dart';
import './meet_setup.dart';

class GuideUser extends StatefulWidget {
  _GuideUserState createState() => _GuideUserState();
}

class _GuideUserState extends State<GuideUser> {
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
                    height: 150,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PoppinsText(
                      text: "Thank you for opting to sell your time ",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      clr: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: PoppinsText(
                        text:
                            "“Let’s ease you in by setting up your first Meeter Gigs”You first have to set a Title of of your Meet-up. Below are some examples...",
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        clr: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff00AEFF),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Color(0xff00AEFF),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Container(
                              padding: EdgeInsets.all(30),
                              child: PoppinsText(
                                text:
                                    "I’m the creator of Meeter! Meet with me to learn more about Entre preneurship",
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                clr: Colors.black,
                                align: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff00AEFF),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Color(0xff00AEFF),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Container(
                              padding: EdgeInsets.all(30),
                              child: PoppinsText(
                                text:
                                    "“I’m a Mother of two! Meet with me about raising kids!” ",
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                clr: Colors.black,
                                align: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff00AEFF),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Color(0xff00AEFF),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Container(
                              padding: EdgeInsets.all(30),
                              child: PoppinsText(
                                text:
                                    "“I am an international student in Singapore! I can share my experience living in Singapore!”",
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                clr: Colors.black,
                                align: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 270,
                    height: 50,
                    child: GradientButton(
                      title: "Got it",
                      fontSize: 12,
                      clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                      onpressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: MeetSetup(),
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
            title: "Setting up a seller listing",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
