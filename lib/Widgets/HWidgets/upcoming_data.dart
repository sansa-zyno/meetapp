import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/View/meet_up_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingData extends StatefulWidget {
  final Color clr;
  final List<QueryDocumentSnapshot> requests;
  UpcomingData({required this.clr, required this.requests});

  @override
  _UpcomingDataState createState() => _UpcomingDataState();
}

class _UpcomingDataState extends State<UpcomingData> {
  late List<QueryDocumentSnapshot> requests;

  String startTime = "";
  String endTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    requests = widget.requests
        .where((element) =>
            element['seller_id'] == FirebaseAuth.instance.currentUser!.uid ||
            element['buyer_id'] == FirebaseAuth.instance.currentUser!.uid)
        .where((element) => element['accepted'] == true)
        .toList();
    return ListView.builder(
        itemCount: requests.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          if (requests.isNotEmpty) {
            startTime = formatDate(requests[index]['startDateTime'].toDate(),
                [hh, ':', nn, ' ', am]);
            endTime = formatDate(requests[index]['endDateTime'].toDate(),
                [hh, ':', nn, ' ', am]);
          }
          return requests.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 60),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  MeetUpDetails(requests[index], widget.clr)));
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: height / 8,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 40, vertical: height / 100),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              height: height / 13,
                              width: width / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: requests[index]['seller_id'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Image.network(
                                        requests[index]['buyer_image'],
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        requests[index]['seller_image'],
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height / 100.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Upcoming meeting',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: width / 21,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 60),
                                              child: Text(
                                                '🕒$startTime-$endTime',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: requests[index]['seller_id'] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? Text(
                                              'You have an upcoming meeting with ${requests[index]['buyer_name']}',
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: width / 24,
                                              ),
                                            )
                                          : Text(
                                              'You have an upcoming meeting with ${requests[index]['seller_name']}',
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: width / 24,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container();
        });
  }
}
