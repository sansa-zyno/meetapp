import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:meeter/Model/demand.dart';
import 'package:meeter/Model/meetup.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_setup.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:meeter/Services/firebase_api.dart';
import 'package:provider/provider.dart';
import 'View/Auth/getting_Started.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Providers/requests_bloc.dart';
import 'package:meeter/Providers/application_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterStatusbarcolor.setStatusBarColor(Colors.white);
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ApplicationBloc(), lazy: false),
        ChangeNotifierProvider(create: (_) => RequestBloc(), lazy: false),
        StreamProvider<List<Meetup>>(
            initialData: [],
            create: (_) => FirebaseApi().getMeeterUids(),
            lazy: false),
        StreamProvider<List<Demand>>(
            initialData: [],
            create: (_) => FirebaseApi().getDemandUids(),
            lazy: false)
      ],
      child: MaterialApp(
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

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth _auth;
  late UserController _userController;

  saveUsertoSharedPref(String displayName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('userName', displayName);
  }

  Future<String> getUserFromSharedPref() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userName = _prefs.getString('userName')!;
    return userName;
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        _userController = Provider.of<UserController>(context, listen: false);
        OurUser user = await _userController.getCurrentUserInfo();
        saveUsertoSharedPref(user.displayName!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) => snapshot.hasData
            ? FutureBuilder(
                future: getUserFromSharedPref(),
                builder: (ctx, snap) =>
                    snap.hasData ? BottomNavBar() : ProfileSetup())
            : GettingStarted());
  }
}
