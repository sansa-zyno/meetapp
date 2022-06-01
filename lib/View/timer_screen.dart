import 'dart:developer';

import 'package:achievement_view/achievement_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meeter/View/common_problems.dart';
import 'package:meeter/View/emergency.dart';
import 'package:meeter/Widgets/dialog_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Constants/controllers.dart';
import '../Constants/get_token.dart';
import '../Providers/user_controller.dart';

class Timer extends StatefulWidget {
  final DocumentSnapshot request;

  Timer(this.request);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  double currentCharge = 0.0;
  double extraCharge = 0.0;
  double extraTimeCharge = 0.0;
  int extraMinutes = 0;
  int extraSeconds = 0;
  double totalCharge = 0.0;
  late DatabaseReference ref;
  late DocumentReference ref2;
  var directory;
  bool endDialogAnswer = false;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentCharge = widget.request["price"] / widget.request["duration"];
    extraCharge = currentCharge + (currentCharge * 0.3);
    log("currentCharge is: $currentCharge and extraCharge is: $extraCharge");
    // timerController.startStream(widget.request);
    directory = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);

    ref = FirebaseDatabase.instance.ref().child('$directory/');
    ref2 = FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory);
  }

  bool callEndDialog() {
    Get.defaultDialog(
      title: "Caution!",
      middleText: "Are you sure you want to end the meeting?",
      textConfirm: "Yes",
      textCancel: "No",
      buttonColor: Colors.white,
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.blue,
      onConfirm: () async {
        await ref2.set({
          // "startAt": FieldValue.serverTimestamp(),
          "meetId": directory,
          "seconds": -1,
          "start_requester_id": UserController().auth.currentUser?.uid,
          "pause_requester_id": ""
        }).then((value) {
          ref.set({
            "meetId": directory,
            "startAt": ServerValue.timestamp,
            "seconds": -2,
            "start_requester_id": UserController().auth.currentUser?.uid,
            "pause_requester_id": ""
          });
          log("in on Tap passed a start/stop request");
          // timerController.meetingMode();
        });
        Get.back();
        endDialogAnswer = true;
        // return true;
      },onCancel: () {
      endDialogAnswer = false;
    }
    );
    return endDialogAnswer;
  }
  bool answer = true;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return WillPopScope(
      onWillPop: () async {
        log("in will pop scope and answer $answer and endDialogAnswer $endDialogAnswer");
        if(timerController.isMeetingRunning.value){
          log("inside if meeting is running");
          answer = callEndDialog();
        }
        log("in will pop scope after if and answer $answer and endDialogAnswer $endDialogAnswer");
        return answer;
      },
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: ref2.snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot,
                  ) {
                log("inside streambuilder");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  log("inside streambuilder in waiting state");
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    log("inside hasdata and ${snapshot.data?.data()}");
                    if (snapshot.data?.data() != null) {
                      // var dataMap = snapshot.data?.data();
                      var data = snapshot.data?.data();
                      log("data is: $data");
                      // var jsonString = json.encode(event.snapshot.value);
                      // log("jsonString: $jsonString");
                      // var jsonData = jsonDecode(jsonString);
                      // log("jsonData is: $jsonData");
                      Map<String, dynamic>? dataMap = (data ?? {}) as Map<String, dynamic>?;
                      // log("jsonData is: $jsonData");
                      // log("dataMap is: ${dataMap['lSeconds'].runtimeType}");
                      log("dataMap is: ${dataMap!['seconds']}");
                      log("data is: $data");
                      // Timestamp tmp = dataMap['startAt'] ?? Timestamp(0, 0);
                      // startAt.value = dataMap != {} ? tmp.millisecondsSinceEpoch : 0;
                      timerController.timerSeconds.value = dataMap != {} ? dataMap['seconds'] : 0;
                      // log("values are: startAt.value: ${startAt.value} and "
                      //     " timerSeconds.value: ${timerSeconds.value} and ");
                      if (timerController.timerSeconds.value == 0) {
                        //+ 0 means nothing for the other user -> means the timer won't start
                        //+ when page is opened and 0 is in RTDB
                        log("inside 0 wala");
                        log("in 0 with no before if id == request['meetId']and and request['meetId']: ${dataMap['meetId']}");
                        // isMeetingRunning.value = false;
                        // if(timer.isActive){
                        //   log("inside timer is active");
                        //   timer.cancel();
                        //   resetTimer();
                        // }
                      }
                      else if (timerController.timerSeconds.value == -1) {
                        //+ -1 means the meeting is ended and  timer is reset and the value
                        //+ in RTDB is changed to 0.
                        log("is meeting end called ");
                        log("request: ${widget.request.data()}");

                        var id = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);
                        log("in -1 before if id == widget.request['meetId'] and id: $id and and widget.request['meetId']: ${dataMap['meetId']}");

                        if(id == dataMap['meetId']){
                          timerController.isMeetingRunning.value = false;
                          log("cancel timer called.");
                          timerController.timer.cancel();
                          log("cancel timerController.timer called.");
                          // meetingMode(); //+ I added this 23-4
                          log("local values are: timerController.lMinutes: ${timerController.lMinutes} and "
                              "lSeconds: ${timerController.lSeconds}");
                          timerController.totalChargeT = 0;
                          timerController.extraMinutesT = 0;
                          timerController.extraSecondsT = 0;
                          timerController.extraTimeChargeT = 0;
                          timerController.currentChargeT = widget.request["price"] / widget.request["duration"];

                          if (int.parse(timerController.lMinutes) > widget.request["duration"] ||
                              (int.parse(timerController.lMinutes) == widget.request["duration"])) {
                            log("inside timerController.lMinutes less if widget.request['duration']: ${widget.request["duration"]} \n\n "
                                " int.parse(timerController.lMinutes): ${int.parse(timerController.lMinutes)}");
                            totalCharge = widget.request["duration"] * currentCharge;
                            extraMinutes = (int.parse(timerController.lMinutes) - widget.request["duration"]).toInt();
                            extraSeconds = int.parse(timerController.lSeconds);
                            log("total charge is: $totalCharge");
                            timerController.extraTimeChargeT = timerController.extraMinutesT * timerController.extraChargeT;
                            timerController.extraTimeChargeT += timerController.extraSecondsT * (timerController.extraChargeT / 60);
                            timerController.totalChargeT += timerController.extraTimeChargeT;
                          } else {
                            log("inside else less if");
                            timerController.totalChargeT = int.parse(timerController.lMinutes) * timerController.currentChargeT;
                            totalCharge +=
                                ((int.parse(timerController.lSeconds) * (timerController.currentChargeT / 60)).toPrecision(3))
                                    .toPrecision(2);
                          }
                          // resetTimer();
                          log("after refreshing minutes: ${timerController.minutes}"
                              " Seconds: ${timerController.seconds}");
                          log("returnVValue of leaveChannel is:");
                          log("\n\n\n"
                              "You were in the meeting for "
                              "${timerController.lMinutes} minutes and ${timerController.seconds} lSeconds. "
                              "You are being charged \$${timerController.totalChargeT} for "
                              "this meeting."
                              "\n\n\n");
                          String name = "";
                          String pronoun = "";
                          if (UserController().auth.currentUser?.uid == widget.request["seller_id"]) {
                            name = widget.request["buyer_name"];
                            pronoun = "He";
                          } else {
                            name = "You";
                            pronoun = "You";
                          }

                          if (!timerController.isDialogShown) {
                            log("inside showing dialog");
                            DialogUtils.showCustomDialog(
                                context,
                                title: "Attention!",
                                middleText: "$name "
                                    "${name == "You" ? "were" : "was"} in the meeting for "
                                    "${timerController.lMinutes} minutes and ${timerController.lSeconds} seconds. "
                                    "$pronoun ${pronoun == "You" ? "are" : "is"} being charged "
                                    "\$${timerController.totalChargeT.toPrecision(2)} for "
                                    "this meeting.",
                                okBtnFunction: () async {
                                  DateTime date = DateTime.now();
                                  await FirebaseFirestore.instance
                                      .collection("connections")
                                      .add({
                                    "title": widget.request["title"],
                                    "seller_id": widget.request["seller_id"],
                                    "seller_name": widget.request["seller_name"],
                                    "seller_image": widget.request["seller_image"],
                                    "buyer_id": widget.request["buyer_id"],
                                    "buyer_name": widget.request["buyer_name"],
                                    "buyer_image": widget.request["buyer_image"],
                                    "date":
                                    "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}",
                                    "meeters": ["${widget.request["seller_id"]}", "${widget.request["buyer_id"]}"]
                                  });
                                  timerController.isDialogShown = true;
                                  Get.back();
                                  ref2.update({
                                    // "startAt": FieldValue.serverTimestamp(),
                                    "seconds": 0,
                                    "start_requester_id": dataMap["start_requester_id"],
                                    "pause_requester_id": dataMap["pause_requester_id"]
                                  });
                                },
                                cancelBtnFunction: () {
                                  Get.back();
                                }
                            );
                            //+
                            //+
                            // Get.defaultDialog(
                            //     barrierDismissible: false,
                            //     title: "Attention!",
                            //     middleText: "$name "
                            //         "${name == "You" ? "were" : "was"} in the meeting for "
                            //         "${timerController.lMinutes} minutes and ${timerController.lSeconds} seconds. "
                            //         "$pronoun ${pronoun == "You" ? "are" : "is"} being charged "
                            //         "\$${timerController.totalChargeT.toPrecision(2)} for "
                            //         "this meeting.",
                            //     confirmTextColor: Colors.white,
                            //     textConfirm: "Ok",
                            //     onConfirm: () async {
                            //       //+HANDLE THIS HERE PLEASE IN WHATEVER WAY YOU WANT. yOU MIGHT ALSO WANT tO
                            //       //+DELETE THIS MEETING FRoM THE RECENT ONES OR THE REQUESTS AFTER THIS MEETING
                            //       //+ IS ENDED hERE
                            //       DateTime date = DateTime.now();
                            //       await FirebaseFirestore.instance
                            //           .collection("connections")
                            //           .add({
                            //         "title": widget.request["title"],
                            //         "seller_id": widget.request["seller_id"],
                            //         "seller_name": widget.request["seller_name"],
                            //         "seller_image": widget.request["seller_image"],
                            //         "buyer_id": widget.request["buyer_id"],
                            //         "buyer_name": widget.request["buyer_name"],
                            //         "buyer_image": widget.request["buyer_image"],
                            //         "date":
                            //         "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}",
                            //         "meeters": ["${widget.request["seller_id"]}", "${widget.request["buyer_id"]}"]
                            //       });
                            //       timerController.isDialogShown = true;
                            //       Get.back();
                            //       ref2.update({
                            //         // "startAt": FieldValue.serverTimestamp(),
                            //         "seconds": 0,
                            //         "start_requester_id": dataMap["start_requester_id"],
                            //         "pause_requester_id": dataMap["pause_requester_id"]
                            //       });
                            //     },
                            // );
                          }
                          timerController.resetTimer();
                        }
                        else{
                          log("in stop else meaning this is some other meeting page and the stop was called for some other one");
                        }

                        // lMinutes = this.minutes.value;
                        // lSeconds = this.seconds.value;
                        // meetingMode();

                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) =>
                        //         AlertDialog(
                        //           title: Text(
                        //               "${widget.request["buyer_name"]} "
                        //                   "was in the meeting for "
                        //                   "$lMinutes lMinutes and $lSeconds lSeconds. "
                        //                   "He is being charged \$$totalCharge for "
                        //                   "this meeting."),
                        //           actions: [
                        //             TextButton(
                        //               child: const Text("Ok"),
                        //               onPressed: () async {
                        //                 // AchievementView(
                        //                 //   context,
                        //                 //   color: Colors
                        //                 //       .green,
                        //                 //   icon: const Icon(
                        //                 //     FontAwesomeIcons
                        //                 //         .check,
                        //                 //     color: Colors
                        //                 //         .white,
                        //                 //   ),
                        //                 //   title:
                        //                 //   "Succesfull!",
                        //                 //   elevation:
                        //                 //   20,
                        //                 //   subTitle:
                        //                 //   "Request Cancelled succesfully",
                        //                 //   isCircle:
                        //                 //   true,
                        //                 // ).show();
                        //                 Navigator.pop(context);
                        //               },
                        //             ),
                        //             // FlatButton(
                        //             //   child:
                        //             //   const Text("No"),
                        //             //   onPressed: () {
                        //             //     Navigator.pop(
                        //             //         context);
                        //             //   },
                        //             // )
                        //           ],
                        //         ));
                        // ref2.set({
                        //   // "startAt": FieldValue.serverTimestamp(),
                        //   "lSeconds": 0,
                        //   "start_requester_id": dataMap["start_requester_id"],
                        //   "pause_requester_id": dataMap["pause_requester_id"]
                        // });
                      }
                      else if (timerController.timerSeconds.value == 1) {
                        //+means it is paused
                        //+ 1 means the timer is to be paused for the both the users.
                        /**/
                        // timer.cancel();
                        // resetTimer2();
                        // isMeetingPaused2.value = true;
                        // if (!isMeetingPaused.value) {
                        // isMeetingPaused.value = true;

                        var id = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);
                        log("in 1 before if id == widget.request['meetId'] and id: $id and and widget.request['meetId']: ${dataMap['meetId']}");

                        if(id == dataMap['meetId']){
                          log("inside if id == widget.request['meetId']");
                          timerController.pauseMode();
                          ref2.update({
                            // "startAt": FieldValue.serverTimestamp(),
                            "seconds": 0,
                            "start_requester_id": dataMap["start_requester_id"],
                            "pause_requester_id": dataMap["pause_requester_id"]
                          });
                        }else{
                          log("in paused else meaning this is some other meeting page and the pause was called for some other one");
                        }
                        // }
                      }
                      else if (timerController.timerSeconds.value == -2) {
                        //+ -2 means a start or end request (based on the isMeetingRunning value) is made and if accepted the meeting
                        //+ starts setting value in RTDB as Requested Time,
                        //+ if rejected the meeting doesn't start putting '0' in RTDB.
                        //+ but if there is no answer which would be reflected from RxBool isStartAnswered means meeting can't start
                        //+ setting or putting '0' in RTDB

                        //+ let's also add a requested by ID in the data in RTDB

                        var id = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);
                        if(id == dataMap['meetId']){
                          timerController.isDialogShown = false;
                          timerController.lMinutes = timerController.minutes.value;
                          timerController.lSeconds = timerController.seconds.value;
                          log("current user id in -2 is: ${UserController().auth.currentUser?.uid} "
                              "and other id is: ");
                          if (UserController().auth.currentUser?.uid !=
                              dataMap["start_requester_id"]) {
                            //+ this means I am the buyer and I should see the dialog regarding start of meeting
                            var name = "";
                            if (dataMap["start_requester_id"] == widget.request["seller_id"]) {
                              name = widget.request["seller_name"];
                              log("inside the name if: $name");
                            } else {
                              name = widget.request["buyer_name"];
                              log("inside the name else: $name");
                            }
                            log("right before the default dialog the name if: $name");

                            DialogUtils.showCustomDialog(
                                context,
                                title: "Attention!",
                                middleText: "$name has requested to ${!timerController.isMeetingRunning.value ? 'start' : 'stop'} the meeting. Do you agree?",
                                okBtnFunction: () {
                                  timerController.isStartAnswered.value = true;
                                  if (!timerController.isMeetingRunning.value) {
                                    log("in -2 in yes !timerController.isMeetingRunning else");
                                    timerController.meetingMode();
                                    ref2.update({
                                      // "startAt": FieldValue.serverTimestamp(),
                                      "seconds": widget.request["duration"],
                                      "start_requester_id": dataMap["start_requester_id"],
                                      "pause_requester_id": dataMap["pause_requester_id"]
                                    });
                                    Get.back();
                                  } else {
                                    log("in -2 !timerController.isMeetingRunning else");
                                    timerController.lMinutes = timerController.minutes.value;
                                    timerController.lSeconds = timerController.seconds.value;
                                    timerController.meetingMode();
                                    ref2.update({
                                      // "startAt": FieldValue.serverTimestamp(),
                                      "seconds": -1,
                                      "start_requester_id": dataMap["start_requester_id"],
                                      "pause_requester_id": dataMap["pause_requester_id"]
                                    });
                                    Get.back();
                                  }
                                },
                              cancelBtnFunction: () {
                                timerController.isStartAnswered.value = true;
                                ref2.update({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "seconds": 0,
                                  "start_requester_id": dataMap["start_requester_id"],
                                  "pause_requester_id": dataMap["pause_requester_id"]
                                });
                              }
                            );

                            // Get.defaultDialog(
                            //   barrierDismissible: false,
                            //   title: "Attention!",
                            //   middleText:
                            //   "$name has requested to ${!timerController.isMeetingRunning.value ? 'start' : 'stop'} the meeting. Do you agree?",
                            //   confirmTextColor: Colors.white,
                            //   textConfirm: "Yes",
                            //   onConfirm: () {
                            //     timerController.isStartAnswered.value = true;
                            //     if (!timerController.isMeetingRunning.value) {
                            //       log("in -2 in yes !timerController.isMeetingRunning else");
                            //       timerController.meetingMode();
                            //       ref2.update({
                            //         // "startAt": FieldValue.serverTimestamp(),
                            //         "seconds": widget.request["duration"],
                            //         "start_requester_id": dataMap["start_requester_id"],
                            //         "pause_requester_id": dataMap["pause_requester_id"]
                            //       });
                            //       Get.back();
                            //     } else {
                            //       log("in -2 !timerController.isMeetingRunning else");
                            //       timerController.lMinutes = timerController.minutes.value;
                            //       timerController.lSeconds = timerController.seconds.value;
                            //       timerController.meetingMode();
                            //       ref2.update({
                            //         // "startAt": FieldValue.serverTimestamp(),
                            //         "seconds": -1,
                            //         "start_requester_id": dataMap["start_requester_id"],
                            //         "pause_requester_id": dataMap["pause_requester_id"]
                            //       });
                            //       Get.back();
                            //     }
                            //   },
                            //   cancelTextColor: Colors.red,
                            //   textCancel: "No",
                            //   onCancel: () {
                            //     timerController.isStartAnswered.value = true;
                            //     ref2.update({
                            //       // "startAt": FieldValue.serverTimestamp(),
                            //       "seconds": 0,
                            //       "start_requester_id": dataMap["start_requester_id"],
                            //       "pause_requester_id": dataMap["pause_requester_id"]
                            //     });
                            //   },
                            // );

                            log("isStartAnswered after the dialog is: ${timerController.isStartAnswered.value}");

                            Future.delayed(const Duration(minutes: 1), () {
                              log("inside delayed !isStartAnswered.value) checking.");
                              // Get.back();
                              log("inside delayed !isStartAnswered.value) checking is: ${timerController.isStartAnswered.value}");

                              if (!timerController.isStartAnswered.value) {
                                log("inside delayed check if");
                                // Get.back();
                                if (timerController.isMeetingRunning.value) {
                                  log("inside delayed check if in is meeting running");
                                  ref2.update({
                                    // "startAt": FieldValue.serverTimestamp(),
                                    "seconds": -1,
                                    "start_requester_id": dataMap["start_requester_id"],
                                    "pause_requester_id": dataMap["pause_requester_id"]
                                  });
                                  if(dataMap["start_requester_id"] != UserController().auth.currentUser?.uid){
                                    log("inside the start requester id check if");
                                    Get.back();
                                  }
                                } else {
                                  ref2.update({
                                    // "startAt": FieldValue.serverTimestamp(),
                                    "seconds": 0,
                                    "start_requester_id": dataMap["start_requester_id"],
                                    "pause_requester_id": dataMap["pause_requester_id"]
                                  });
                                }
                              }
                            });
                          } else {
                            log("in else of is not my id means it is my id");
                          }
                          log("after the if of default dialog");
                        }else{
                          log("in -2 else not the meeting, the widget.request was made for.");
                        }

                        // timer2.cancel();
                        // resetTimer2();
                        // isMeetingRunning2.value = false;
                        // ref2.set({"startAt": FieldValue.serverTimestamp(), "seconds": 0});
                      }
                      else if (timerController.timerSeconds.value == 2) {
                        //+ 2 means a pause request is made, if accepted, we set '1' in the RTDB for informing both timers about pause
                        //+ if rejected means pausing is not an option setting the value back to Requested Time
                        //+ but if not answered in a minute, as reflected from the RxBool isPauseAnswered then set 1 in the RTDB
                        //+ which means that the meeting is paused.

                        var id = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);
                        log("in 2 before if id == widget.request['meetId'] and id: $id and and widget.request['meetId']: ${dataMap['meetId']}");
                        if(id == dataMap['meetId']) {
                          log("current user in 2 id is: ${UserController().auth.currentUser?.uid}");
                          var name = "";
                          if (UserController().auth.currentUser?.uid !=
                              dataMap["pause_requester_id"]) {
                            //+ this means I am the buyer and I should see the dialog regarding start of meeting
                            if (dataMap["pause_requester_id"] == widget.request["seller_id"]) {
                              name = widget.request["seller_name"];
                            } else {
                              name = widget.request["buyer_name"];
                            }
                            DialogUtils.showCustomDialog(
                                context,
                                title: "Attention!",
                                middleText: "$name has requested to ${!timerController.isMeetingPaused.value ? 'pause' : 'continue'} the meeting. Do you agree?",
                                okBtnFunction: () {
                                  timerController.isPauseAnswered.value = true;
                                  if (!timerController.isMeetingPaused.value) {
                                    ref2.update({
                                      // "startAt": FieldValue.serverTimestamp(),
                                      "seconds": 1,
                                      "start_requester_id": dataMap["start_requester_id"],
                                      "pause_requester_id": dataMap["pause_requester_id"]
                                    });
                                    Get.back();
                                  }
                                  else {
                                    ref2.update({
                                      // "startAt": FieldValue.serverTimestamp(),
                                      "seconds": widget.request["duration"],
                                      "start_requester_id": dataMap["start_requester_id"],
                                      "pause_requester_id": dataMap["pause_requester_id"]
                                    });
                                    Get.back();
                                  }
                                },
                                cancelBtnFunction: () {
                                  timerController.isPauseAnswered.value = true;
                                  ref2.update({
                                    // "startAt": FieldValue.serverTimestamp(),
                                    "seconds": 0,
                                    "start_requester_id": dataMap["start_requester_id"],
                                    "pause_requester_id": dataMap["pause_requester_id"]
                                  });
                                }
                            );

                            // Get.defaultDialog(
                            //   barrierDismissible: false,
                            //   title: "Attention!",
                            //   middleText:
                            //   "$name has requested to ${!timerController.isMeetingPaused.value ? 'pause' : 'continue'} the meeting. Do you agree?",
                            //   confirmTextColor: Colors.white,
                            //   textConfirm: "Yes",
                            //   onConfirm: () {
                            //     timerController.isPauseAnswered.value = true;
                            //     if (!timerController.isMeetingPaused.value) {
                            //       ref2.update({
                            //         // "startAt": FieldValue.serverTimestamp(),
                            //         "seconds": 1,
                            //         "start_requester_id": dataMap["start_requester_id"],
                            //         "pause_requester_id": dataMap["pause_requester_id"]
                            //       });
                            //       Get.back();
                            //     }
                            //     else {
                            //       ref2.update({
                            //         // "startAt": FieldValue.serverTimestamp(),
                            //         "seconds": widget.request["duration"],
                            //         "start_requester_id": dataMap["start_requester_id"],
                            //         "pause_requester_id": dataMap["pause_requester_id"]
                            //       });
                            //       Get.back();
                            //     }
                            //   },
                            //   cancelTextColor: Colors.red,
                            //   textCancel: "No",
                            //   onCancel: () {
                            //     timerController.isPauseAnswered.value = true;
                            //     ref2.update({
                            //       // "startAt": FieldValue.serverTimestamp(),
                            //       "seconds": 0,
                            //       "start_requester_id": dataMap["start_requester_id"],
                            //       "pause_requester_id": dataMap["pause_requester_id"]
                            //     });
                            //   },
                            // );
                            Future.delayed(Duration(minutes: 1), () {
                              log("is pause answered delayed checking");
                              // Get.back();
                              if (!timerController.isPauseAnswered.value) {
                                ref2.update({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "seconds": 1,
                                  "start_requester_id": dataMap["start_requester_id"],
                                  "pause_requester_id": dataMap["pause_requester_id"]
                                }).then((value) => log("from !isPauseAnswered.value"));
                              }
                            });
                          }
                        }else{
                          log("in 2 not the meeting the widget.request was made for.");
                        }

                        //!! haven't taken care of the timed thingy yet

                        // timer2.cancel();
                        // resetTimer2();
                        // isMeetingRunning2.value = false;
                        // ref2.set({"startAt": FieldValue.serverTimestamp(), "seconds": 0});
                      }
                      else {
                        //+ if the number is none of the code related things
                        log("inside callback else");
                        log("inside callback if(timerSeconds.value != 0)");
                        // num serverTimeOffset = 0;
                        // FirebaseDatabase.instance
                        //     .ref(".info/serverTimeOffset")
                        //     .onValue
                        //     .listen((event) {
                        //   serverTimeOffset = event.snapshot.value as num? ?? 0.0;
                        //   log("serverTimeOffset : $serverTimeOffset");
                        //   final startAtTime =
                        //       DateTime.now().millisecondsSinceEpoch + serverTimeOffset;
                        //   log("startAtTime : $startAtTime");
                        //   log("startAtTime.toInt() : ${startAtTime.toInt()}");
                        //   log("startAtTime :"
                        //       " ${DateTime.fromMillisecondsSinceEpoch(startAtTime.toInt())}");
                        //   log("startAt : ${DateTime.fromMillisecondsSinceEpoch(startAt.value)}");
                        //   log("startAt : $startAt");
                        //   log("!!!!!!!!!!isBefore or isAfter : "
                        //       "${DateTime.now().compareTo(DateTime.fromMillisecondsSinceEpoch(startAtTime.toInt()))}");
                        //   final difference = DateTime.now().difference(
                        //       DateTime.fromMillisecondsSinceEpoch(startAtTime.toInt()));
                        //   log("difference : $difference");
                        //   log("difference : ${difference.inSeconds}");
                        //   log("difference : ${difference.inMinutes}");
                        //   final timeLeft = (timerSeconds * 1000) -
                        //       (DateTime.now().millisecondsSinceEpoch -
                        //           startAt.value -
                        //           serverTimeOffset);
                        //   log("from stackoverflow timeLeft: $timeLeft");
                        // });
                        log("inside if calling the wnd meeting mode");

                        var id = getChatRoomIdByUsernames(widget.request['seller_id'], widget.request['buyer_id']);
                        log("in last else before if id == widget.request['meetId'] and id: $id and and request['meetId']: ${dataMap['meetId']}");
                        if(id == dataMap['meetId']) {
                          if (!timerController.isMeetingRunning.value) {
                            // isMeetingRunning.value = true;
                            timerController.meetingMode();
                          }
                          if (timerController.isMeetingPaused.value) {
                            // isMeetingPaused.value = false;
                            timerController.pauseMode();
                          }
                        }
                      }
                      return Container( color: Colors.transparent,);
                    } else {
                      return Container( color: Colors.transparent,);
                    }
                  } else {
                    log("in else of hasData done and: ${snapshot.connectionState} and"
                        " snapshot.hasData: ${snapshot.hasData}");
                    return Container( color: Colors.transparent,);
                  }
                } else {
                  log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
                  return Container( color: Colors.transparent,);
                }
              },
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 3.3, horizontal: w * 7.3),
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * 3.2,
                        ),
                        Obx(() {
                          return InkWell(
                            child: Container(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: h * 1.6,
                                    right: w * 2.4,
                                  ),
                                  child: Text(
                                    timerController.isMeetingRunning.value
                                        ? '${timerController.minutes}:${timerController.seconds}'
                                            '\n Long press\nto pause or\nresume &'
                                            '\n Touch to end.'
                                        : 'Touch to\nbegin/end your\nmeeting',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 4.8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              height: h * 45,
                              width: w * 85.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500),
                                image: const DecorationImage(
                                    image: AssetImage('assets/images/data/clock.png'), fit: BoxFit.cover),
                              ),
                            ),
                            onTap: () async {
                              //+start the timer here.
                              log("current user id is: ${UserController().auth.currentUser}");
                              log("current user id is: ${UserController().auth.currentUser?.uid}");
                              timerController.isStartAnswered.value = false;
                              timerController.isPauseAnswered.value = false;
                              //+ the above line is working and fetching the user alright

                              try {
                                // if (!timerController.isMeetingRunning.value
                                // && UserController().auth.currentUser?.uid == widget.request["seller_id"]
                                // ) {
                                log("\n\n started the timerController.timer in then after "
                                    "joining the channel.\n\n");
                                //+ requesting meeting start or stop.
                                ref2.set({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "meetId": directory,
                                  "seconds": -2,
                                  "start_requester_id": UserController().auth.currentUser?.uid,
                                  "pause_requester_id": ""
                                }).then((value) {
                                  ref.set({
                                    "meetId": directory,
                                    "startAt": ServerValue.timestamp,
                                    "seconds": -2,
                                    "start_requester_id": UserController().auth.currentUser?.uid,
                                    "pause_requester_id": ""
                                  });
                                  log("in on Tap passed a start/stop request");
                                  // timerController.meetingMode();
                                });

                                // }
                              } catch (e) {
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         AlertDialog(
                                //           title: Text(
                                //               "Following error was thrown while "
                                //                   "starting the meeting timer: ${e.toString()}"),
                                //           actions: [
                                //             TextButton(
                                //               child: const Text("Ok"),
                                //               onPressed: () async {
                                //                 Navigator.pop(context);
                                //               },
                                //             ),
                                //             // FlatButton(
                                //             //   child:
                                //             //   const Text("No"),
                                //             //   onPressed: () {
                                //             //     Navigator.pop(
                                //             //         context);
                                //             //   },
                                //             // )
                                //           ],
                                //         ));
                                Get.defaultDialog(
                                    title: "Error!",
                                    middleText: "Following error was thrown while "
                                        "starting the meeting timerController.timer: ${e.toString()}");
                              }
                              // } else {
                              //   log("token is null.");
                              // }
                            },
                            onLongPress: () {
                              if (timerController.isMeetingRunning.value) {
                                ref2.set({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "meetId": directory,
                                  "seconds": 2,
                                  "start_requester_id": "",
                                  "pause_requester_id": UserController().auth.currentUser?.uid
                                }).then((value) {
                                  ref.set({
                                    "meetId": directory,
                                    "startAt": ServerValue.timestamp,
                                    "seconds": 2,
                                    "start_requester_id": "",
                                    "pause_requester_id": UserController().auth.currentUser?.uid
                                  });
                                  log("in on long press passing a pause request");
                                });
                              } else {
                                log("onLongPress meeting not running and not not paused ");
                              }
                            },
                          );
                        }),
                        SizedBox(
                          height: h * 0.1,
                        ),
                        // if (timerController.isMeetingRunning.value)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       FloatingActionButton(
                        //         heroTag: "endCallButton",
                        //         onPressed: () async {
                        //           log("before refreshing minutes: ${timerController.minutes}"
                        //               " seconds: ${timerController.seconds}");
                        //           timerController.meetingMode();
                        //           String minutes = timerController.minutes.value;
                        //           String seconds = timerController.seconds.value;
                        //           log("local values are: minutes: $minutes and "
                        //               "seconds: $seconds");
                        //           totalCharge = 0;
                        //           extraMinutes = 0;
                        //           extraSeconds = 0;
                        //           extraTimeCharge = 0;
                        //           if (int.parse(minutes) >
                        //               widget.request["duration"] ||
                        //               (int.parse(minutes) ==
                        //                   widget.request["duration"])) {
                        //             totalCharge = widget.request["duration"] *
                        //                 currentCharge;
                        //             extraMinutes = (int.parse(minutes) -
                        //                 widget.request["duration"])
                        //                 .toInt();
                        //             extraSeconds = int.parse(seconds);
                        //             extraTimeCharge = extraMinutes * extraCharge;
                        //             extraTimeCharge +=
                        //                 extraSeconds * (extraCharge / 60);
                        //             totalCharge += extraTimeCharge;
                        //           } else {
                        //             totalCharge =
                        //                 int.parse(minutes) * currentCharge;
                        //             totalCharge += ((int.parse(seconds) *
                        //                 (currentCharge / 60))
                        //                 .toPrecision(3)).toPrecision(2);
                        //           }
                        //           timerController.resetTimer();
                        //           log("after refreshing minutes: ${timerController.minutes}"
                        //               " seconds: ${timerController.seconds}");
                        //           log("returnVValue of leaveChannel is:");
                        //           log("\n\n\n"
                        //               "You were in the meeting for "
                        //               "$minutes minutes and $seconds seconds. "
                        //               "You are being charged \$$totalCharge for "
                        //               "this meeting."
                        //               "\n\n\n");
                        //           showDialog(
                        //               context: context,
                        //               builder: (BuildContext context) =>
                        //                   AlertDialog(
                        //                     title: Text(
                        //                         "${widget.request["buyer_name"]} "
                        //                             "was in the meeting for "
                        //                             "$minutes minutes and $seconds seconds. "
                        //                             "He is being charged \$$totalCharge for "
                        //                             "this meeting."),
                        //                     actions: [
                        //                       TextButton(
                        //                         child: const Text("Ok"),
                        //                         onPressed: () async {
                        //                           // AchievementView(
                        //                           //   context,
                        //                           //   color: Colors
                        //                           //       .green,
                        //                           //   icon: const Icon(
                        //                           //     FontAwesomeIcons
                        //                           //         .check,
                        //                           //     color: Colors
                        //                           //         .white,
                        //                           //   ),
                        //                           //   title:
                        //                           //   "Succesfull!",
                        //                           //   elevation:
                        //                           //   20,
                        //                           //   subTitle:
                        //                           //   "Request Cancelled succesfully",
                        //                           //   isCircle:
                        //                           //   true,
                        //                           // ).show();
                        //                           Navigator.pop(context);
                        //                         },
                        //                       ),
                        //                       // FlatButton(
                        //                       //   child:
                        //                       //   const Text("No"),
                        //                       //   onPressed: () {
                        //                       //     Navigator.pop(
                        //                       //         context);
                        //                       //   },
                        //                       // )
                        //                     ],
                        //                   ));
                        //         },
                        //         child: const Icon(
                        //           Icons.local_phone_rounded,
                        //           color: Colors.white,
                        //         ),
                        //         backgroundColor: Colors.red,
                        //       ),
                        //     ],
                        //   ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Expanded(
                              child: Text("Touch to Start or End the meeting & "
                                  "Long-Press to Pause or Resume the meeting.",
                                style: TextStyle(
                                  fontSize: w * 3.8,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 1.9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: w * 2.4,
                            ),
                            Text(
                              'You are Meeting: '
                              '${UserController().auth.currentUser?.uid == widget.request["seller_id"] ? widget.request["buyer_name"] : widget.request["seller_name"]}',
                              style: TextStyle(
                                fontSize: w * 4.8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 2.2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              width: w * 0.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: h * 6.7,
                          width: w * 80.4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              children: [
                                Text(
                                  'Requested Time:',
                                  style: TextStyle(
                                    fontSize: w * 4.8,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.request["duration"]} min/\$${widget.request["price"]}',
                                    style: TextStyle(
                                      fontSize: w * 4.8,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 2.2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              width: w * 0.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: h * 6.7,
                          width: w * 80.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 7.3),
                            child: Row(
                              children: [
                                Text(
                                  'Extra Charge:',
                                  style: TextStyle(
                                    fontSize: w * 4.8,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\$${extraCharge.toPrecision(2)}/1 min',
                                    style: TextStyle(
                                      fontSize: w * 4.8,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 2.2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              width: w * 0.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: h * 6.7,
                          width: w * 80.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 7.3),
                            child: Row(
                              children: [
                                Text(
                                  'Current Charge:',
                                  style: TextStyle(
                                    fontSize: w * 4.8,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Obx(() {
                                    return Text(
                                      '\$${getCurrentCharge()}',
                                      style: TextStyle(
                                        fontSize: w * 4.8,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Having a issue?',
                          style: TextStyle(fontSize: w * 4.8, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        SizedBox(
                          height: h * 2.2,
                        ),
                        Row(
                          children: [
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(width: w * 38.0, height: h * 5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CommonProblems()),
                                      );
                                    },
                                    child: Text(
                                      'Common Problems',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: w * 3.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(width: w * 38.0, height: h * 5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Emergency()),
                                      );
                                    },
                                    child: Text(
                                      'Emergency',
                                      style: TextStyle(
                                        fontSize: w * 4.3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCurrentCharge() {
    currentCharge = widget.request["price"] / widget.request["duration"];

    if (int.parse(timerController.minutes.value) > widget.request["duration"] ||
        (int.parse(timerController.minutes.value) == widget.request["duration"])) {
      log("inside minutes less if request['duration']: ${widget.request["duration"]} \n\n "
          " int.parse(minutes): ${int.parse(timerController.minutes.value)}");
      totalCharge = widget.request["duration"] * currentCharge;
      extraMinutes = (int.parse(timerController.minutes.value) - widget.request["duration"]).toInt();
      extraSeconds = int.parse(timerController.seconds.value);
      log("total charge is: $totalCharge");
      extraTimeCharge = extraMinutes * extraCharge;
      extraTimeCharge += extraSeconds * (extraCharge / 60);
      totalCharge += extraTimeCharge;
    } else {
      log("inside else less if");
      totalCharge = int.parse(timerController.minutes.value) * currentCharge;
      totalCharge += ((int.parse(timerController.seconds.value) * (currentCharge / 60)).toPrecision(3)).toPrecision(2);
    }
    return totalCharge.toPrecision(2);
  }
}
