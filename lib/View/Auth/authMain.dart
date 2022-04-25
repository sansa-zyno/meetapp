import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_setup.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import './verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/Model/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:page_transition/page_transition.dart';
import './verification_successful.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';

class AuthMain extends StatefulWidget {
  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  bool isLoggedIn = false;
  bool otpSent = false;
  String? uid;
  late String _verificationId;

  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otp.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
        });
      } else {
        AchievementView(
          context,
          color: Colors.red,
          icon: const Icon(
            FontAwesomeIcons.bug,
            color: Colors.white,
          ),
          title: "Wrong Code !",
          elevation: 20,
          subTitle: "Your Entered OTP is Incorrect",
          isCircle: true,
        ).show();
      }
    } catch (e) {}

    if (uid != null) {
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        if (snap.docs.isNotEmpty) {
          if (snap.docs[0]['displayName'] != null &&
              snap.docs[0]['avatarUrl'] != null) {
            UserController _currentUser =
                Provider.of<UserController>(context, listen: false);
            _currentUser.getCurrentUserInfo();
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setString('userName', snap.docs[0]['displayName']);
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: BottomNavBar(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: ProfileSetup(),
                ),
                (route) => false);
          }
        } else {
          OurUser _user = OurUser();
          try {
            FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
            String? fcmToken = await firebaseMessaging.getToken();
            await FirebaseFirestore.instance.collection("users").doc(uid).set({
              "uid": uid,
              "phoneNumber": FirebaseAuth.instance.currentUser!.phoneNumber,
              "accountCreated": Timestamp.now(),
              "avatarUrl": _user.avatarUrl,
              "bannerImage": _user.bannerImage,
              "age": _user.age,
              "bio": _user.bio,
              "country": _user.country,
              "displayName": _user.displayName,
              "token": fcmToken,
              "userType": _user.userType,
              "verified": _user.verified,
            });
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: VerificationSuccess(),
                ),
                (route) => false);
          } catch (e) {}
        }
      } catch (e) {}
    }
  }

  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber.text,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      otpSent = true;
    });

    AchievementView(
      context,
      color: Colors.green,
      icon: Icon(
        FontAwesomeIcons.check,
        color: Colors.white,
      ),
      title: "OTP Generation Successfull !",
      elevation: 20,
      subTitle: "Type in your OTP",
      isCircle: true,
    ).show();
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void codeSent(String verificationId, [int? a]) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    AchievementView(
      context,
      color: Colors.red,
      icon: Icon(
        FontAwesomeIcons.bug,
        color: Colors.white,
      ),
      title: "Verification failed",
      elevation: 20,
      subTitle: "There is an issue verifying this number",
      isCircle: true,
    ).show();
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return otpSent
        ? Verification(
            number: _phoneNumber.text,
            otp: _otp,
            onpressed: _verifyOTP,
            resendOtp: _sendOTP,
          )
        : Login(
            onpressed: _sendOTP,
            phone: _phoneNumber,
          );
  }
}
