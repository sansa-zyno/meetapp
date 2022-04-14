import 'package:flutter/material.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_buyer.dart';

class MeeterAppbarBuyer extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData? icon2;
  final Function? onpressed;

  MeeterAppbarBuyer(
      {required this.icon, required this.title, this.onpressed, this.icon2});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
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
              flex: 1,
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 1.9, vertical: h * 0.8),
                    child: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.green, size: 30),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => BuyerBottomNavBar()));
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: w * 6.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 1.9, vertical: h * 0.8),
                    child: Icon(icon2, color: Colors.green, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
