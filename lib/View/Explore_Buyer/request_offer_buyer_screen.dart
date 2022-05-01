import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/place.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/Widgets/HWidgets/offer_appbar_buyer.dart';
import 'package:meeter/Providers/application_bloc.dart';
import 'package:provider/provider.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestOfferBuyer extends StatefulWidget {
  final DemandData doc;
  final OurUser personDetails;
  RequestOfferBuyer({required this.doc, required this.personDetails});
  @override
  _RequestOfferBuyerState createState() => _RequestOfferBuyerState();
}

class _RequestOfferBuyerState extends State<RequestOfferBuyer> {
  late UserController _currentUser;
  final Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  final _locationController = TextEditingController();
  final _scacffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController questionController = TextEditingController();
  DatePickerController datePickerController = DatePickerController();
  DateTime date = DateTime.now();
  int _value = 1;
  String? duration;
  final List<String> _duration = ['30', '40', '50', '60', '70', '80', '90'];

  bool isButtonPressed = false;
  int idx = 0;
  TimeOfDay _startTime = TimeOfDay(hour: 12, minute: 00);

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    locationSubscription =
        applicationBloc.selectedLocation!.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name;
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
    applicationBloc.dispose();
    locationSubscription.cancel();
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
                            color: Colors.green,
                            width: w * 0.4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: w * 0.2,
                          ),
                        ),
                        hintText:
                            'Topic Asked: \nHow did you find a co-founder? \nHow did you find investor for start-up? \nDo i need to know coding and finance to do a start-up? \nWhat is the new advice do you give to new start-up?',
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
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.green,
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
                      color: Colors.green,
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
                              color: Colors.green,
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
                        height: 15,
                      ),
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
                                    ? Colors.green[400]
                                    : Colors.grey[200],
                                child: Text(
                                  _duration[index] + 'min',
                                  style: TextStyle(
                                    fontSize: w * 4.3,
                                  ),
                                ),
                                onPressed: () {
                                  duration = _duration[index];
                                  setState(() {
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
                      color: Colors.green,
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
                                hintText: 'Pin a Location',
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.green,
                                ),
                              ),
                              onChanged: (value) =>
                                  applicationBloc.searchPlaces(value),
                              onTap: () =>
                                  applicationBloc.clearSelectedLocation(),
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
                    title: "Send Request",
                    fontSize: w * 4,
                    clrs: [
                      Colors.green,
                      Colors.green,
                    ],
                    onpressed: () async {
                      if (date.compareTo(DateTime.now()) >= 0) {
                        print(date.toString());
                        if (duration != null) {
                          int totalMin = _startTime.hour < 12
                              ? (_startTime.hour * 60 +
                                  _startTime.minute +
                                  int.parse(duration!))
                              : ((_startTime.hour - 12) * 60 +
                                  _startTime.minute +
                                  int.parse(duration!));
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .doc(widget.personDetails.uid)
                              .set({"r": "r"});
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .doc(widget.personDetails.uid)
                              .collection('request')
                              .add({
                            "type": "demand",
                            "accepted": null,
                            "modified": null,
                            "acceptedBy": "",
                            "modifiedBy": "",
                            "declinedBy": "",
                            "ts": Timestamp.now(),
                            "title": widget.doc.demand_title,
                            "desc": widget.doc.demand_description,
                            "question": questionController.text,
                            "price": widget.doc.demand_price,
                            "seller_location": widget.doc.demand_location,
                            "seller_image": widget.doc.demand_person_image,
                            "seller_id": widget.doc.demand_person_uid,
                            "seller_name": widget.doc.demand_person_name,
                            "date":
                                "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}",
                            "time":
                                "${_startTime.hour == 0 ? 12 : _startTime.hour <= 12 ? _startTime.hour : _startTime.hour - 12}:${_startTime.minute.floor() < 10 ? "0" : ""}${_startTime.minute.floor()}${_startTime.period.index == 0 ? "AM" : "PM"} - ${totalMin ~/ 60 == 0 ? 12 : totalMin ~/ 60 <= 12 ? totalMin ~/ 60 : (totalMin ~/ 60) - 12}:${totalMin % 60}${_startTime.period.index == 0 ? totalMin ~/ 60 >= 12 ? "PM" : "AM" : totalMin ~/ 60 >= 12 ? "AM" : "PM"}",
                            "duration": int.parse(duration!),
                            "startTime": {
                              "hour": _startTime.hour,
                              "min": _startTime.minute
                            },
                            "location": _value == 1 ? "Physical" : "Virtual",
                            "buyer_name":
                                _currentUser.getCurrentUser.displayName,
                            "buyer_image":
                                _currentUser.getCurrentUser.avatarUrl,
                            "buyer_id": _currentUser.getCurrentUser.uid,
                            "meeters": [
                              widget.doc.demand_person_uid,
                              _currentUser.getCurrentUser.uid
                            ]
                          });

                          AchievementView(
                            context,
                            color: Colors.green,
                            icon: Icon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                            ),
                            title: "Success!",
                            elevation: 20,
                            subTitle: "Request sent successfully",
                            isCircle: true,
                          ).show();
                          Navigator.pop(context);
                        } else {
                          _scacffoldKey.currentState!.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Choose duration ',
                              textAlign: TextAlign.center,
                            ),
                          ));
                        }
                      } else {
                        _scacffoldKey.currentState!.showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Invalid time ',
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
          OfferAppBarBuyer(
            icon: Icons.arrow_back_ios_outlined,
            bartitle: 'Request Meet Up',
            icon3: Icons.security_rounded,
            name: widget.personDetails.displayName,
            work: widget.doc.demand_title,
            price: widget.doc.demand_price.toString(),
            price1: '/30min',
            picture: widget.personDetails.avatarUrl,
          ),
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
