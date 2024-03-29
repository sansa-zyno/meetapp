import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/Widgets/HWidgets/recent_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeter/Widgets/HWidgets/upcoming_data.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool recent = true;
  bool upcomming = false;
  List<QueryDocumentSnapshot> requestDoc = [];
  List<QueryDocumentSnapshot> messageDoc = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collectionGroup("request")
        .orderBy("ts")
        .where("type", isEqualTo: "service")
        .snapshots()
        .listen((event) {
      requestDoc = event.docs
          .where((element) {
            return element["seller_id"] ==
                    FirebaseAuth.instance.currentUser!.uid ||
                element["buyer_id"] == FirebaseAuth.instance.currentUser!.uid;
          })
          .where((element) {
            if (element["accepted"] == null && element["modified"] == null) {
              return element["seller_id"] ==
                  FirebaseAuth.instance.currentUser!.uid;
            } else {
              return true;
            }
          })
          .where((element) =>
              element["declinedBy"] != FirebaseAuth.instance.currentUser!.uid)
          .where((element) =>
              element["modifiedBy"] != FirebaseAuth.instance.currentUser!.uid)
          .toList();
      setState(() {});
    });
    Database().getChatRooms().listen((event) {
      messageDoc = event.docs;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    List<QueryDocumentSnapshot> combinedDoc = [];
    combinedDoc = [...requestDoc, ...messageDoc];
    combinedDoc.sort((a, b) {
      DateTime adate = a['ts'].toDate();
      DateTime bdate = b['ts'].toDate();
      return bdate.compareTo(adate);
    });
    print(combinedDoc.toList());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: h * 16.8,
              ),
              Expanded(
                child: Container(
                  height: h * 72.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    border: Border.all(
                      width: w * 0.2,
                      color: Colors.blue,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 1.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: recent == true
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Color(0xff00AEFF),
                                            width: w * 0.4,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 2.4, vertical: h * 1.1),
                                  child: Text(
                                    "Recent",
                                    style: TextStyle(
                                      fontSize: w * 6.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  recent = true;
                                  upcomming = false;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: upcomming == true
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Color(0xff00AEFF),
                                            width: w * 0.4,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 2.4, vertical: h * 1.1),
                                  child: Text(
                                    "Upcoming ",
                                    style: TextStyle(
                                      fontSize: w * 6.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  recent = false;
                                  upcomming = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: h * 2.2,
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      recent
                          ? Expanded(
                              child: combinedDoc
                                      .where((element) {
                                        if (element["type"] == "service") {
                                          return element["acceptedBy"] !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid;
                                        } else {
                                          return true;
                                        }
                                      })
                                      .toList()
                                      .isNotEmpty
                                  ? ListView.builder(
                                      itemCount: combinedDoc.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return combinedDoc[index]["type"] ==
                                                    "text" ||
                                                combinedDoc[index]["type"] ==
                                                    "image"
                                            ? RecentData(
                                                clr: Colors.blue,
                                                msg: combinedDoc[index],
                                                text: "msg",
                                              )
                                            : combinedDoc[index]["accepted"] ==
                                                        null &&
                                                    combinedDoc[index]
                                                            ["modified"] ==
                                                        null
                                                ? RecentData(
                                                    clr: Colors.blue,
                                                    request: combinedDoc[index],
                                                    text: "new",
                                                  )
                                                : combinedDoc[index]
                                                            ["accepted"] ??
                                                        false
                                                    ? RecentData(
                                                        clr: Colors.blue,
                                                        request:
                                                            combinedDoc[index],
                                                        text: "accepted",
                                                      )
                                                    : combinedDoc[index]
                                                                ["modified"] ??
                                                            false
                                                        ? RecentData(
                                                            clr: Colors.blue,
                                                            request:
                                                                combinedDoc[
                                                                    index],
                                                            text: "modified",
                                                          )
                                                        : !(combinedDoc[index][
                                                                    "accepted"] ??
                                                                true)
                                                            ? RecentData(
                                                                clr:
                                                                    Colors.blue,
                                                                request:
                                                                    combinedDoc[
                                                                        index],
                                                                text:
                                                                    "declined",
                                                              )
                                                            : Container();
                                      })
                                  : Center(
                                      child:
                                          Text("No recent activities to show")),
                            )
                          : Container(),
                      upcomming
                          ? Expanded(
                              child: UpcomingData(
                                  clr: Colors.blue, requests: requestDoc))
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          MeeterAppbar(
            title: "Activity",
            icon: Icons.arrow_back_ios_outlined,
          ),
        ],
      ),
    );
  }
}
