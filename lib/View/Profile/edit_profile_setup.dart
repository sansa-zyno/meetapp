import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/TextWidgets/rounded_textfield.dart';
import 'package:meeter/Widgets/LangSelector/langSelector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/View/Auth/getting_Started.dart';
import 'package:meeter/Providers/requests_bloc.dart';

class EditProfileSetup extends StatefulWidget {
  _EditProfileSetupState createState() => _EditProfileSetupState();
}

class _EditProfileSetupState extends State<EditProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  late UserController _currentUser;

  String postId = Uuid().v4();
  String country = "";
  String myName = "";
  String gender = "Male";
  late DateTime dateTime;
  late List langDynamicSelector;
  late RequestBloc bloc;

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

  List<Widget> langSelector = [
    LangSelector(
      ith: "First",
    )
  ];

  getLang() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('language')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.data() != null) {
      Map map = doc.data() as Map;
      if (map.length == 2) {
        langSelector = [
          LangSelector(
            ith: "First",
            val: doc["FirstLanguage"],
            prof: doc["FirstProficiency"],
          ),
        ];
        setState(() {});
      } else if (map.length == 4) {
        langSelector = [
          LangSelector(
            ith: "First",
            val: doc["FirstLanguage"],
            prof: doc["FirstProficiency"],
          ),
          LangSelector(
            ith: "Second",
            val: doc["SecondLanguage"],
            prof: doc["SecondProficiency"],
          ),
        ];
        setState(() {});
      } else if (map.length == 6) {
        langSelector = [
          LangSelector(
            ith: "First",
            val: doc["FirstLanguage"],
            prof: doc["FirstProficiency"],
          ),
          LangSelector(
            ith: "Second",
            val: doc["SecondLanguage"],
            prof: doc["SecondProficiency"],
          ),
          LangSelector(
            ith: "Third",
            val: doc["ThirdLanguage"],
            prof: doc["ThirdProficiency"],
          ),
        ];
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = Provider.of<UserController>(context, listen: false);
    nameController =
        TextEditingController(text: _currentUser.getCurrentUser.displayName);
    ageController =
        TextEditingController(text: _currentUser.getCurrentUser.age);
    occupationController =
        TextEditingController(text: _currentUser.getCurrentUser.occupation);
    countryController =
        TextEditingController(text: _currentUser.getCurrentUser.country);
    bioController =
        TextEditingController(text: _currentUser.getCurrentUser.bio);
    setState(() {});
    getLang();
  }

  @override
  Widget build(BuildContext context) {
    langDynamicSelector = langSelector;
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    bloc = Provider.of<RequestBloc>(context, listen: false);
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
                    height: 140,
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
                  SizedBox(
                    height: h * 4.2217,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        height: 50,
                        child: Hero(
                          tag: "Edit",
                          child: GradientButton(
                            title: "Submit",
                            clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                            onpressed: () async {
                              if (nameController.text != "") {
                                updateDataToDb();
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                _prefs.setString(
                                    'userName', nameController.text);
                                _currentUser = Provider.of<UserController>(
                                    context,
                                    listen: false);
                                Future.delayed(const Duration(seconds: 3),
                                    () async {
                                  await _currentUser.getCurrentUserInfo();
                                  Navigator.pop(context);
                                });
                              } else {
                                _scacffoldKey.currentState!
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Your name cannot be empty!'),
                                ));
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        child: GradientButton(
                          title: "Delete Account",
                          clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                          onpressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'Are you sure to continue this process ?'),
                                      actions: [
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(_currentUser
                                                    .getCurrentUser.uid)
                                                .delete();

                                            try {
                                              QuerySnapshot m =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('meeters')
                                                      .doc(_currentUser
                                                          .getCurrentUser.uid)
                                                      .collection("meeter")
                                                      .get();
                                              for (int i = 0;
                                                  i < m.docs.length;
                                                  i++) {
                                                await FirebaseFirestore.instance
                                                    .collection('meeters')
                                                    .doc(_currentUser
                                                        .getCurrentUser.uid)
                                                    .collection("meeter")
                                                    .doc(m.docs[i].id)
                                                    .delete();
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection('meeters')
                                                  .doc(_currentUser
                                                      .getCurrentUser.uid)
                                                  .delete();
                                            } catch (e) {}

                                            try {
                                              QuerySnapshot d =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('demands')
                                                      .doc(_currentUser
                                                          .getCurrentUser.uid)
                                                      .collection("demand")
                                                      .get();

                                              for (int i = 0;
                                                  i < d.docs.length;
                                                  i++) {
                                                await FirebaseFirestore.instance
                                                    .collection('demands')
                                                    .doc(_currentUser
                                                        .getCurrentUser.uid)
                                                    .collection("demand")
                                                    .doc(d.docs[i].id)
                                                    .delete();
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection('demands')
                                                  .doc(_currentUser
                                                      .getCurrentUser.uid)
                                                  .delete();
                                            } catch (e) {}

                                            try {
                                              bloc.requests
                                                  .forEach((element) async {
                                                if (element['seller_id'] ==
                                                        _currentUser
                                                            .getCurrentUser
                                                            .uid ||
                                                    element['buyer_id'] ==
                                                        _currentUser
                                                            .getCurrentUser
                                                            .uid) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('requests')
                                                      .doc(element['seller_id'])
                                                      .collection("request")
                                                      .doc(element.id)
                                                      .delete();
                                                }
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('requests')
                                                  .doc(_currentUser
                                                      .getCurrentUser.uid)
                                                  .delete();
                                            } catch (e) {}

                                            try {
                                              QuerySnapshot f =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('favourites')
                                                      .doc(_currentUser
                                                          .getCurrentUser.uid)
                                                      .collection("favourite")
                                                      .get();

                                              for (int i = 0;
                                                  i < f.docs.length;
                                                  i++) {
                                                await FirebaseFirestore.instance
                                                    .collection('favourites')
                                                    .doc(_currentUser
                                                        .getCurrentUser.uid)
                                                    .collection("favourite")
                                                    .doc(f.docs[i].id)
                                                    .delete();
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection('favourites')
                                                  .doc(_currentUser
                                                      .getCurrentUser.uid)
                                                  .delete();
                                            } catch (e) {}

                                            await FirebaseAuth.instance
                                                .signOut();
                                            AchievementView(
                                              context,
                                              color: Colors.green,
                                              icon: Icon(
                                                FontAwesomeIcons.check,
                                                color: Colors.white,
                                              ),
                                              title: "Succesfull!",
                                              elevation: 20,
                                              subTitle:
                                                  "Your account has been deleted successfully",
                                              isCircle: true,
                                            )..show();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GettingStarted()),
                                                (route) => false);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ));
                          },
                        ),
                      )
                    ],
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
                        "Edit Profile",
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
    UserController().updateBio(bioController.text);
    UserController().updateCountry(countryController.text);

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
