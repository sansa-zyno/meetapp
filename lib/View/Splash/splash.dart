import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_setup.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late String wid;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      return "Seen";
    } else {
      await prefs.setBool('seen', true);
      return "Not Seen";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirstSeen().then((value) => wid = value);
  }

  @override
  Widget build(BuildContext context) {
    UserController _currentUser =
        Provider.of<UserController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SplashScreen.navigate(
        name: 'assets/flare/meeter.flr',
        startAnimation: "splash",
        next: (context) {
          if (wid == "Seen") {
            return WillPopScope(
              onWillPop: () async {
                MoveToBackground.moveTaskToBack();
                return false;
              },
              child: ProfileSetup(),
            );
          } else if (wid == "Not Seen") {
            return ProfileSetup();
          } else {
            return ProfileSetup();
          }
        },
        until: () async {
          await _currentUser.getCurrentUserInfo();
          return;
        },
      ),
    );
  }
}
