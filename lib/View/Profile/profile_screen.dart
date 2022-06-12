import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/about.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/demands.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/service.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/achievement.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/connection.dart';
import 'package:meeter/View/Profile/profile_screen_widgets/reviews.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final Color clr;
  ProfileScreen({required this.clr});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = PageController();

  bool about = true;
  bool service = false;
  bool demand = false;
  bool review = false;
  late UserController _currentUser;
  String? recentMeetingDate;

  getRecentMeeting() async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection("connections")
        .where("meeters", arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("ts", descending: true)
        .get();
    recentMeetingDate = q.docs.isNotEmpty ? q.docs[0]["date"] : null;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecentMeeting();
    //To update last active when app is already signed in
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _currentUser = Provider.of<UserController>(context, listen: false);
      _currentUser.getCurrentUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 230,
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  child: GestureDetector(
                    child: Container(
                        child: _currentUser.isBannerUploading
                            ? Center(
                                child:
                                    Container(child: LinearProgressIndicator()))
                            : Image.network(
                                _currentUser.getCurrentUser.bannerImage!,
                                fit: BoxFit.fitWidth,
                              )),
                    onTap: () async {
                      _currentUser =
                          Provider.of<UserController>(context, listen: false);
                      await _currentUser.updateBanner(
                          _currentUser.getCurrentUser.uid!, "users");
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: CircularProfileAvatar(
                    '',
                    backgroundColor: Color(0xffDCf0EF),
                    child: _currentUser.isAvatarUploading
                        ? Center(child: CircularProgressIndicator())
                        : _currentUser.getCurrentUser.avatarUrl == null
                            ? Container()
                            : Image.network(
                                _currentUser.getCurrentUser.avatarUrl!),
                    initialsText: Text(
                      "+",
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w900,
                          fontSize: 21,
                          color: Colors.white),
                    ),
                    //cacheImage: true,
                    borderWidth: 2,
                    elevation: 10,
                    radius: 50,
                    onTap: () async {
                      _currentUser =
                          Provider.of<UserController>(context, listen: false);
                      await _currentUser
                          .updateAvatar(_currentUser.getCurrentUser.uid!);
                      //Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: PoppinsText(
                text: _currentUser.getCurrentUser.displayName ?? '',
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Positive',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            PoppinsText(
              text: _currentUser.getCurrentUser.country ?? '',
              fontSize: 12,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                      child: GradientButton(
                        title: "Connections",
                        clrs: [widget.clr, widget.clr],
                        fontSize: 12,
                        letterSpacing: 0,
                        onpressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => Connection()));
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                      child: GradientButton(
                        fontSize: 12,
                        letterSpacing: 0,
                        title: "Achievements",
                        textClr: Color(0xff00AEFF),
                        clrs: [Colors.white, Colors.white],
                        border: Border.all(color: widget.clr),
                        onpressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => Achievement()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: about == true
                            ? Border(
                                bottom: BorderSide(
                                  color: Color(0xff00AEFF),
                                  width: 2,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: PoppinsText(
                          text: "About",
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        about = true;
                        service = false;
                        demand = false;
                        review = false;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: service == true
                            ? Border(
                                bottom: BorderSide(
                                  color: Color(0xff00AEFF),
                                  width: 2,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: PoppinsText(
                          text: "Services ",
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        about = false;
                        service = true;
                        demand = false;
                        review = false;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: demand == true
                            ? Border(
                                bottom: BorderSide(
                                  color: Color(0xff00AEFF),
                                  width: 2,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: PoppinsText(
                          text: "Demands",
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        about = false;
                        service = false;
                        demand = true;
                        review = false;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: review == true
                            ? Border(
                                bottom: BorderSide(
                                  color: Color(0xff00AEFF),
                                  width: 2,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: PoppinsText(
                          text: "Reviews ",
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        about = false;
                        service = false;
                        demand = false;
                        review = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            about == true
                ? About(clr: widget.clr, recentMeetingDate: recentMeetingDate)
                : Container(),
            service == true ? Services() : Container(),
            demand == true ? Demands() : Container(),
            review == true ? Review() : Container(),
          ],
        ),
      ),
    );
  }
}
