import 'package:flutter/material.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/View/Splash/splash.dart';

class VerificationSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/verified.png"),
                SizedBox(
                  height: 10,
                ),
                PoppinsText(
                  text: "Phone verified",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: PoppinsText(
                    text:
                        "Congratulations, your phone number has been verified. Welcome to Meeter!",
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    align: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 25),
                Container(
                  width: 250,
                  height: 50,
                  child: Hero(
                    tag: "Login",
                    child: GradientButton(
                      title: "Continue",
                      clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                      onpressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: Splash(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
