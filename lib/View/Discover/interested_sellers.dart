import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/View/Explore_Seller/detail_screen.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';

class InterestedSellers extends StatefulWidget {
  final DocumentSnapshot doc;
  InterestedSellers(this.doc);
  _InterestedSellersState createState() => _InterestedSellersState();
}

class _InterestedSellersState extends State<InterestedSellers> {
  QuerySnapshot? qdocs;

  int i = 4;

  getMatchingServices() async {
    qdocs = await FirebaseFirestore.instance
        .collectionGroup('meeter')
        .where("meetup_tags",
            arrayContains: widget.doc["keyword"].toLowerCase())
        .orderBy("meetup_likes", descending: true)
        .get();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMatchingServices();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    String ratingString = "";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
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
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: PoppinsText(
                    text:
                        "List of sellers who have or had profession in ${widget.doc["keyword"]}",
                    fontWeight: FontWeight.bold,
                    clr: Color(0xff00AEFF),
                    fontSize: 18,
                  ),
                ),
              ),
              qdocs != null
                  ? qdocs!.docs.take(i).toList().isNotEmpty
                      ? ListView.builder(
                          itemCount: qdocs!.docs.take(i).toList().length,
                          padding: const EdgeInsets.all(0),
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xff00AEFF),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                    qdocs!.docs[index]
                                                        ["meetup_seller_image"],
                                                    width: 80,
                                                    height: 70,
                                                    fit: BoxFit.cover),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              PoppinsText(
                                                text: qdocs!.docs[index]
                                                    ["meetup_seller_name"],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                clr: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PoppinsText(
                                                text: qdocs!.docs[index]
                                                    ["meetup_title"],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                align: TextAlign.start,
                                                clr: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Rating:",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(qdocs!
                                                                  .docs[index][
                                                              "meetup_seller_uid"])
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        double avg = 0;
                                                        if (snapshot.hasData) {
                                                          List ratings = [];
                                                          ratings = snapshot
                                                              .data!["ratings"];
                                                          if (ratings
                                                              .isNotEmpty) {
                                                            int totalVal = 0;
                                                            for (int rating
                                                                in ratings) {
                                                              totalVal +=
                                                                  (rating);
                                                            }
                                                            avg = (totalVal /
                                                                    ratings
                                                                        .length)
                                                                .toPrecision(1);

                                                            if (avg >= 0.8 &&
                                                                avg <= 1.0) {
                                                              ratingString =
                                                                  "Overwhelmingly Positive";
                                                            } else if (avg >=
                                                                    0.6 &&
                                                                avg < 0.8) {
                                                              ratingString =
                                                                  "Mostly Positive";
                                                            } else if (avg >=
                                                                    0.3 &&
                                                                avg < 0.6) {
                                                              ratingString =
                                                                  "Somewhat Positive";
                                                            } else if (avg >=
                                                                    -0.3 &&
                                                                avg < 0.3) {
                                                              ratingString =
                                                                  "Mixed Reviews";
                                                            } else if (avg >=
                                                                    -0.6 &&
                                                                avg < -0.3) {
                                                              ratingString =
                                                                  "Somewhat Negative";
                                                            } else if (avg >=
                                                                    -0.8 &&
                                                                avg < -0.6) {
                                                              ratingString =
                                                                  "Mostly Negative";
                                                            } else if (avg >=
                                                                    -1.0 &&
                                                                avg < -0.8) {
                                                              ratingString =
                                                                  "Overwhelmingly Negative";
                                                            } else {}
                                                          } else {
                                                            ratingString =
                                                                "N/A";
                                                          }
                                                        }
                                                        return snapshot.hasData
                                                            ? Expanded(
                                                                child: Text(
                                                                  "$ratingString",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              )
                                                            : Container();
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  MeetupData data =
                                      MeetupData.fromSnap(qdocs!.docs[index]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              DetailsScreen(data)));
                                },
                              ),
                            );
                          })
                      : Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Text("No sellers match"),
                          ),
                        )
                  : Center(child: Container(child: LinearProgressIndicator())),
              SizedBox(height: 10),
              qdocs != null && qdocs!.docs.take(i).toList().isNotEmpty
                  ? Container(
                      width: 270,
                      height: 50,
                      child: GradientButton(
                        title: "View More",
                        fontSize: 12,
                        clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                        onpressed: () {
                          i += 4;
                          setState(() {});
                        },
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
