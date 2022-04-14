import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/edit_profile_setup.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';

class About extends StatelessWidget {
  late UserController _currentUser;

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
    _currentUser = Provider.of<UserController>(context);
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PoppinsText(
                text: "Description",
                clr: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _currentUser.getCurrentUser.bio != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ReadMoreText(
                    _currentUser.getCurrentUser.bio!,
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
                    "${_currentUser.getCurrentUser.accountCreated!.toDate().day} - ${_currentUser.getCurrentUser.accountCreated!.toDate().month} - ${_currentUser.getCurrentUser.accountCreated!.toDate().year}",
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
          ),
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
                text: "Online",
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
                  .doc(_currentUser.getCurrentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  Map data = snapshot.data!.data()! as Map<String, dynamic>;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
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
                                clr: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: PoppinsText(
                                text: data["${count[index]}Proficiency"] ?? "",
                                clr: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
          SizedBox(height: 20),
          Container(
            width: 250,
            height: 50,
            child: GradientButton(
              title: "Edit Profile",
              clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => EditProfileSetup()));
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
