import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/Services/nearest_service.dart';
import 'package:meeter/View/Dashboard/activity.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_buyer.dart';
import 'package:meeter/Widgets/HWidgets/upcomingMeetings.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/View/Explore_Seller/search_screen.dart';
import 'package:meeter/Widgets/HWidgets/mainlists.dart';
import 'package:meeter/Widgets/HWidgets/menu.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late ApplicationBloc applicationBloc;

  List<MeetupData>? nearest;
  List<QueryDocumentSnapshot>? requests;
  List<MeetupData>? listMeetupData;
  List<QueryDocumentSnapshot>? messageDoc;
  List<QueryDocumentSnapshot>? recentActivities;

  getNearestMeetups(List<MeetupData> list) async {
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    if (applicationBloc.currentLocation != null) {
      nearest = await NearestService()
          .getNearestMeeterCollection(list, applicationBloc.currentLocation!);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collectionGroup("meeter")
        .snapshots()
        .listen((event) {
      listMeetupData =
          event.docs.map((doc) => MeetupData.fromSnap(doc)).toList();
      setState(() {});
      if (listMeetupData != null) {
        getNearestMeetups(listMeetupData!);
      }
    });
    FirebaseFirestore.instance
        .collectionGroup("request")
        .orderBy("ts")
        .where("type", isEqualTo: "service")
        .snapshots()
        .listen((event) {
      requests = event.docs;
      setState(() {});
    });
    Database().getChatRooms().listen((event) {
      messageDoc = event.docs;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    UserController _currentUser = Provider.of<UserController>(context);
    OurUser currentUser = _currentUser.getCurrentUser;
    List<QueryDocumentSnapshot> latestRequests = requests != null
        ? requests!
            .where((element) {
              List meeters = element["meeters"];
              if (element["accepted"] == false) {
                return meeters.isEmpty;
              } else {
                return meeters.contains(FirebaseAuth.instance.currentUser!.uid);
              }
            })
            .where((element) {
              if (FirebaseAuth.instance.currentUser!.uid ==
                  element["buyer_id"]) {
                return element["accepted"] != null ||
                    element["modified"] != null;
              } else {
                return true;
              }
            })
            .where((element) {
              return element["acceptedBy"] !=
                      FirebaseAuth.instance.currentUser!.uid &&
                  element["declinedBy"] !=
                      FirebaseAuth.instance.currentUser!.uid &&
                  element["modifiedBy"] !=
                      FirebaseAuth.instance.currentUser!.uid;
            })
            .where((element) => element["read"] == false)
            .toList()
        : [];
    List<QueryDocumentSnapshot> latestMsgs = messageDoc != null
        ? messageDoc!
            .where((element) => element["read"] == false)
            .where((element) =>
                element["lastMessageSendByUid"] !=
                FirebaseAuth.instance.currentUser!.uid)
            .toList()
        : [];
    recentActivities = [...latestRequests, ...latestMsgs];
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(
        clr: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 1.9, vertical: h * 0.8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50 / 2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: w * 2.4,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeIn,
                                            child: BuyerBottomNavBar(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50 / 2),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.sync,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 4.8, vertical: h * 2.2),
                              child: currentUser.displayName != null
                                  ? Text(
                                      'Welcome Back \n${currentUser.displayName}!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 7.3,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  : Container(),
                            ),
                            Stack(children: [
                              Column(
                                children: [
                                  //SizedBox(height: 3),
                                  IconButton(
                                    icon: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ActivityScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Positioned(
                                  top: 3,
                                  right: 12,
                                  child: recentActivities!.length == 0
                                      ? Container()
                                      : Text("${recentActivities!.length}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)))
                            ])
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: w * 3.6),
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    hintText: 'Search',
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SearchScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 1.12,
                ),
                requests != null
                    ? Container(
                        height: 136,
                        child: UpcomingMeetings(
                            clr: Colors.blue,
                            clr1: Colors.blue,
                            requests: requests!))
                    : Container(),
                listMeetupData != null
                    ? Container(
                        height: 232,
                        color: Colors.blue,
                        child: MainLists(
                          mainText: 'FEATURED SERVICES',
                          meetersCollection: listMeetupData!
                              .where((doc) => doc.featured == true)
                              .toList(),
                          clr: Colors.blue,
                          clr1: Colors.blue,
                        ),
                      )
                    : Container(),
                listMeetupData != null
                    ? Container(
                        height: 240,
                        child: MainLists(
                          mainText: 'SUGGESTED SERVICES FOR YOU',
                          meetersCollection: listMeetupData!,
                          clr: Colors.blue,
                          clr1: Colors.blue,
                        ),
                      )
                    : Container(),
                nearest != null
                    ? Container(
                        height: 232,
                        child: MainLists(
                          mainText: 'SERVICES NEAR YOU',
                          meetersCollection: nearest!,
                          clr: Colors.blue,
                          clr1: Colors.blue,
                        ),
                      )
                    : Container(),
                listMeetupData != null
                    ? Container(
                        height: 232,
                        child: MainLists(
                          mainText: 'HIGH-VALUE SERVICES',
                          meetersCollection: listMeetupData!
                              .where((doc) => doc.meetup_price! >= 50)
                              .toList(),
                          clr: Colors.blue,
                          clr1: Colors.blue,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: h * 8.9,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
