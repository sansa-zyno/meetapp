import 'package:flutter/material.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:page_transition/page_transition.dart';
import './interested_sellers.dart';

class DiscoverInterested extends StatefulWidget {
  final doc;
  DiscoverInterested(this.doc);
  @override
  _DiscoverInterestedState createState() => _DiscoverInterestedState();
}

class _DiscoverInterestedState extends State<DiscoverInterested> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                child: Container(
                  child: Image.network(
                    widget.doc["image"],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.center,
              child: PoppinsText(
                text: widget.doc["title"],
                fontWeight: FontWeight.w600,
                align: TextAlign.start,
                fontSize: 15,
                clr: Color(0xff00AEFF),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.center,
              child: PoppinsText(
                  text: widget.doc["text1"],
                  fontWeight: FontWeight.w400,
                  align: TextAlign.center,
                  fontSize: 12,
                  clr: Colors.black),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.center,
              child: PoppinsText(
                  text: widget.doc["text2"],
                  fontWeight: FontWeight.w400,
                  align: TextAlign.center,
                  fontSize: 12,
                  clr: Colors.black),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: PoppinsText(
                  text: widget.doc["text3"],
                  fontWeight: FontWeight.w400,
                  align: TextAlign.center,
                  fontSize: 12,
                  clr: Colors.black),
            ),
            Container(
              width: 270,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: GradientButton(
                          title: "I'm Interested",
                          clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                          fontSize: 12,
                          letterSpacing: 0,
                          onpressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                child: InterestedSellers(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )),
      ),
    );
  }
}
