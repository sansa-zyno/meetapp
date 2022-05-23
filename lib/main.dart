import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_setup.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:provider/provider.dart';
import 'Controllers/timer_controller.dart';
import 'View/Auth/getting_Started.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Providers/application_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  Get.put(TimerController());
  // SystemChrome.setEnabledSystemUIMode(
  // SystemUiMode.manual,
  // overlays: [
  //   SystemUiOverlay.bottom,
  //   SystemUiOverlay.top
  // ]);
  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
      child: Meeter(),
    ),
  );
}

class Meeter extends StatefulWidget {
  @override
  _MeeterState createState() => _MeeterState();
}

class _MeeterState extends State<Meeter> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ApplicationBloc(), lazy: false),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meeter',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late FirebaseAuth _auth;
  late UserController _userController;
  List<QueryDocumentSnapshot>? requests;
  Stream? infoStream;

  setStatusOnline() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    String dt = DateTime.now().toString();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .update({"lastSeen": dt});
  }

  saveUsertoSharedPref(String displayName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('userName', displayName);
  }

  onLoad() async {
    _userController = Provider.of<UserController>(context, listen: false);
    OurUser user = await _userController.getCurrentUserInfo();
    saveUsertoSharedPref(user.displayName ?? "");
  }

  deleteUpcomingAfterTimeElapse() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collectionGroup("request").get();
    requests = snapshot.docs
        .where((element) =>
            element['seller_id'] == _auth.currentUser!.uid ||
            element['buyer_id'] == _auth.currentUser!.uid)
        .where((element) => element['accepted'] == true)
        .toList();
    if (requests != null) {
      requests!.forEach((element) {
        String date = element['date'];
        int duration = element['duration'];
        int startHour = element['startTime']['hour'];
        int startMin = element['startTime']['min'];
        int timeInMin = (startHour * 60) + startMin + duration;
        String endTime =
            "${(timeInMin ~/ 60).floor() < 10 ? "0" : ""}${(timeInMin ~/ 60).floor()}:${(timeInMin % 60).floor() < 10 ? "0" : ""}${(timeInMin % 60).floor()}";
        String formattedString = "$date $endTime";
        DateTime dateTime = DateTime.parse(formattedString);
        if (dateTime.compareTo(DateTime.now()) >= 0) {
          Future.delayed(const Duration(hours: 1), () async {
            await FirebaseFirestore.instance
                .collection("requests")
                .doc(element['seller_id'])
                .collection("request")
                .doc(element.id)
                .delete();
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      onLoad();
      infoStream ??=
          Stream<List<int>>.periodic(const Duration(seconds: 5), (x) {
        //for listening sake but List not used
        deleteUpcomingAfterTimeElapse();
        return [0, 1];
      });
      infoStream!.listen((event) {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setStatusOnline();
    }
  }

  @override
  Widget build(BuildContext context) {
    _userController = Provider.of<UserController>(context);
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (_userController.getCurrentUser.displayName == null ||
                _userController.getCurrentUser.avatarUrl == null) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (_userController.getCurrentUser.displayName == "" ||
                _userController.getCurrentUser.avatarUrl == "") {
              return ProfileSetup();
            } else {
              return BottomNavBar();
            }
          } else {
            return GettingStarted();
          }
        });
  }
}
