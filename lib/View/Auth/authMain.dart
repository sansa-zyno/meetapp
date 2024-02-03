import 'dart:developer';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
    log("oTP in _verifyOTP is: ${_otp.text}");
    log("in verifyOtp and credential: ${credential.smsCode} "
        "and credential.verificationId: ${credential.verificationId} "
        " and credential.providerId: ${credential.providerId} "
        "and credential.signInMethod: ${credential.signInMethod}");
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      log("userCredential.user: ${userCredential.user}");

      if (FirebaseAuth.instance.currentUser != null) {
        log("inside the user not null");
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
          log("userid: $uid");
        });
      } else {
        AchievementView(
          color: Colors.red,
          icon: const Icon(
            FontAwesomeIcons.bug,
            color: Colors.white,
          ),
          title: "Wrong Code !",
          elevation: 20,
          subTitle: "Your Entered OTP is Incorrect",
          isCircle: true,
        ).show(context);
      }
    } catch (e) {
      log("Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
      Get.defaultDialog(
          title: "Error!",
          middleText:
              "Following error was thrown while trying to authenticate the OTP : ${e.toString()}");
    }

    if (uid != null) {
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        if (snap.docs.isNotEmpty) {
          setStatusOnline() async {
            final currentUser = FirebaseAuth.instance.currentUser;
            await FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser!.uid)
                .update({"lastActive": "Online"});
          }

          if (snap.docs[0]['displayName'] != "" &&
              snap.docs[0]['avatarUrl'] != "") {
            UserController _currentUser =
                Provider.of<UserController>(context, listen: false);
            _currentUser.getCurrentUserInfo();
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setString('userName', snap.docs[0]['displayName']);
            log("in old user before navigation");
            setStatusOnline();
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
            setStatusOnline();
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
            String date = formatDate(DateTime.now(),
                [MM, ' ', d, ', ', yyyy, ' ', hh, ':', nn, ' ', am]);
            await FirebaseFirestore.instance.collection("users").doc(uid).set({
              "uid": uid,
              "phoneNumber": FirebaseAuth.instance.currentUser!.phoneNumber,
              "accountCreated": Timestamp.now(),
              "avatarUrl": "",
              "bannerImage": _user.bannerImage,
              "age": _user.age,
              "bio": _user.bio,
              "country": _user.country,
              "displayName": "",
              "token": fcmToken,
              "userType": _user.userType,
              "verified": _user.verified,
              "lastActive": "Online",
              "ratings": []
            });
            log("in new user before navigation");
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: VerificationSuccess(),
                ),
                (route) => false);
          } catch (e) {
            log("Error in setting Firebase Messaging. ${e.toString()}");
          }
        }
      } catch (e) {
        log("Error in adding or fetching user data. ${e.toString()}");
      }
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
      color: Colors.green,
      icon: Icon(
        FontAwesomeIcons.check,
        color: Colors.white,
      ),
      title: "OTP Generation Successfull !",
      elevation: 20,
      subTitle: "Type in your OTP",
      isCircle: true,
    ).show(context);
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
      color: Colors.red,
      icon: Icon(
        FontAwesomeIcons.bug,
        color: Colors.white,
      ),
      title: "Verification failed",
      elevation: 20,
      subTitle: "There is an issue verifying this number: ${exception.message}",
      isCircle: true,
    ).show(context);
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log("userCredential.user: ${userCredential.user}");
      if (FirebaseAuth.instance.currentUser != null) {
        log("inside the user not null");
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
          log("userid: $uid");
        });
      } else {
        AchievementView(
          color: Colors.red,
          icon: const Icon(
            FontAwesomeIcons.bug,
            color: Colors.white,
          ),
          title: "Something went wrong!",
          elevation: 20,
          subTitle: "Could not fetch the OTP",
          isCircle: true,
        ).show(context);
      }
    } catch (e) {
      log("Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
      Get.defaultDialog(
          title: "Error!",
          middleText:
              "Following error was thrown while trying to authenticate the OTP : ${e.toString()}.");
    }
    if (uid != null) {
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        if (snap.docs.isNotEmpty) {
          setStatusOnline() async {
            final currentUser = FirebaseAuth.instance.currentUser;
            await FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser!.uid)
                .update({"lastActive": "Online"});
          }

          if (snap.docs[0]['displayName'] != "" &&
              snap.docs[0]['avatarUrl'] != "") {
            UserController _currentUser =
                Provider.of<UserController>(context, listen: false);
            _currentUser.getCurrentUserInfo();
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setString('userName', snap.docs[0]['displayName']);
            log("in old user before navigation");
            setStatusOnline();
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
            setStatusOnline();
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
            String date = formatDate(DateTime.now(),
                [MM, ' ', d, ', ', yyyy, ' ', hh, ':', nn, ' ', am]);
            await FirebaseFirestore.instance.collection("users").doc(uid).set({
              "uid": uid,
              "phoneNumber": FirebaseAuth.instance.currentUser!.phoneNumber,
              "accountCreated": Timestamp.now(),
              "avatarUrl": "",
              "bannerImage": _user.bannerImage,
              "age": _user.age,
              "bio": _user.bio,
              "country": _user.country,
              "displayName": "",
              "token": fcmToken,
              "userType": _user.userType,
              "verified": _user.verified,
              "lastActive": "Online",
              "ratings": []
            });
            log("in new user before navigation");
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: VerificationSuccess(),
                ),
                (route) => false);
          } catch (e) {
            log("Error in setting Firebase Messaging. ${e.toString()}");
          }
        }
      } catch (e) {
        log("Error in adding or fetching user data. ${e.toString()}");
      }
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
