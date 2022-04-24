import 'package:flutter/material.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/View/Auth/authMain.dart';
import 'package:meeter/View/Profile/profile_preview.dart';
import 'package:meeter/View/calendar_screen.dart';
import 'package:meeter/View/messages_screen.dart';
import 'package:meeter/View/favourites.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatefulWidget {
  final Color? clr;
  Menu({this.clr});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    UserController _currentUser = Provider.of<UserController>(context);
    OurUser user = _currentUser.getCurrentUser;
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;

    return GFDrawer(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          widget.clr!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: h * 5.8),
            Column(
              children: <Widget>[
                GestureDetector(
                  child: ListTile(
                    title: Container(
                      alignment: Alignment.center,
                      height: h * 4.2217,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Text(
                              "Messages",
                              textScaleFactor: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w700,
                                  fontSize: w * 3.819,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => Messages()));
                  },
                ),
                GestureDetector(
                  child: ListTile(
                    title: Container(
                      alignment: Alignment.center,
                      height: h * 4.2217,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Text(
                              "Favorites",
                              textScaleFactor: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: w * 3.819,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => Favourites()));
                  },
                ),
                GestureDetector(
                  child: ListTile(
                    title: Container(
                      alignment: Alignment.center,
                      height: h * 4.2217,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Text(
                              "Calendar",
                              textScaleFactor: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: w * 3.819,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CalendarScreen()));
                  },
                ),
                GestureDetector(
                  child: ListTile(
                    title: Container(
                      alignment: Alignment.center,
                      height: h * 4.2217,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * 2.037, vertical: h * 0),
                            child: Text(
                              "Logout",
                              textScaleFactor: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: w * 3.819,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthMain()),
                        (route) => false);
                  },
                ),
              ],
            ),
            SizedBox(
              height: h * 2.8,
            ),
            GestureDetector(
              onTap: () {
                widget.clr == Colors.blue
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ProfilePreview(
                              clr: Color(0xff00AEFF),
                            )))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ProfilePreview(
                              clr: Color(0xff4CAF50),
                            )));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: h * 2.6, left: w * 5.8, right: w * 5.8),
                    child: Container(
                      width: w * 19.5,
                      height: h * 8.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: user != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                user.avatarUrl!,
                                fit: BoxFit.fill,
                              ))
                          : Container(),
                    ),
                  ),
                  user != null
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName!,
                                style: TextStyle(
                                  fontSize: w * 5.3,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: h * 3.8,
            ),
          ],
        ),
      ),
    );
  }
}
