import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:readmore/readmore.dart';

class About extends StatelessWidget {
  DocumentSnapshot userDoc;
  String id;
  About(this.userDoc, this.id);

  List<String> count = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
    "Seventh",
    "Eightth",
    "Nineth",
    "Tenth"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PoppinsText(
                text: "Bio",
                clr: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          userDoc['bio'] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ReadMoreText(
                    userDoc['bio'],
                    trimLines: 2,
                    style: TextStyle(color: Colors.black),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "poppins",
                        letterSpacing: 1),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ReadMoreText(
                    "N/A",
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: "poppins",
                        letterSpacing: 1),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 0,
            color: Color(0xff00AEFF),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PoppinsText(
                text: "User Information",
                clr: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text: "Member Since",
                clr: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text:
                    "${userDoc['accountCreated'].toDate().day} - ${userDoc['accountCreated'].toDate().month} - ${userDoc['accountCreated'].toDate().year}",
                clr: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          /*SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text: "Recent Meeting",
                clr: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text: "N/A",
                clr: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),*/
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text: "Last Active",
                clr: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PoppinsText(
                text: userDoc['lastActive'],
                clr: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(
            thickness: 0,
            color: Color(0xff00AEFF),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: PoppinsText(
                text: "Languages",
                clr: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("language")
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  Map data = snapshot.data!.data()! as Map<String, dynamic>;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(5),
                      itemCount: (data.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: PoppinsText(
                                text: data["${count[index]}Language"] ?? "",
                                clr: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: PoppinsText(
                                text: data["${count[index]}Proficiency"] ?? "",
                                clr: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
