import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/View/Dashboard/activity_buyer.dart';
import 'package:meeter/View/Explore_Buyer/home_buyer_screen.dart';
import 'package:meeter/View/Discover/seller_discover.dart';
import 'package:meeter/View/Profile/profile_preview.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:meeter/View/Profile/meet_setup.dart';
import 'package:meeter/View/Profile/demand_setup.dart';

class BuyerBottomNavBar extends StatefulWidget {
  @override
  _BuyerBottomNavBarState createState() => _BuyerBottomNavBarState();
}

class _BuyerBottomNavBarState extends State<BuyerBottomNavBar> {
  int currentIndex = 0;
  List<QueryDocumentSnapshot>? requests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collectionGroup('request')
        .orderBy("ts")
        .snapshots()
        .listen((event) {
      requests = event.docs;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = [
      HomeBuyerScreen(),
      SellerDiscover(),
      BuyerActivityScreen(
          requests: requests != null
              ? requests!
                  .where((element) => element['type'] == 'demand')
                  .toList()
              : []),
      ProfilePreview(
        clr: Color(0xff4CAF50),
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            circleColors: [Colors.green, Colors.green, Colors.green],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            actionButtonDetails: SCActionButtonDetails(
                color: Colors.green,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                elevation: 2),
            elevation: 2.0,
            items: [
              // Suggested count : 4
              SCBottomBarItem(
                  icon: Icons.explore_outlined,
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.search,
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.notifications,
                  onPressed: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.person,
                  onPressed: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  }),
            ],
            circleItems: [
              //Suggested Count: 3
              SCItem(
                  icon: Icon(
                    Icons.clean_hands_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => MeetSetup()));
                  }),
              SCItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => DemandSetup()));
                  }),
            ],
            bnbHeight: 80 // Suggested Height 80
            ),
        child: screen[currentIndex],
      ),
    );
  }
}
