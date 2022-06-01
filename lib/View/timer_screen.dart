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
    if(!timerController.isStreamCalled){
      timerController.startStream(widget.request);
    }else{
      log("\n\n\n\n\n\n\n\n\n\n\nseems like stream called again\n\n\n\n\n\n\n\n");
    }
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
