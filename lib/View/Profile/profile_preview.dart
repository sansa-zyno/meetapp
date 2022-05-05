import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/profile_preview_widgets/about.dart';
import 'package:meeter/View/Profile/profile_preview_widgets/demands.dart';
import 'package:meeter/View/Profile/profile_preview_widgets/service.dart';
import 'package:meeter/View/Profile/profile_preview_widgets/achievement.dart';
import 'package:meeter/View/Profile/profile_preview_widgets/reviews.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';

class ProfilePreview extends StatefulWidget {
  final Color clr;
  ProfilePreview({required this.clr});

  @override
  _ProfilePreviewState createState() => _ProfilePreviewState();
}

class _ProfilePreviewState extends State<ProfilePreview> {
  final controller = PageController();

  bool about = true;
  bool service = false;
  bool demand = false;
  bool review = false;
  bool connection = false;
  bool achievement = false;
  late UserController _currentUser;

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);
    return Scaffold(
      body: Container(
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
                        child: GestureDetector(
                          child: Container(
                            child: _currentUser.getCurrentUser.bannerImage !=
                                    null
                                ? Image.network(
                                    _currentUser.getCurrentUser.bannerImage!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : Container(),
                          ),
                          onTap: () async {
                            _currentUser = Provider.of<UserController>(context,
                                listen: false);
                            await _currentUser.updateBanner(
                                _currentUser.getCurrentUser.uid!, "users");
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: CircularProfileAvatar(
                          _currentUser.getCurrentUser.avatarUrl ?? '',
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
                          onTap: () async {
                            _currentUser = Provider.of<UserController>(context,
                                listen: false);
                            await _currentUser
                                .updateAvatar(_currentUser.getCurrentUser.uid!);
                            //Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: PoppinsText(
                  text: _currentUser.getCurrentUser.displayName ?? '',
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
                text: _currentUser.getCurrentUser.country ?? '',
                fontSize: 12,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: GradientButton(
                          title: "Connection",
                          clrs: [widget.clr, widget.clr],
                          fontSize: 12,
                          letterSpacing: 0,
                          onpressed: () {
                            setState(() {
                              about = false;
                              service = false;
                              demand = false;
                              review = false;
                              achievement = false;
                              connection = true;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 50,
                        child: GradientButton(
                          fontSize: 12,
                          letterSpacing: 0,
                          title: "Achievement",
                          textClr: Color(0xff00AEFF),
                          clrs: [Colors.white, Colors.white],
                          border: Border.all(color: widget.clr),
                          onpressed: () {
                            setState(() {
                              about = false;
                              service = false;
                              demand = false;
                              review = false;
                              achievement = true;
                              connection = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                          demand = false;
                          review = false;
                          achievement = false;
                          connection = false;
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
                          demand = false;
                          review = false;
                          achievement = false;
                          connection = false;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: demand == true
                              ? Border(
                                  bottom: BorderSide(
                                    color: Color(0xff00AEFF),
                                    width: 2,
                                  ),
                                )
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: PoppinsText(
                            text: "Demands",
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          about = false;
                          service = false;
                          demand = true;
                          review = false;
                          achievement = false;
                          connection = false;
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
                          demand = false;
                          review = true;
                          achievement = false;
                          connection = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              about == true
                  ? About(
                      clr: widget.clr,
                    )
                  : Container(),
              service == true ? Services() : Container(),
              demand == true ? Demands() : Container(),
              review == true ? Review() : Container(),
              achievement == true ? Achievement() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
