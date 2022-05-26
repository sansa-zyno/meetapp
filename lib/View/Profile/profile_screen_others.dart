import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readmore/readmore.dart';

class ProfileScreenOther extends StatefulWidget {
  final String id;
  ProfileScreenOther({required this.id});

  @override
  _ProfileScreenOtherState createState() => _ProfileScreenOtherState();
}

class _ProfileScreenOtherState extends State<ProfileScreenOther> {
  final controller = PageController();
  DocumentSnapshot? userDoc;

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

  bool about = true;
  bool service = false;
  bool review = false;

  getUserDetails() async {
    userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .get();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userDoc != null
          ? Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Container(
                            height: 230,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                              child: Container(
                                  child: Image.network(
                                userDoc!['bannerImage'],
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: CircularProfileAvatar(
                                userDoc!['avatarUrl'] ?? '',
                                backgroundColor: Colors.black,
                                initialsText: Text(
                                  "+",
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 21,
                                      color: Colors.white),
                                ),
                                cacheImage: true,
                                borderColor: Colors.black,
                                borderWidth: 5,
                                elevation: 10,
                                radius: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: PoppinsText(
                        text: userDoc!['displayName'] ?? '',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Positive',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PoppinsText(
                      text: userDoc!['country'] ?? '',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border: about == true
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Color(0xff00AEFF),
                                          width: 2,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: PoppinsText(
                                  text: "About",
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                about = true;
                                service = false;
                                review = false;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border: service == true
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Color(0xff00AEFF),
                                          width: 2,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: PoppinsText(
                                  text: "Services ",
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                about = false;
                                service = true;
                                review = false;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border: review == true
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Color(0xff00AEFF),
                                          width: 2,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: PoppinsText(
                                  text: "Reviews ",
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                about = false;
                                service = false;
                                review = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    about == true
                        ? Container(
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
                                userDoc!['bio'] != null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: ReadMoreText(
                                          userDoc!['bio'],
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: PoppinsText(
                                      text:
                                          "${userDoc!['accountCreated'].toDate().day} - ${userDoc!['accountCreated'].toDate().month} - ${userDoc!['accountCreated'].toDate().year}",
                                      clr: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: PoppinsText(
                                      text: "Last Seen",
                                      clr: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: PoppinsText(
                                      text: userDoc!['lastSeen'],
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
                                        .doc(widget.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.data() != null) {
                                        Map data = snapshot.data!.data()!
                                            as Map<String, dynamic>;
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(5),
                                            itemCount: (data.length / 2).ceil(),
                                            itemBuilder: (context, index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0),
                                                    child: PoppinsText(
                                                      text: data[
                                                              "${count[index]}Language"] ??
                                                          "",
                                                      clr: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0),
                                                    child: PoppinsText(
                                                      text: data[
                                                              "${count[index]}Proficiency"] ??
                                                          "",
                                                      clr: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
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
                          )
                        : Container(),
                    service == true
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('meeters')
                                .doc(widget.id)
                                .collection('meeter')
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              QuerySnapshot? query =
                                  snapshot.data as QuerySnapshot?;
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: query!.docs.length,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        query.docs[index]
                                                            ['meetup_title'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        query.docs[index][
                                                            'meetup_description'],
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(query.docs[index]
                                                          ['meetup_location']),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(query.docs[index]
                                                              ['meetup_price']
                                                          .toString()),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Container();
                            })
                        : review == true
                            ? Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "Sorry, this function is still being updated! We\’ll get back to you soon with a new feature",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                  ],
                ),
              ),
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}
