import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/View/Explore_Seller/detail_screen.dart';
import 'package:meeter/View/Explore_Buyer/detail_buyer_screen.dart';

class SearchList extends StatelessWidget {
  final Color clr;
  final List ldoc;
  SearchList({required this.clr, required this.ldoc});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ldoc.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                    onTap: () {
                      clr == Colors.blue
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(ldoc[index]),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsBuyerScreen(ldoc[index]),
                              ),
                            );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 4.8, vertical: h * 1.8),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: clr,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 2.4, vertical: h * 1.1),
                                child: Container(
                                  width: 80,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: clr == Colors.blue
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            ldoc[index].meetup_seller_image,
                                            width: 80,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            ldoc[index].demand_person_image,
                                            width: 80,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(right: w * 1.2),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: clr == Colors.blue
                                          ? Text(
                                              ldoc[index].meetup_seller_name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                            )
                                          : Text(
                                              ldoc[index].demand_person_name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                    ),
                                    SizedBox(
                                      height: h * 1.1,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: clr == Colors.blue
                                          ? Text(
                                              ldoc[index].meetup_title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                            )
                                          : Text(
                                              ldoc[index].demand_title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                    ),
                                    SizedBox(
                                      height: h * 1.1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Rating:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(clr == Colors.blue
                                                    ? ldoc[index]
                                                        .meetup_seller_uid
                                                    : ldoc[index]
                                                        .demand_person_uid)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              int avg = 0;
                                              if (snapshot.hasData) {
                                                List ratings = [];
                                                ratings =
                                                    snapshot.data!["ratings"];
                                                if (ratings.isNotEmpty) {
                                                  int sumOfVal = 0;
                                                  for (int rating in ratings) {
                                                    sumOfVal += rating;
                                                  }
                                                  avg = (sumOfVal /
                                                          ratings.length)
                                                      .round();
                                                }
                                              }
                                              return snapshot.hasData
                                                  ? Expanded(
                                                      child: Text(
                                                        "${avg == 0 ? "N/A" : avg == 1 ? "Negative" : avg == 2 ? "Neutral" : "Positive"}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
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
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
