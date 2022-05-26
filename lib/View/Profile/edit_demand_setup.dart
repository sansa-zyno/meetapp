import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/progressBtn/flutter_progress_button.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:meeter/View/Profile/const/size_const.dart';
import 'package:meeter/Widgets/TextWidgets/rounded_textfield.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';

class EditDemandSetup extends StatefulWidget {
  final DocumentSnapshot doc;
  EditDemandSetup(this.doc);
  @override
  _EditDemandSetupState createState() => _EditDemandSetupState();
}

class _EditDemandSetupState extends State<EditDemandSetup> {
  TextEditingController demandTitle = TextEditingController();
  TextEditingController demandDescription = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController location = TextEditingController();
  String postId = Uuid().v4();
  late double _distanceToField;
  late TextfieldTagsController _controller;
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();

  List tags = [];
  TextfieldTagsController textfieldTagsController = TextfieldTagsController();
  List<String> searchTerms = [];
  List<String> tagssss = [];

  late UserController _currentUser;

  bool value = false;

  File? _image;
  String _bannerImage = '';

  Future getImage() async {
    final image = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1080);

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
  void initState() {
    // TODO: implement initState
    super.initState();
    demandTitle = TextEditingController(text: widget.doc['demand_title']);
    demandDescription =
        TextEditingController(text: widget.doc['demand_description']);
    location = TextEditingController(text: widget.doc['demand_location']);
    priceController =
        TextEditingController(text: widget.doc['demand_price'].toString());
    _bannerImage = widget.doc['demand_bannerImage'];
    tags = widget.doc['demand_tags'];
    value = widget.doc['demand_available_online'];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    _distanceToField = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scacffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: PoppinsText(
                        text: "Upload a banner picture for your Demand",
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
                              child: Image.network(
                                _bannerImage,
                                fit: BoxFit.fill,
                              ))
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter the title of your demand",
                                  labelText: "Demand Title",
                                ),
                                controller: demandTitle,
                                validator: (value) {
                                  if (value == "") {
                                    return "This field must not be empty.";
                                  }
                                  if (value!.length > 30) {
                                    return "Title cannot be more than 30 characters long.";
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                controller: demandDescription,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff00AEFF), width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff00AEFF), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    hintText: 'Enter Demand description',
                                    labelText: "Demand Description",
                                    labelStyle: TextStyle(
                                      fontFamily: "Nunito",
                                    ),
                                    hintStyle: TextStyle(fontFamily: "Nunito")),
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: RoundedTextField(
                                hint: "Price per 30 minutes",
                                type: TextInputType.number,
                                obsecureText: false,
                                icon: Icon(Icons.settings_voice,
                                    color: Color(0xff00AEFF)),
                                iconColor: Colors.cyan,
                                label: "Price",
                                controller: priceController,
                                onChange: (text) {},
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: RoundedTextField(
                                hint: "Enter Location",
                                type: TextInputType.text,
                                obsecureText: false,
                                icon: Icon(
                                  Icons.location_pin,
                                  color: Color(0xff00AEFF),
                                ),
                                iconColor: Colors.cyan,
                                label: "Preferred Location",
                                controller: location,
                                onChange: (text) {},
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
                      title: Text(
                        'Available for online meet-up',
                        style: TextStyle(fontFamily: "poppins", fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: h * 1.2217,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Please choose your tags from any of the predefined set of tags. Not case sensitive ",
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
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("DynamicTags")
                            .snapshots(),
                        builder: (context, snapshot) {
                          DocumentSnapshot doc = snapshot.data!.docs[0];
                          List tags = doc['tags'];
                          return snapshot.hasData
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white30,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Wrap(
                                    children: tags
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
                                  ),
                                )
                              : Container();
                        }),
                    SizedBox(
                      height: h * 1.2217,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFieldTags(
                        textfieldTagsController: textfieldTagsController,
                        initialTags: tags.map((e) => e.toString()).toList(),
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: tec,
                                focusNode: fn,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
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
                                    color: Color.fromRGBO(20, 22, 20, 0.973),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        '$tag',
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff00AEFF),
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
                                              valueList[spaceCounter]
                                                  .toLowerCase());
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
                              ),
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
                        title: "Update",
                        fontSize: 12,
                        clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
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
                            await updateDataToDb();
                            Navigator.pop(context);
                          } else {
                            _scacffoldKey.currentState!.showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Please enter appropriate values for the fields'),
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
          MeeterAppbar(
            title: " Edit Demand Setup",
            icon: Icons.arrow_back_rounded,
          ),
        ],
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
          boxShadow: [
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
                        hintStyle: TextStyle(
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

  updateDataToDb() async {
    await FirebaseFirestore.instance
        .collection("demands")
        .doc(_currentUser.getCurrentUser.uid)
        .collection('demand')
        .doc(widget.doc.id)
        .update({
      "searchTerms": FieldValue.arrayUnion(searchTerms),
      "demand_title": demandTitle.text != ""
          ? demandTitle.text
          : widget.doc["demand_title"],
      "demand_description": demandDescription.text != ""
          ? demandDescription.text
          : widget.doc["demand_description"],
      "demand_price": priceController.text != ""
          ? int.parse(priceController.text)
          : widget.doc["demand_price"],
      "demand_location":
          location.text != "" ? location.text : widget.doc["demand_location"],
      "demand_available_online": value,
      "demand_person_uid": _currentUser.getCurrentUser.uid,
      "demand_person_name": _currentUser.getCurrentUser.displayName,
      "demand_person_image": _currentUser.getCurrentUser.avatarUrl,
      "demand_bannerImage": _bannerImage,
      "demand_tags": tagssss
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
