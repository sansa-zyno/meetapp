import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/progressBtn/flutter_progress_button.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:meeter/View/Profile/const/size_const.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';

class MeetSetup extends StatefulWidget {
  _MeetSetupState createState() => _MeetSetupState();
}

class _MeetSetupState extends State<MeetSetup> {
  TextEditingController meetTitle = TextEditingController();
  TextEditingController meetDescription = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController location = TextEditingController();
  String postId = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  List<String> tags = [];
  TextfieldTagsController textfieldTagsController = TextfieldTagsController();

  late UserController _currentUser;
  late ApplicationBloc applicationBloc;
  late double _distanceToField;
  List<String> searchTerms = [];
  List<String> tagssss = [];

  bool value = false;

  File? _image;
  String _bannerImage = '';

  Future getImage() async {
    final image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 25);

    String fileName = '${DateTime.now().toString()}.png';

    if (image != null) {
      ///Saving Pdf to firebase
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask =
          reference.putData(File(image.path).readAsBytesSync());
      String urlImage = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        _image = File(image.path);
        _bannerImage = urlImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    _distanceToField = MediaQuery.of(context).size.width;

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
                      "Meet Setup",
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
      key: _scacffoldKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: PoppinsText(
                    text: "Upload a banner picture for your meet-up",
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: h * 4.2217,
                ),
                GestureDetector(
                  child: _image == null
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff00AEFF), width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.asset("assets/images/image.png"),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff00AEFF), width: 1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  onTap: () {
                    getImage();
                  },
                ),
                SizedBox(
                  height: h * 4.2217,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Enter the title of your meet up",
                              labelText: "Meetup Title",
                            ),
                            controller: meetTitle,
                            validator: (value) {
                              if (value == "") {
                                return "This field must not be empty.";
                              }
                              if (value!.length >= 30) {
                                return "Title cannot be more than 30 characters long.";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              int spaceCounter = 0;
                              // searchTerms.add(value.toLowerCase());
                              if (value.contains(" ")) {
                                var valueList = value.split(" ");
                                log("valueList is: $valueList and ");
                                spaceCounter = valueList.length - 1;
                                log("spaceCounter is: $spaceCounter and ");
                                log("adding ${valueList[spaceCounter]} in if value.contains(' ')");
                                searchTerms
                                    .add(valueList[spaceCounter].toLowerCase());
                                searchTerms.add(value.toLowerCase());
                                log("searchTerms in if value.contains(' ') is: $searchTerms");
                              } else {
                                log("in else of onChange means there's no space.");
                                searchTerms.add(value.toLowerCase());
                              }
                              log("added $value to array: $searchTerms");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 4.2217,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: "Enter Meet up description",
                              labelText: "Meetup Description",
                            ),
                            controller: meetDescription,
                            validator: (value) {
                              if (value == "") {
                                return "This field must not be empty.";
                              }
                              return null;
                            },
                            // onChanged: (value) {
                            //   int spaceCounter = 0;
                            //   if(value.contains(" ")){
                            //     var valueList = value.split(" ");
                            //     log("valueList is: $valueList and ");
                            //     spaceCounter = valueList.length - 1;
                            //     log("spaceCounter is: $spaceCounter and ");
                            //     log("adding ${valueList[spaceCounter]} in if value.contains(' ')");
                            //     searchTerms.add(valueList[spaceCounter].toLowerCase());
                            //     searchTerms.add(value.toLowerCase());
                            //     log("searchTerms in if value.contains(' ') is: $searchTerms");
                            //   }else{
                            //     log("in else of onChange means there's no space.");
                            //     searchTerms.add(value.toLowerCase());
                            //   }
                            //   log("added $value to array: $searchTerms");
                            // },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: h * 4.2217,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Price per 30 minutes",
                              labelText: "Price",
                            ),
                            controller: priceController,
                            validator: (value) {
                              if (value == "") {
                                return "This field must not be empty.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 4.2217,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Enter Location",
                              labelText: "Preferred Location",
                            ),
                            controller: location,
                            validator: (value) {
                              if (value == "") {
                                return "This field must not be empty.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: h * 4.2217,
                // ),
                ListTile(
                  onTap: () {
                    setState(() {
                      this.value = !value;
                    });
                  },
                  leading: Checkbox(
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  title: const Text(
                    'Available for online meet-up',
                    style: TextStyle(fontFamily: "poppins", fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: h * 1.2217,
                ),

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("DynamicTags")
                        .snapshots(),
                    builder: (context, snapshot) {
                      List tagz = [];
                      if (snapshot.hasData) {
                        DocumentSnapshot doc = snapshot.data!.docs[0];
                        tagz = doc['tags'];
                      }
                      return snapshot.hasData
                          ? Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: tagz.isNotEmpty
                                  ? Wrap(
                                      children: tagz
                                          .map((tag) => Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 0, 5),
                                                child: Text("   $tag",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                              ))
                                          .toList(),
                                    )
                                  : Container(),
                            )
                          : Container();
                    }),
                SizedBox(
                  height: h * 1.2217,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Please choose your tags from any of the predefined set of tags above. Not case sensitive ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: h * 1.2217,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextFieldTags(
                    textfieldTagsController: textfieldTagsController,
                    initialTags: tags,
                    inputfieldBuilder:
                        (context, tec, fn, error, onChanged, onSubmitted) {
                      return ((context, sc, tags, onTagDelete) {
                        return TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff00AEFF), width: 2.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            helperText: "Add category tags max 8",
                            helperStyle: const TextStyle(
                              color: Colors.blue,
                            ),
                            errorText: error,
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: _distanceToField * 0.74),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '$tag',
                                                  style: const TextStyle(
                                                      color: Color(0xff00AEFF),
                                                      fontSize: 16),
                                                ),
                                                onTap: () {},
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 25.0,
                                                  color: Color.fromARGB(
                                                      255, 245, 42, 42),
                                                ),
                                                onTap: () {
                                                  onTagDelete(tag);
                                                },
                                              )
                                            ],
                                          ));
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: tags.length <= 7
                              ? (value) {
                                  int spaceCounter = 0;
                                  // searchTerms.add(value.toLowerCase());
                                  if (value.contains(" ")) {
                                    var valueList = value.split(" ");
                                    log("valueList of tags is: $valueList and ");
                                    spaceCounter = valueList.length - 1;
                                    log("spaceCounter of tags  is: $spaceCounter and ");
                                    log("adding ${valueList[spaceCounter]} in if value.contains(' ')");
                                    searchTerms.add(
                                        valueList[spaceCounter].toLowerCase());
                                    searchTerms.add(value.toLowerCase());
                                    log("searchTerms in if value.contains(' ') is: $searchTerms");
                                  } else {
                                    log("in else of onChange of tags means there's no space.");
                                    searchTerms.add(value.toLowerCase());
                                  }
                                  log("added $value to array: $searchTerms");
                                  tags = textfieldTagsController.getTags!;
                                  log("after assigning tags to tags local list in "
                                      "onchange tags: $tags");
                                }
                              : (value) {
                                  // Get.snackbar(
                                  //   "Enough Tags!",
                                  //   "Already added 8 tags",
                                  //   // duration: const Duration(seconds: 3),
                                  // );
                                  log("in else of onchanged and tags.length is: ${tags.length}");
                                },
                          onSubmitted: tags.length <= 7
                              ? onSubmitted
                              : (value) {
                                  Get.snackbar(
                                    "Enough Tags!",
                                    "Already added 8 tags",
                                    duration: const Duration(seconds: 3),
                                  );
                                  log("in else of onSubmitted and tags.length is: ${tags.length}"
                                      " and  value is: $value");
                                },
                        );
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: h * 4.2217,
                ),
                Container(
                  width: 270,
                  height: 50,
                  child: GradientButton(
                    title: "Submit",
                    fontSize: 12,
                    clrs: const [Color(0xff00AEFF), Color(0xff00AEFF)],
                    onpressed: () async {
                      if (_bannerImage != "" &&
                          _formKey.currentState!.validate()) {
                        textfieldTagsController.getTags?.forEach((element) {
                          tagssss.add(element.toLowerCase());
                        });
                        log("tags in Go are: $tagssss");
                        log("searchTerms are in Go before merging are: $searchTerms");
                        searchTerms.addAll(tagssss);
                        log("searchTerms are in Go after merging are: $searchTerms");
                        searchTerms.removeWhere(
                            (element) => element == " " || element == "");
                        log("searchTerms after deleting spaces is in Go after merging are: $searchTerms");
                        await uploadDataToDb();
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: BottomNavBar(),
                          ),
                        );
                      } else {
                        _scacffoldKey.currentState!.showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'All fields are compulsory except the tags field which is optional'),
                        ));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: h * 4.2217,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fieldColorBox(Gradient gradient, String title, String text,
      TextEditingController controller, List<TextInputFormatter> input) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

    return Padding(
      padding: EdgeInsets.only(
        left: w * 7.63888,
        right: w * 7.63888,
        bottom: h * 0.99547,
      ),
      child: Container(
        height: h * 7.466,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.purple,
              blurRadius: 5,
              offset: Offset(0.1, 0.1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: w * 7.6388,
            ),
            Expanded(
              flex: 2,
              child: Wrap(
                children: <Widget>[
                  MediaQuery(
                    data: mqDataNew,
                    child: TextField(
                      inputFormatters: input,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: text,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          fontSize: TEXT_NORMAL_SIZE,
                          color: Colors.grey,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadDataToDb() async {
    await FirebaseFirestore.instance
        .collection("meeters")
        .doc(_currentUser.getCurrentUser.uid)
        .set({"m": "m"});

    await FirebaseFirestore.instance
        .collection("meeters")
        .doc(_currentUser.getCurrentUser.uid)
        .collection('meeter')
        .add({
      "searchTerms": searchTerms,
      "featured": false,
      "meetup_title": meetTitle.text,
      "meetup_description": meetDescription.text,
      "meetup_price": int.parse(priceController.text),
      "meetup_location": location.text,
      "meetup_likes": 0,
      "meetup_available_online": value,
      "meetup_seller_uid": _currentUser.getCurrentUser.uid,
      "meetup_seller_name": _currentUser.getCurrentUser.displayName,
      "meetup_seller_image": _currentUser.getCurrentUser.avatarUrl,
      "meetup_bannerImage": _bannerImage,
      "meetup_tags": tagssss,
      "meetup_date": DateTime.now(),
      "lat": applicationBloc.currentLocation != null
          ? applicationBloc.currentLocation!.latitude
          : 0.0,
      "long": applicationBloc.currentLocation != null
          ? applicationBloc.currentLocation!.longitude
          : 0.0
    });
  }

  Widget nexButton(String text, BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: w * 20.731, vertical: h * 6.2217),
      child: Builder(
        builder: (context) {
          return ProgressButton(
            borderRadius: 30,
            color: Color(0xff8B78F7),
            animate: false,
            defaultWidget: PoppinsText(
              text: "Next",
              fontWeight: FontWeight.w900,
              clr: Colors.white,
            ),
            progressWidget: SpinKitThreeBounce(
              color: Colors.white,
              size: w * 5.0925,
            ),
            width: double.infinity,
            height: 5 * h,
            onPressed: () {},
          );
        },
      ),
    );
  }
}
