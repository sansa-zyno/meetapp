import 'package:flutter/material.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/TextWidgets/rounded_textfield.dart';

class Login extends StatefulWidget {
  TextEditingController? phone;
  final Function()? onpressed;

  Login({this.onpressed, this.phone});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(20),
                        child: Image.asset("assets/images/Logo@2x.png"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: PoppinsText(
                          text: "SIGN IN",
                          align: TextAlign.center,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          clr: Color(0xff00AEFF),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Hero(
                                tag: "Phone",
                                child: RoundedTextField(
                                  hint: "Enter your credentials",
                                  type: TextInputType.phone,
                                  obsecureText: false,
                                  icon: Icon(Icons.lock),
                                  iconColor: Colors.cyan,
                                  label: "Phone Number",
                                  controller: widget.phone,
                                  onChange: (text) {},
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      child: Hero(
                        tag: "Login",
                        child: GradientButton(
                            title: "Sign in",
                            clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                            onpressed: widget.onpressed),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    SizedBox(
                      height: 55,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
