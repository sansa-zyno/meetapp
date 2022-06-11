import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/offer_appbar.dart';
import 'package:meeter/Widgets/HWidgets/offer_appbar_buyer.dart';
import 'package:provider/provider.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:meeter/Model/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeter/View/meet_up_details.dart';
import 'package:geocoding/geocoding.dart';

class EditRequestOffer extends StatefulWidget {
  final DocumentSnapshot doc;
  final Color clr;
  EditRequestOffer({required this.doc, required this.clr});
  @override
  _EditRequestOfferState createState() => _EditRequestOfferState();
}

class _EditRequestOfferState extends State<EditRequestOffer> {
  late StreamSubscription locationSubscription;
  late UserController _currentUser;
  final Completer<GoogleMapController> _mapController = Completer();
  DatePickerController datePickerController = DatePickerController();
  late TextEditingController questionController;
  late TextEditingController _locationController;
  late String time;
  late DateTime date;
  int _value = 1;
  late String duration;
  final List<String> _duration = ['30', '40', '50', '60', '70', '80', '90'];
  bool isButtonPressed = false;
  int idx = 0;
  late TimeOfDay _startTime;
  void _selectTime(ctx) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: ctx,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
      });
    }
  }

  final _scacffoldKey = GlobalKey<ScaffoldState>();
  double placeLat = 0.0;
  double placeLng = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTime = TimeOfDay(
        hour: widget.doc['startTime']['hour'],
        minute: widget.doc['startTime']['min']);
    questionController = TextEditingController(text: widget.doc['question']);
    _locationController =
        TextEditingController(text: widget.doc['location_address']);
    time = widget.doc['time'];
    {
      duration = widget.doc['duration'].toString();
      idx = _duration.indexOf(duration);
      isButtonPressed = true;
    }
    widget.doc['location'] == "Physical" ? _value = 1 : _value = 2;
    date = DateTime.parse(widget.doc['date']);
    setState(() {});
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation!.stream.listen((place) {
      if (place != null) {
        // _locationController.text = place.name;
        _goToPlace(place);
      } else {
        _locationController.text = "";
      }
    });
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription.cancel();
    applicationBloc.dispose();
    _locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      key: _scacffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: h * 32.5),
                Center(
                  child: SizedBox(
                    width: w * 85.3,
                    child: TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: widget.clr,
                            width: w * 0.4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: widget.clr,
                            width: w * 0.2,
                          ),
                        ),
                        hintText:
                            'How did you find a co-founder? \nHow did you find investor for start-up? \nDo i need to know coding and finance to do a start-up? \nWhat is the new advice do you give to new start-up?',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintMaxLines: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 2.2),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 2.4, vertical: h * 1.1),
                    child: DatePicker(
                      DateTime.now(),
                      controller: datePickerController,
                      initialSelectedDate: date,
                      selectionColor: widget.clr,
                      selectedTextColor: Colors.white,
                      onDateChange: (dte) {
                        setState(() {
                          date = dte;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: h * 1.1),
                Container(
                  width: w * 88.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.clr,
                      width: w * 0.2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 3.6,
                          vertical: h * 2.2,
                        ),
                        child: Text(
                          'Choose Available Time',
                          style: TextStyle(
                              color: widget.clr,
                              fontSize: w * 6.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 3.6,
                          ),
                          child: Row(
                            children: [
                              MaterialButton(
                                color: Colors.grey[200],
                                child: Text("Select time"),
                                onPressed: () {
                                  _selectTime(context);
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "${_startTime.hour == 0 ? 12 : _startTime.hour <= 12 ? _startTime.hour : _startTime.hour - 12} : ${_startTime.minute.floor() < 10 ? "0" : ""}${_startTime.minute.floor()} ${_startTime.period.index == 0 ? "AM" : "PM"}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                      SizedBox(
                        height: h * 13,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _duration.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 3.6,
                                vertical: h * 2.2,
                              ),
                              child: RaisedButton(
                                color: isButtonPressed && idx == index
                                    ? widget.clr
                                    : Colors.grey[200],
                                child: Text(
                                  _duration[index] + "min",
                                  style: TextStyle(
                                    fontSize: w * 4.3,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    duration = _duration[index];
                                    isButtonPressed = !isButtonPressed;
                                    idx = index;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 2.2),
                Container(
                  width: w * 80.4,
                  height: h * 6.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.clr,
                      width: 0.2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 4.8, vertical: h * 2.2),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text("Physical"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Virtual"),
                          value: 2,
                        ),
                      ],
                      onChanged: (int? value) {
                        setState(
                          () {
                            _value = value!;
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: h * 2.2),
                _value == 1
                    ? Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _locationController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText:
                                    "Search a place. Pin location by long-pressing on the map",
                                hintMaxLines: 2,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: widget.clr,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search, color: widget.clr),
                                  onPressed: () =>
                                      applicationBloc.clearSelectedLocation(),
                                ),
                              ),
                              onChanged: (value) =>
                                  applicationBloc.searchPlaces(value),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                  height: 300.0,
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    myLocationEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: applicationBloc.currentLocation !=
                                              null
                                          ? LatLng(
                                              applicationBloc
                                                  .currentLocation!.latitude,
                                              applicationBloc
                                                  .currentLocation!.longitude)
                                          : LatLng(0, 0),
                                      zoom: 14,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _mapController.complete(controller);
                                    },
                                    onLongPress: (LatLng position) async {
                                      placeLat = position.latitude;
                                      placeLng = position.longitude;
                                      List<Placemark> placemarks =
                                          await placemarkFromCoordinates(
                                              position.latitude,
                                              position.longitude);
                                      //print(placemarks[0].name);
                                      //print(placemarks.toString());
                                      _locationController.text =
                                          "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";
                                      _scacffoldKey.currentState!
                                          .showSnackBar(SnackBar(
                                        backgroundColor: widget.clr,
                                        content: Text(
                                          'Location selected',
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                                    },
                                  )),
                              if (applicationBloc.searchResults != null &&
                                  applicationBloc.searchResults!.isNotEmpty)
                                Container(
                                    height: 300.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.6),
                                        backgroundBlendMode: BlendMode.darken)),
                              if (applicationBloc.searchResults != null)
                                Container(
                                  height: 300.0,
                                  child: ListView.builder(
                                      itemCount:
                                          applicationBloc.searchResults!.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            applicationBloc
                                                .searchResults![index]
                                                .description,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            applicationBloc.setSelectedLocation(
                                                applicationBloc
                                                    .searchResults![index]
                                                    .placeId);
                                          },
                                        );
                                      }),
                                ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 20),
                Container(
                  width: w * 50,
                  height: h * 6.7,
                  child: GradientButton(
                    title: "Update",
                    fontSize: w * 4,
                    clrs: [widget.clr, widget.clr],
                    onpressed: () async {
                      String dateToString =
                          "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}";
                      int startHour = _startTime.hour;
                      int startMin = _startTime.minute;
                      int timeInMin = (startHour * 60) + startMin;
                      String startTime =
                          "${(timeInMin ~/ 60).floor() < 10 ? "0" : ""}${(timeInMin ~/ 60).floor()}:${(timeInMin % 60).floor() < 10 ? "0" : ""}${(timeInMin % 60).floor()}";
                      String formattedString = "$dateToString $startTime";
                      DateTime dateTime = DateTime.parse(formattedString);
                      if (dateTime.compareTo(DateTime.now()) >= 0) {
                        if (duration != "") {
                          int totalMin = _startTime.hour < 12
                              ? (_startTime.hour * 60 +
                                  _startTime.minute +
                                  int.parse(duration))
                              : ((_startTime.hour - 12) * 60 +
                                  _startTime.minute +
                                  int.parse(duration));
                          Map<String, dynamic> map = {
                            "read": false,
                            "modified": true,
                            "accepted": null,
                            "modifiedBy":
                                FirebaseAuth.instance.currentUser!.uid,
                            "question": questionController.text,
                            "ts": Timestamp.now(),
                            "date":
                                "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}",
                            "time":
                                "${_startTime.hour == 0 ? 12 : _startTime.hour <= 12 ? _startTime.hour : _startTime.hour - 12}:${_startTime.minute.floor() < 10 ? "0" : ""}${_startTime.minute.floor()}${_startTime.period.index == 0 ? "AM" : "PM"} - ${totalMin ~/ 60 == 0 ? 12 : totalMin ~/ 60 <= 12 ? totalMin ~/ 60 : (totalMin ~/ 60) - 12}:${totalMin % 60}${_startTime.period.index == 0 ? totalMin ~/ 60 >= 12 ? "PM" : "AM" : totalMin ~/ 60 >= 12 ? "AM" : "PM"}",
                            "duration": int.parse(duration),
                            "location": _value == 1 ? "Physical" : "Virtual",
                            "location_address": _locationController.text,
                            "startTime": {
                              "hour": _startTime.hour,
                              "min": _startTime.minute
                            },
                            "placeLat": placeLat,
                            "placeLng": placeLng
                          };
                          if (_value == 1) {
                            if (_locationController.text != "") {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(widget.doc['seller_id'])
                                  .collection('request')
                                  .doc(widget.doc.id)
                                  .update(map);
                              AchievementView(
                                context,
                                color: Colors.green,
                                icon: Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                ),
                                title: "Success!",
                                elevation: 20,
                                subTitle: "Update sent successfully",
                                isCircle: true,
                              ).show();
                              DocumentSnapshot doc = await FirebaseFirestore
                                  .instance
                                  .collection('requests')
                                  .doc(widget.doc['seller_id'])
                                  .collection('request')
                                  .doc(widget.doc.id)
                                  .get();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          MeetUpDetails(doc, widget.clr)));
                            } else {
                              _scacffoldKey.currentState!.showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Please pin a location',
                                  textAlign: TextAlign.center,
                                ),
                              ));
                            }
                          } else {
                            await FirebaseFirestore.instance
                                .collection('requests')
                                .doc(widget.doc['seller_id'])
                                .collection('request')
                                .doc(widget.doc.id)
                                .update(map);
                            AchievementView(
                              context,
                              color: Colors.green,
                              icon: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.white,
                              ),
                              title: "Success!",
                              elevation: 20,
                              subTitle: "Update sent successfully",
                              isCircle: true,
                            ).show();
                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection('requests')
                                .doc(widget.doc['seller_id'])
                                .collection('request')
                                .doc(widget.doc.id)
                                .get();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        MeetUpDetails(doc, widget.clr)));
                          }
                        } else {
                          _scacffoldKey.currentState!.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Choose duration',
                              textAlign: TextAlign.center,
                            ),
                          ));
                        }
                      } else {
                        _scacffoldKey.currentState!.showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Invalid time',
                            textAlign: TextAlign.center,
                          ),
                        ));
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          widget.clr == Colors.blue
              ? OfferAppBar(
                  icon: Icons.arrow_back_ios_outlined,
                  bartitle: 'Edit Request Meet Up',
                  icon3: Icons.security_rounded,
                  name: widget.doc['seller_name'],
                  work: widget.doc['title'],
                  price: widget.doc['price'].toString(),
                  price1: '/30min',
                  picture: widget.doc['seller_image'])
              : OfferAppBarBuyer(
                  icon: Icons.arrow_back_ios_outlined,
                  bartitle: 'Edit Request Meet Up',
                  icon3: Icons.security_rounded,
                  name: widget.doc['seller_name'],
                  work: widget.doc['title'],
                  price: widget.doc['price'].toString(),
                  price1: '/30min',
                  picture: widget.doc['seller_image']),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }
}
