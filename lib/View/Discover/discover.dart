import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:meeter/View/Discover/interested.dart';

class Discover extends StatefulWidget {
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late UserController _currentUser;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    _currentUser = Provider.of<UserController>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("DiscoverDynamic")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                          ),
                          ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff00AEFF),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: Color(0xff00AEFF),
                                            ),
                                          ),
                                        ),
                                        Image.network(snapshot.data!.docs[index]
                                            ["image"]),
                                        Expanded(
                                          flex: 30,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: PoppinsText(
                                              text: snapshot.data!.docs[index]
                                                  ["title"],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              clr: Color(0xff00AEFF),
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: DiscoverInterested(
                                          snapshot.data!.docs[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 270,
                            height: 50,
                            child: GradientButton(
                              title: "More Discover Topics",
                              fontSize: 12,
                              clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                              onpressed: () {},
                            ),
                          ),
                          Container(height: 80)
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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
                        "Discover",
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
}
