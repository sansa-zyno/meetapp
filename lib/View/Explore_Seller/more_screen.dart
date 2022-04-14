import 'package:flutter/material.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/HWidgets/more_list.dart';

class MoreScreen extends StatefulWidget {
  final List<List<MeetupData>> meetersCollections;
  MoreScreen(this.meetersCollections);
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 100),
                MoreLists(
                  meetersCollections: widget.meetersCollections,
                ),
              ],
            ),
          ),
          MeeterAppbar(
            title: "More Products",
            icon: Icons.arrow_back_ios_outlined,
          ),
        ],
      ),
    );
  }
}
