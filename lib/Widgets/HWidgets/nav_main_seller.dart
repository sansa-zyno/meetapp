import 'package:flutter/material.dart';
import 'package:meeter/Providers/requests_bloc.dart';
import 'package:meeter/View/Dashboard/activity.dart';
import 'package:meeter/View/Discover/discover.dart';
import 'package:meeter/View/Explore_Seller/home_screen.dart';
import 'package:meeter/View/Profile/meet_setup.dart';
import 'package:meeter/View/Profile/demand_setup.dart';
import 'package:meeter/View/Profile/profile_preview.dart';
import 'package:provider/provider.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  late RequestBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RequestBloc>(context);
    final screen = [
      HomeScreen(),
      Discover(),
      ActivityScreen(
          requests: bloc.requests
              .where((element) => element['type'] == 'service')
              .toList()),
      ProfilePreview(),
    ];

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            circleColors: [Colors.blue, Colors.blue, Colors.blue],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            actionButtonDetails: SCActionButtonDetails(
                color: Colors.blue,
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
