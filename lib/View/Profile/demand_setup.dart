import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:meeter/Widgets/progressBtn/flutter_progress_button.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:meeter/View/Profile/const/size_const.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';

class DemandSetup extends StatefulWidget {
  _DemandSetupSetupState createState() => _DemandSetupSetupState();
}

class _DemandSetupSetupState extends State<DemandSetup> {
  TextEditingController demandTitle = TextEditingController();
  TextEditingController demandDescription = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController location = TextEditingController();
  String postId = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  List<String> tags = [];

  late UserController _currentUser;
  late ApplicationBloc applicationBloc;
  late double _distanceToField;
  late TextfieldTagsController _controller;

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
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
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
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: "Enter demand description",
                                  labelText: "Demand Description",
                                ),
                                controller: demandDescription,
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
                      title: Text(
                        'Available for online meet-up',
                        style: TextStyle(fontFamily: "poppins", fontSize: 14),
                      ),
                    ),
                    // SizedBox(
                    //   height: h * 4.2217,
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFieldTags(
                        initialTags: tags,
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
                                      color: Color.fromARGB(255, 74, 137, 92),
                                      width: 3.0,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 74, 137, 92),
                                      width: 3.0,
                                    ),
                                  ),
                                  helperText: 'Enter language...',
                                  helperStyle: const TextStyle(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                  ),
                                  hintText: "Enter tag...",
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
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color: Color.fromARGB(
                                                    255, 74, 137, 92),
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
                                                      '#$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        )
                                      : null,
                                ),
                                onChanged: onChanged,
                                onSubmitted: onSubmitted,
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
                        title: "Submit",
                        fontSize: 12,
                        clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                        onpressed: () async {
                          if (_bannerImage != "" &&
                              _formKey.currentState!.validate()) {
                            await uploadDataToDb();
                            Navigator.pop(context);
                          } else {
                            _scacffoldKey.currentState!.showSnackBar(SnackBar(
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
          MeeterAppbar(
            title: "Demand Setup",
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

  uploadDataToDb() async {
    await FirebaseFirestore.instance
        .collection("demands")
        .doc(_currentUser.getCurrentUser.uid)
        .set({"d": "d"});

    await FirebaseFirestore.instance
        .collection("demands")
        .doc(_currentUser.getCurrentUser.uid)
        .collection('demand')
        .add({
      "featured": false,
      "demand_title": demandTitle.text,
      "demand_description": demandDescription.text,
      "demand_price": int.parse(priceController.text),
      "demand_likes": 0,
      "demand_location": location.text,
      "demand_available_online": value,
      "demand_person_uid": _currentUser.getCurrentUser.uid,
      "demand_person_name": _currentUser.getCurrentUser.displayName,
      "demand_person_image": _currentUser.getCurrentUser.avatarUrl,
      "demand_bannerImage": _bannerImage,
      "demand_tags": tags,
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
