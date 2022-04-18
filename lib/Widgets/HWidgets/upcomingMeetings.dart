import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/View/Dashboard/activity.dart';
import 'package:meeter/View/Dashboard/activity_buyer.dart';
import 'package:meeter/View/Explore_Seller/meet_up_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingMeetings extends StatefulWidget {
  final List<QueryDocumentSnapshot> requests;
  final Color clr;
  final Color clr1;

  UpcomingMeetings(
      {required this.clr, required this.clr1, required this.requests});

  @override
  _UpcomingMeetingsState createState() => _UpcomingMeetingsState();
}

class _UpcomingMeetingsState extends State<UpcomingMeetings> {
  late List<QueryDocumentSnapshot> requests;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    requests = widget.requests
        .where((element) =>
            element['seller_id'] == FirebaseAuth.instance.currentUser!.uid ||
            element['buyer_id'] == FirebaseAuth.instance.currentUser!.uid)
        .where((element) => element['accepted'] == true)
        .where((element) {
      List meeters = element["meeters"];
      return meeters.contains(FirebaseAuth.instance.currentUser!.uid);
    }).toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: h * 13.4,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 4.8, vertical: h * 1.3),
                  child: Text(
                    'UPCOMING MEETINGS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ButtonBar(
                  //alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        widget.clr == Colors.blue
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ActivityScreen(requests: widget.requests),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BuyerActivityScreen(
                                      requests: widget.requests),
                                ),
                              );
                        Container();
                      },
                      child: Text(
                        '+ more',
                        style: TextStyle(color: widget.clr1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          requests.isNotEmpty
              ? Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 4.8, vertical: h * 1.1),
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.clr,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 48,
                          width: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: requests.first['seller_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Image.network(
                                    requests.first['buyer_image'],
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    requests.first['seller_image'],
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              requests.first['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'Read More',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MeetUpDetails(
                                        requests.first, widget.clr),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
