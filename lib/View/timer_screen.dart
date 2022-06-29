import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:meeter/Controllers/timer_controller.dart';
import 'package:meeter/View/common_problems.dart';
import 'package:meeter/View/emergency.dart';
import '../Constants/controllers.dart';
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
  // late DatabaseReference ref;
  late DocumentReference ref2;
  var directory;
  //bool endDialogAnswer = false;

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
    currentCharge = widget.request["price"] / 30;
    extraCharge = currentCharge;
    timerController.request = widget.request;
    if (!timerController.isStreamCalled) {
      timerController.startStream();
    } else {
      log("\n\n\n\n\n\n\n\n\n\n\nseems like stream called again\n\n\n\n\n\n\n\n");
    }
    directory = getChatRoomIdByUsernames(
        widget.request['seller_id'], widget.request['buyer_id']);

    //ref = FirebaseDatabase.instance.ref().child('$directory/');
    ref2 =
        FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory);
  }

  callEndDialog() {
    Get.defaultDialog(
      title: "Caution!",
      middleText: "Please end the meeting before going out.",
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose  
    TimerController.timer.cancel();
    super.dispose();
  }

  //bool answer = true;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return WillPopScope(
      onWillPop: () async {
        if (timerController.isMeetingRunning.value) {
          callEndDialog();
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: h * 3.3, horizontal: w * 7.3),
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
                                            '\n Touch to pause/resume \n&'
                                            ' Long Press to end.'
                                        : 'Long Press to\nbegin/end your\nmeeting',
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
                                    image: AssetImage(
                                        'assets/images/data/clock.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            onTap: () async {
                              timerController.isPauseAnswered.value = false;
                              //+ onTap is for Pause and Resume
                              if (timerController.isMeetingRunning.value) {
                                ref2.set({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "meetId": directory,
                                  "seconds": 2,
                                  "start_requester_id": "",
                                  "pause_requester_id":
                                      UserController().auth.currentUser?.uid,
                                  "finished_at_minutes": "",
                                  "finished_at_seconds": "",
                                }, SetOptions(merge: true)).then((value) {
                                  // ref.set({
                                  //   "meetId": directory,
                                  //   "startAt": ServerValue.timestamp,
                                  //   "seconds": 2,
                                  //   "start_requester_id": "",
                                  //   "pause_requester_id": UserController().auth.currentUser?.uid,
                                  //   "finished_at_minutes": "",
                                  //   "finished_at_seconds": "",
                                  // });
                                  log("in on long press passing a pause request");
                                });
                              } else {
                                log("onLongPress meeting not running and not not paused ");
                              }
                            },
                            onLongPress: () {
                              timerController.isStartAnswered.value = false;
                              //+ the above line is working and fetching the user alright
                              try {
                                ref2.set({
                                  // "startAt": FieldValue.serverTimestamp(),
                                  "meetId": directory,
                                  "seconds": -2,
                                  "start_requester_id":
                                      UserController().auth.currentUser?.uid,
                                  "pause_requester_id": "",
                                  "finished_at_minutes":
                                      timerController.minutes.value,
                                  "finished_at_seconds":
                                      timerController.seconds.value,
                                }, SetOptions(merge: true)).then((value) {
                                  // ref.set({
                                  //   "meetId": directory,
                                  //   "startAt": ServerValue.timestamp,
                                  //   "seconds": -2,
                                  //   "start_requester_id": UserController().auth.currentUser?.uid,
                                  //   "pause_requester_id": "",
                                  //   "finished_at_minutes": timerController.minutes.value,
                                  //   "finished_at_seconds": timerController.seconds.value,
                                  // });
                                });
                              } catch (e) {
                                Get.defaultDialog(
                                    title: "Error!",
                                    middleText:
                                        "Following error was thrown while "
                                        "starting the meeting timerController.timer: ${e.toString()}");
                              }
                              //+------------------------------------------------
                            },
                          );
                        }),
                        SizedBox(
                          height: h * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Long-Press to Start or End the meeting & "
                                "Touch to Pause or Resume the meeting.",
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
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
                                    '${widget.request["duration"]} min/\$${((widget.request["price"] * widget.request["duration"]) / 30).round()}',
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
                                    '\$${(extraCharge * 5).toPrecision(2)}/5 min',
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
                          style: TextStyle(
                              fontSize: w * 4.8,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
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
                                  constraints: BoxConstraints.tightFor(
                                      width: w * 38.0, height: h * 5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommonProblems()),
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
                                  constraints: BoxConstraints.tightFor(
                                      width: w * 38.0, height: h * 5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Emergency()),
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
    currentCharge = widget.request["price"] / 30;
    if (int.parse(timerController.minutes.value) > widget.request["duration"] ||
        (int.parse(timerController.minutes.value) ==
            widget.request["duration"])) {
      totalCharge = widget.request["duration"] * currentCharge;
      extraMinutes = (int.parse(timerController.minutes.value) -
              widget.request["duration"])
          .toInt();
      extraSeconds = int.parse(timerController.seconds.value);
      extraTimeCharge = extraMinutes * extraCharge;
      extraTimeCharge += extraSeconds * (extraCharge / 60);
      totalCharge += extraTimeCharge;
    } else {
      totalCharge = int.parse(timerController.minutes.value) * currentCharge;
      totalCharge +=
          ((int.parse(timerController.seconds.value) * (currentCharge / 60))
                  .toPrecision(3))
              .toPrecision(2);
    }
    return totalCharge.toPrecision(2);
  }
}
