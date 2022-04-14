import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/TextWidgets/rounded_textfield.dart';
import 'package:meeter/Widgets/LangSelector/langSelector.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/View/Profile/about_you_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetup extends StatefulWidget {
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();

  String postId = Uuid().v4();
  String country = "";
  String myName = "";
  String gender = "Male";
  late DateTime dateTime;
  late List langDynamicSelector;

  List<String> count = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
    "Seventh",
    "Eightth",
    "Nineth",
    "Tenth"
  ];

  late UserController _currentUser;

  List<Widget> langSelector = [
    LangSelector(
      ith: "First",
    )
  ];
  @override
  Widget build(BuildContext context) {
    langDynamicSelector = langSelector;
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    _currentUser = Provider.of<UserController>(context);

    return Scaffold(
      key: _scacffoldKey,
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
                    height: 180,
                  ),

                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(_currentUser.getCurrentUser.uid ??
                              FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        DocumentSnapshot? doc =
                            snapshot.data as DocumentSnapshot?;
                        if (snapshot.hasData) {
                          if (doc != null) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            if (data.containsKey("avatarUrl")) {
                              _currentUser.getCurrentUser.avatarUrl =
                                  data["avatarUrl"];
                            }
                          }
                        }
                        return CircularProfileAvatar(
                          _currentUser.getCurrentUser.avatarUrl ?? "",
                          backgroundColor: Color(0xffDCf0EF),
                          initialsText: Text(
                            "+",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w900,
                                fontSize: w * 7.6388,
                                color: Color(0xff00AEFF)),
                          ),
                          cacheImage: true,
                          borderWidth: 2,
                          elevation: 10,
                          radius: w * 12.7314,
                          onTap: () async {
                            await UserController().updateAvatar(
                                _currentUser.getCurrentUser.uid ??
                                    FirebaseAuth.instance.currentUser!.uid);
                          },
                        );
                      }),

                  // }),
                  SizedBox(
                    height: h * 4.2217,
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
                              tag: "Name",
                              child: RoundedTextField(
                                hint: "Name",
                                type: TextInputType.text,
                                obsecureText: false,
                                icon: Icon(
                                  Icons.badge,
                                  color: Color(0xff00AEFF),
                                ),
                                iconColor: Colors.cyan,
                                label: "Name",
                                controller: nameController,
                                onChange: (text) {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 4.2217,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: TextField(
                              controller: bioController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff00AEFF), width: 2.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff00AEFF), width: 1.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  hintText:
                                      'Enter a short description of yourself',
                                  labelText: "Bio",
                                  labelStyle: TextStyle(
                                    fontFamily: "Nunito",
                                  ),
                                  hintStyle: TextStyle(fontFamily: "Nunito")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 4.2217,
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
                            child: RoundedTextField(
                              hint: "Occupation",
                              type: TextInputType.text,
                              obsecureText: false,
                              icon: Icon(Icons.work_outline_rounded,
                                  color: Color(0xff00AEFF)),
                              iconColor: Colors.cyan,
                              label: "Occupation",
                              controller: occupationController,
                              onChange: (text) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 4.2217,
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
                            child: RoundedTextField(
                              hint: "Age",
                              type: TextInputType.number,
                              obsecureText: false,
                              icon: Icon(
                                Icons.event,
                                color: Color(0xff00AEFF),
                              ),
                              iconColor: Colors.cyan,
                              label: "Age",
                              controller: ageController,
                              onChange: (text) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 4.2217,
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
                            child: RoundedTextField(
                              hint: "Country",
                              type: TextInputType.text,
                              obsecureText: false,
                              icon: Icon(Icons.location_pin,
                                  color: Color(0xff00AEFF)),
                              iconColor: Colors.cyan,
                              label: "Country",
                              controller: countryController,
                              onChange: (text) {
                                setState(() {
                                  country = text;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListView(
                    shrinkWrap: true,
                    children: langSelector,
                    addAutomaticKeepAlives: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  GestureDetector(
                    child: PoppinsText(
                      text: "Add more languages +",
                      clr: Colors.blue,
                    ),
                    onTap: () {
                      setState(() {
                        langSelector = [
                          ...langSelector,
                          new LangSelector(
                            ith: count[langSelector.length],
                          )
                        ];

                        langDynamicSelector = langSelector;
                      });
                    },
                  ),
                  SizedBox(
                    height: h * 2.2217,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: PoppinsText(
                      text: "Upload a banner picture for your profile",
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: h * 4.2217,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_currentUser.getCurrentUser.uid ??
                              FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        DocumentSnapshot? doc =
                            snapshot.data as DocumentSnapshot?;
                        if (snapshot.hasData) {
                          if (doc != null) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;

                            if (data.containsKey("bannerImage")) {
                              _currentUser.getCurrentUser.bannerImage =
                                  data["bannerImage"];
                            }
                          }
                        }
                        return _currentUser.getCurrentUser.bannerImage == null
                            ? GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff00AEFF), width: 1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.asset("assets/images/image.png"),
                                ),
                                onTap: () {
                                  _currentUser.updateBanner(
                                      _currentUser.getCurrentUser.uid ??
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                      "users");
                                },
                              )
                            : GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff00AEFF), width: 1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.network(
                                    _currentUser.getCurrentUser.bannerImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                  _currentUser.updateBanner(
                                      _currentUser.getCurrentUser.uid ??
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                      "users");
                                },
                              );
                      }),

                  SizedBox(
                    height: h * 4.2217,
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    child: Hero(
                      tag: "Login",
                      child: GradientButton(
                        title: "Finish Setting Up",
                        clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                        onpressed: () async {
                          if (_currentUser.getCurrentUser.avatarUrl != null &&
                              nameController.text != "") {
                            updateDataToDb();
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setString('userName', nameController.text);
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  child: YouSetup()),
                            );
                          } else {
                            _scacffoldKey.currentState!.showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Your name and profile picture cannot be empty!'),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xff00AEFF),
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Profile Setup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff00AEFF),
                          fontSize: w * 6.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  updateDataToDb() async {
    UserController().updateDisplay(nameController.text);
    UserController().updateAge(ageController.text);
    UserController().updateOccupation(occupationController.text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.getCurrentUser.uid ??
            FirebaseAuth.instance.currentUser!.uid)
        .update({
      "bio": bioController.text,
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.getCurrentUser.uid ??
            FirebaseAuth.instance.currentUser!.uid)
        .update({
      "country": countryController.text,
    });

    for (int i = 0; i < langSelector.length; i++) {
      if (langDynamicSelector[i].getcurrentLanguage != null &&
          langDynamicSelector[i].getcurrentProf != null) {
        await FirebaseFirestore.instance
            .collection("language")
            .doc(_currentUser.getCurrentUser.uid ??
                FirebaseAuth.instance.currentUser!.uid)
            .set({
          "${langDynamicSelector[i].ith}Language":
              "${langDynamicSelector[i].getcurrentLanguage}",
          "${langDynamicSelector[i].ith}Proficiency":
              "${langDynamicSelector[i].getcurrentProf}",
        }, SetOptions(merge: true));
      }
    }
  }
}
