import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  TextEditingController otp;
  Function() onpressed;
  Function resendOtp;
  String number;

  Verification(
      {required this.otp,
      required this.onpressed,
      required this.number,
      required this.resendOtp});

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final FocusNode _pinPutFocusNode = FocusNode();
  double _times = 60;
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  void onEnd() {
    setState(() {
      _times = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

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
                Image.asset("assets/images/verification.png"),
                SizedBox(
                  height: 10,
                ),
                PoppinsText(
                  text: "Verification",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                SizedBox(
                  height: 20,
                ),
                PoppinsText(
                  text:
                      "Enter the 6 digit number that\nwas sent to ${widget.number}",
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xff00AEFF),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pinput(
                        length: 6,
                        onSubmitted: (String pin) => {},
                        focusNode: _pinPutFocusNode,
                        controller: widget.otp,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _times != 0
                          ? Container(
                              width: 250,
                              height: 50,
                              child: Hero(
                                tag: "verify",
                                child: GradientButton(
                                  title: "Verify",
                                  clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                                  onpressed: widget.onpressed,
                                ),
                              ),
                            )
                          : Container(
                              width: 250,
                              height: 50,
                              child: Hero(
                                tag: "verify",
                                child: GradientButton(
                                  title: "Resend Code",
                                  clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                                  onpressed: () {
                                    endTime =
                                        DateTime.now().millisecondsSinceEpoch +
                                            1000 * 60;
                                    _times = 60;
                                    controller = CountdownTimerController(
                                        endTime: endTime, onEnd: onEnd);
                                    setState(() {});
                                    widget.resendOtp();
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                CountdownTimer(
                    controller: controller,
                    onEnd: () {},
                    endTime: endTime,
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        return Container();
                      }
                      return PoppinsText(
                        text:
                            "Re-Send Code In 0:${time.sec!.floor() < 10 ? "0" : ""}${time.sec!.floor()} ",
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
