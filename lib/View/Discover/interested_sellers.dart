import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';

class InterestedSellers extends StatefulWidget {
  _InterestedSellersState createState() => _InterestedSellersState();
}

class _InterestedSellersState extends State<InterestedSellers> {
  late UserController _currentUser;

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);

    OurUser myUser;
    setState(() {
      myUser = _currentUser.getCurrentUser;
    });

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: PoppinsText(
                        text:
                            "List of sellers who have or had profession in pro gaming",
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        clr: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff00AEFF),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/dp1.png"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PoppinsText(
                                      text: "John Doe ",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      align: TextAlign.center,
                                      clr: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: PoppinsText(
                                      text:
                                          "“I’m the creator of Meeter! Meet with me to learn more about Entrepreneurship” ",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      align: TextAlign.start,
                                      clr: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: PoppinsText(
                                            text: "Ratings",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            align: TextAlign.start,
                                            clr: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff00AEFF),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/dp2.png"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PoppinsText(
                                      text: "Alessia James ",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      align: TextAlign.center,
                                      clr: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: PoppinsText(
                                      text:
                                          "“I’m a Mother of two! Meet with me to learn about raising kids!”",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      align: TextAlign.start,
                                      clr: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: PoppinsText(
                                            text: "Ratings",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            align: TextAlign.start,
                                            clr: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff00AEFF),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/dp3.png"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: PoppinsText(
                                      text: "Jayden Smith ",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      align: TextAlign.center,
                                      clr: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: PoppinsText(
                                      text:
                                          "“I’m the creator of Meeter! Meet with me to learn more about Entrepreneurship” ",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      align: TextAlign.start,
                                      clr: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: PoppinsText(
                                            text: "Ratings",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            align: TextAlign.start,
                                            clr: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffFFD632),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 270,
                    height: 50,
                    child: GradientButton(
                      title: "View More",
                      fontSize: 12,
                      clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                      onpressed: () {},
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          MeeterAppbar(
            title: "DISCOVER",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
