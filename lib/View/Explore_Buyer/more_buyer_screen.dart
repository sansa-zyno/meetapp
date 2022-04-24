import 'package:flutter/material.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar_buyer.dart';
import 'package:meeter/Widgets/HWidgets/more_lists_buyer.dart';

class MoreBuyerScreen extends StatefulWidget {
  final List<DemandData> demands;
  MoreBuyerScreen(this.demands);
  @override
  _MoreBuyerScreenState createState() => _MoreBuyerScreenState();
}

class _MoreBuyerScreenState extends State<MoreBuyerScreen> {
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
                MoreListsBuyer(
                  demandsCollection: widget.demands,
                ),
              ],
            ),
          ),
          MeeterAppbarBuyer(
            title: "More Products",
            icon: Icons.arrow_back_ios_outlined,
          ),
        ],
      ),
    );
  }
}
