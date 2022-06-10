import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeter/Widgets/HWidgets/nav_main_seller.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wakelock/wakelock.dart';

import '../Providers/user_controller.dart';

class TimerController extends GetxController {
  static TimerController instance = Get.find();

  bool isStreamCalled = false;
  double currentCharge = 0.0;
  double extraCharge = 0.0;
  double extraTimeCharge = 0.0;
  int extraMinutes = 0;
  int extraSeconds = 0;
  double totalCharge = 0.0;

  RxInt timerCount = 0.obs;
  RxInt startAt = 0.obs;
  RxInt timerSeconds = 0.obs;

  RxBool isMeetingRunning = false.obs;
  RxBool isMeetingPaused = false.obs;
  RxBool isMeetingStarted = false.obs;
  bool isDialogShown = false;

  RxString minutes = '00'.obs;
  RxString seconds = '00'.obs;

  String lMinutes = "00";
  String lSeconds = "00";

  Duration duration = Duration();
  late Timer timer;

  RxBool isStartAnswered = false.obs;
  RxBool isEndAnswered = false.obs;
  RxBool isPauseAnswered = false.obs;
  RxBool isExtraChargeAnswered = false.obs;

  Map<String, dynamic> requestData = {};

  void addTime() {
    final addSeconds = 1;
    final seconds = duration.inSeconds + addSeconds;
    duration = Duration(seconds: seconds);
    buildTime();
  }

  void resetTimer() {
    duration = Duration();
    minutes.value = '00';
    seconds.value = '00';
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    minutes.value = twoDigits(duration.inMinutes);
    seconds.value = twoDigits(duration.inSeconds.remainder(60));
    log('time is: ${minutes.value}:${seconds.value}');
    log("before request data empty if  requestData: $requestData");
    if (requestData != {}) {
      if (int.parse(minutes.value) == int.parse(requestData['duration'])) {
        var directory = getChatRoomIdByUsernames(requestData['seller_id'], requestData['buyer_id']);
        log("request: ${requestData}");

        // final ref2 = FirebaseDatabase.instance.ref().child('$directory/');
        final ref2 = FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory);
        ref2.update({
          // "startAt": FieldValue.serverTimestamp(),
          "seconds": -3,
        });
      }
    }
  }

  void pauseMode() {
    isMeetingPaused.value = !isMeetingPaused.value;
    if (!isMeetingPaused.value) {
      log("inside if(isMeetingPaused.value)");
      startTimer();
    } else {
      log("the time is:: ${minutes.value}:${seconds.value}");
      timer.cancel();
    }
  }

  void meetingMode() async {
    isMeetingRunning.value = !isMeetingRunning.value;
    if (isMeetingRunning.value) {
      log("inside if(isMeetingRunning.value)");
      startTimer();
      Wakelock.enable();
      /**/
      // buildTime();
    } else {
      log("the time is:: ${minutes.value}:${seconds.value}");
      log("in meeting mode else resetting time is::");
      timer.cancel();
      resetTimer();
      Wakelock.disable();
    }
    // update();
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  /*
  Hi, thanks for the suggestions.

  For the functions, we would like to have:
  • Mutual confirmation to start and end the meeting
  • For pauses, both parties should be able to request for it during
    the meeting and once the request is made, the other party needs to accept it.

  • If the other party does not accept; timer keeps running

  • If the other party (the one who didn’t make the request) does not select an
    option within 1 minute (e.g due to connectivity issue or what) then the timer would be paused

  • If the other party accepts the pause request then the timer would be paused
  * */

  //+ TODO: Codes for the timer part:::
  //+ 0 means nothing for the other user -> means the timer won't start when page is opened and 0 is in RTDB

  //+ 1 means the timer is to be paused for the other user.

  //+ -1 means the meeting is ended and  timer is reset and the value in RTDB is changed to 0.

  //+ -2 means a start or end request (based on the isMeetingRunning value) is made and if accepted the meeting
  //+ starts setting value in RTDB as Requested Time,
  //+ if rejected the meeting doesn't start putting '0' in RTDB.
  //+ but if there is no answer which would be reflected from RxBool isStartAnswered means meeting can't start
  //+ setting or putting '0' in RTDB

  //+ 2 means a pause request is made, if accepted, we set '1' in the RTDB for informing both timers about pause
  //+ if rejected means pausing is not an option setting the value back to Requested Time
  //+ but if not answered in a minute, as reflected from the RxBool isPauseAnswered then set 1 in the RTDB
  //+ which means that the meeting is paused.

  //+ -3 means the time has ended and a dialog needs to be shown to ask whether to move forward or not
  //+ we will use the same logic for continuing but how?

  //+ Codes for the timer part

  /**/
  // makeADialogue(){
  //   Get.defaultDialog(title: "Title",
  //   middleText: "Check dialog");
  // }

  // getChatRoomIdByUsernames(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }
  startStream(DocumentSnapshot request) {
    log("startStream called ....................");
    isStreamCalled = true;
    requestData = request.data() as Map<String, dynamic>;
    var directory = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
    log("request: ${request.data()}");

    // final ref2 = FirebaseDatabase.instance.ref().child('$directory/');
    final ref2DocSnap = FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory).snapshots();
    final ref2 = FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory);

    ref2DocSnap.listen((event) async {
      var data = event.data();
      log("data is: $data");
      // var jsonString = json.encode(event.snapshot.value);
      // log("jsonString: $jsonString");
      // var jsonData = jsonDecode(jsonString);
      // log("jsonData is: $jsonData");
      Map<String, dynamic>? dataMap = data ?? {};
      // log("jsonData is: $jsonData");
      // log("dataMap is: ${dataMap['lSeconds'].runtimeType}");
      log("dataMap is: ${dataMap['seconds']}");
      log("data is: $data");
      // Timestamp tmp = dataMap['startAt'] ?? Timestamp(0, 0);
      // startAt.value = dataMap != {} ? tmp.millisecondsSinceEpoch : 0;
      timerSeconds.value = dataMap != {} ? dataMap['seconds'] : 0;
      // log("values are: startAt.value: ${startAt.value} and "
      //     " timerSeconds.value: ${timerSeconds.value} and ");
      if (timerSeconds.value == 0) {
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
        // if(isMeetingRunning.value){
        //   if(dataMap['pause_requester_id'] == UserController().auth.currentUser?.uid){
        //     startTimer();
        //   }
        // }
      } else if (timerSeconds.value == -1) {
        //+ -1 means the meeting is ended and  timer is reset and the value
        //+ in RTDB is changed to 0.
        log("is meeting end called ");
        log("request: ${request.data()}");

        var id = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        log("in -1 before if id == request['meetId'] and id: $id and and request['meetId']: ${dataMap['meetId']}");

        if (id == dataMap['meetId']) {
          isMeetingRunning.value = false;
          log("cancel timer called.");
          timer.cancel();
          log("cancel timer called.");
          // meetingMode(); //+ I added this 23-4
          log("local values are: lMinutes: $lMinutes and "
              "dataMap['finished_at_minutes'] is: ${dataMap['finished_at_minutes']}"
              "lSeconds: $lSeconds and dataMap['finished_at_seconds'] is: ${dataMap['finished_at_seconds']}");
          totalCharge = 0;
          extraMinutes = 0;
          extraSeconds = 0;
          extraTimeCharge = 0;
          currentCharge = request["price"] / request["duration"];

          if (int.parse(dataMap['finished_at_minutes']) > request["duration"] ||
              (int.parse(dataMap['finished_at_minutes']) == request["duration"])) {
            log("inside dataMap['finished_at_minutes'] less if request['duration']: ${request["duration"]} \n\n "
                " int.parse(dataMap['finished_at_minutes']): ${int.parse(dataMap['finished_at_minutes'])}");
            totalCharge = request["duration"] * currentCharge;
            extraMinutes = (int.parse(dataMap['finished_at_minutes']) - request["duration"]).toInt();
            extraSeconds = int.parse(dataMap['finished_at_seconds']);
            log("total charge is: $totalCharge");
            extraTimeCharge = extraMinutes * extraCharge;
            extraTimeCharge += extraSeconds * (extraCharge / 60);
            totalCharge += extraTimeCharge;
          } else {
            log("inside else less if");
            totalCharge = int.parse(dataMap['finished_at_minutes']) * currentCharge;
            totalCharge +=
                ((int.parse(dataMap['finished_at_seconds']) * (currentCharge / 60)).toPrecision(3)).toPrecision(2);
          }
          // resetTimer();
          log("after refreshing minutes: $minutes and "
              "dataMap['finished_at_minutes'] is: ${dataMap['finished_at_minutes']}"
              " Seconds: $seconds dataMap['finished_at_seconds'] is: ${dataMap['finished_at_seconds']}");
          log("returnVValue of leaveChannel is:");
          log("\n\n\n"
              "You were in the meeting for "
              "$lMinutes minutes and dataMap['finished_at_minutes']: ${dataMap['finished_at_minutes']} "
              "and $seconds lSeconds. and dataMap['finished_at_seconds'] is: ${dataMap['finished_at_seconds']}"
              "You are being charged \$$totalCharge for "
              "this meeting."
              "\n\n\n");
          String name = "";
          String pronoun = "";
          if (UserController().auth.currentUser?.uid == request["seller_id"]) {
            name = request["buyer_name"];
            pronoun = "He";
          } else {
            name = "You";
            pronoun = "You";
          }

          if (!isDialogShown) {
            log("inside showing dialog");
            Get.defaultDialog(
                barrierDismissible: false,
                title: "Attention!",
                middleText: "$name "
                    "${name == "You" ? "were" : "was"} in the meeting for "
                    "${dataMap['finished_at_minutes']} minutes and ${dataMap['finished_at_seconds']} seconds. "
                    "$pronoun ${pronoun == "You" ? "are" : "is"} being charged "
                    "\$${totalCharge.toPrecision(2)} for "
                    "this meeting.",
                confirmTextColor: Colors.white,
                textConfirm: "Ok",
                onConfirm: () async {
                  //+HANDLE THIS HERE PLEASE IN WHATEVER WAY YOU WANT. yOU MIGHT ALSO WANT tO
                  //+DELETE THIS MEETING FRoM THE RECENT ONES OR THE REQUESTS AFTER THIS MEETING
                  //+ IS ENDED hERE
                  DateTime date = DateTime.now();
                  await FirebaseFirestore.instance.collection("connections").add({
                    "title": request["title"],
                    "seller_id": request["seller_id"],
                    "seller_name": request["seller_name"],
                    "seller_image": request["seller_image"],
                    "buyer_id": request["buyer_id"],
                    "buyer_name": request["buyer_name"],
                    "buyer_image": request["buyer_image"],
                    "date":
                        "${date.year}-${date.month.floor() < 10 ? "0" : ""}${date.month.floor()}-${date.day.floor() < 10 ? "0" : ""}${date.day.floor()}",
                    "meeters": ["${request["seller_id"]}", "${request["buyer_id"]}"]
                  });
                  isDialogShown = true;
                  Get.back();
                  // Get.back();
                  // Get.back();
                  Get.offAll(() => BottomNavBar(),transition: Transition.rightToLeft,);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     PageTransition(
                  //       type: PageTransitionType.rightToLeft,
                  //       duration: Duration(milliseconds: 200),
                  //       curve: Curves.easeIn,
                  //       child: BottomNavBar(),
                  //     ),
                  //         (route) => false);
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": 0,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                });
          }
          if (timer.isActive) {
            timer.cancel();
          }
          resetTimer();
          bool isWakelock = await Wakelock.enabled;
          if (isWakelock) {
            Wakelock.disable();
          }
        } else {
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
      } else if (timerSeconds.value == 1) {
        //+means it is paused
        //+ 1 means the timer is to be paused for the both the users.
        /**/
        // timer.cancel();
        // resetTimer2();
        // isMeetingPaused2.value = true;
        // if (!isMeetingPaused.value) {
        // isMeetingPaused.value = true;

        var id = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        log("in 1 before if id == request['meetId'] and id: $id and and request['meetId']: ${dataMap['meetId']}");

        if (id == dataMap['meetId']) {
          log("inside if id == request['meetId']");
          pauseMode();
          ref2.update({
            // "startAt": FieldValue.serverTimestamp(),
            "seconds": 0,
            "start_requester_id": dataMap["start_requester_id"],
            "pause_requester_id": dataMap["pause_requester_id"]
          });
        } else {
          log("in paused else meaning this is some other meeting page and the pause was called for some other one");
        }
        // }
      } else if (timerSeconds.value == -2) {
        //+ -2 means a start or end request (based on the isMeetingRunning value) is made and if accepted the meeting
        //+ starts setting value in RTDB as Requested Time,
        //+ if rejected the meeting doesn't start putting '0' in RTDB.
        //+ but if there is no answer which would be reflected from RxBool isStartAnswered means meeting can't start
        //+ setting or putting '0' in RTDB

        //+ let's also add a requested by ID in the data in RTDB
        // if(timer.isActive){
        //   timer.cancel();
        // }
        var id = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          isDialogShown = false;
          lMinutes = minutes.value;
          lSeconds = seconds.value;
          log("current user id in -2 is: ${UserController().auth.currentUser?.uid} "
              "and other id is: ");
          if (UserController().auth.currentUser?.uid != dataMap["start_requester_id"]) {
            //+ this means I am the buyer and I should see the dialog regarding start of meeting
            var name = "";
            if (dataMap["start_requester_id"] == request["seller_id"]) {
              name = request["seller_name"];
              log("inside the name if: $name");
            } else {
              name = request["buyer_name"];
              log("inside the name else: $name");
            }
            log("right before the default dialog the name if: $name");

            Get.defaultDialog(
              barrierDismissible: false,
              title: "Attention!",
              middleText:
                  "$name has requested to ${!isMeetingRunning.value ? 'start' : 'stop'} the meeting. Do you agree?",
              confirmTextColor: Colors.white,
              textConfirm: "Yes",
              onConfirm: () {
                isStartAnswered.value = true;
                if (!isMeetingRunning.value) {
                  log("in -2 in yes !isMeetingRunning else");
                  meetingMode();
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": request["duration"],
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                } else {
                  log("in -2 !isMeetingRunning else");
                  lMinutes = minutes.value;
                  lSeconds = seconds.value;
                  meetingMode();
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": -1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                }
                // startTimer();
              },
              cancelTextColor: Colors.red,
              textCancel: "No",
              onCancel: () {
                isStartAnswered.value = true;
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
                // if(isMeetingRunning.value){
                //   startTimer();
                // }
              },
            );

            log("isStartAnswered after the dialog is: ${isStartAnswered.value}");

            Future.delayed(const Duration(minutes: 1), () {
              log("inside delayed !isStartAnswered.value) checking.");
              // Get.back();
              log("inside delayed !isStartAnswered.value) checking is: ${isStartAnswered.value}");

              if (!isStartAnswered.value) {
                log("inside delayed check if");
                // Get.back();
                if (isMeetingRunning.value) {
                  log("inside delayed check if in is meeting running");
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": -1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  if (dataMap["start_requester_id"] != UserController().auth.currentUser?.uid) {
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
        } else {
          log("in -2 else not the meeting, the request was made for.");
        }

        // timer2.cancel();
        // resetTimer2();
        // isMeetingRunning2.value = false;
        // ref2.set({"startAt": FieldValue.serverTimestamp(), "seconds": 0});
      } else if (timerSeconds.value == 2) {
        //+ 2 means a pause request is made, if accepted, we set '1' in the RTDB for informing both timers about pause
        //+ if rejected means pausing is not an option setting the value back to Requested Time
        //+ but if not answered in a minute, as reflected from the RxBool isPauseAnswered then set 1 in the RTDB
        //+ which means that the meeting is paused.

        var id = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        log("in 2 before if id == request['meetId'] and id: $id and and request['meetId']: ${dataMap['meetId']}");
        if (id == dataMap['meetId']) {
          log("current user in 2 id is: ${UserController().auth.currentUser?.uid}");
          var name = "";
          if (UserController().auth.currentUser?.uid != dataMap["pause_requester_id"]) {
            //+ this means I am the buyer and I should see the dialog regarding start of meeting
            if (dataMap["pause_requester_id"] == request["seller_id"]) {
              name = request["seller_name"];
            } else {
              name = request["buyer_name"];
            }
            Get.defaultDialog(
              barrierDismissible: false,
              title: "Attention!",
              middleText:
                  "$name has requested to ${!isMeetingPaused.value ? 'pause' : 'continue'} the meeting. Do you agree?",
              confirmTextColor: Colors.white,
              textConfirm: "Yes",
              onConfirm: () {
                isPauseAnswered.value = true;
                if (!isMeetingPaused.value) {
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": 1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                } else {
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": request["duration"],
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                }
              },
              cancelTextColor: Colors.red,
              textCancel: "No",
              onCancel: () {
                isPauseAnswered.value = true;
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
              },
            );
            Future.delayed(Duration(minutes: 1), () {
              log("is pause answered delayed checking");
              // Get.back();
              if (!isPauseAnswered.value) {
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 1,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                }).then((value) => log("from !isPauseAnswered.value"));
              }
            });
          }
        } else {
          log("in 2 not the meeting the request was made for.");
        }
        //!! haven't taken care of the timed thingy yet
        // timer2.cancel();
        // resetTimer2();
        // isMeetingRunning2.value = false;
        // ref2.set({"startAt": FieldValue.serverTimestamp(), "seconds": 0});
      } else if (timerSeconds.value == -3) {
        // timer.cancel();
        if (UserController().auth.currentUser?.uid != dataMap["start_requester_id"]) {
          Get.defaultDialog(
            barrierDismissible: false,
            title: "Attention!",
            middleText:
                "The meeting time has reached the requested time limit. If you continue, you would be charged based on "
                "the extra charge rate for this extra time. Do you wish to continue?",
            confirmTextColor: Colors.white,
            textConfirm: "Yes",
            onConfirm: () {
              isExtraChargeAnswered.value = true;
              // if (!isMeetingPaused.value) {
              ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": 40,
              });
              Get.back();
              // } else {
              //   ref2.update({
              //     // "startAt": FieldValue.serverTimestamp(),
              //     "seconds": request["duration"],
              //     "start_requester_id": dataMap["start_requester_id"],
              //     "pause_requester_id": dataMap["pause_requester_id"]
              //   });
              // Get.back();
              // }
            },
            cancelTextColor: Colors.red,
            textCancel: "No",
            onCancel: () {
              isExtraChargeAnswered.value = true;
              ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": -1,
                "finished_at_minutes": minutes.value,
                "finished_at_seconds": seconds.value,
                "start_requester_id": dataMap["start_requester_id"],
                "pause_requester_id": dataMap["pause_requester_id"]
              });
            },
          );

          Future.delayed(Duration(minutes: 1), () {
            log("is pause answered delayed checking");
            // Get.back();
            if (!isExtraChargeAnswered.value) {
              ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": -1,
                "finished_at_minutes": minutes.value,
                "finished_at_seconds": seconds.value,
              }).then((value) => log("from !isPauseAnswered.value"));
            }
          });
        }
      } else {
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

        var id = getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        log("in last else before if id == request['meetId'] and id: $id and and request['meetId']: ${dataMap['meetId']}");
        if (id == dataMap['meetId']) {
          if (!isMeetingRunning.value) {
            // isMeetingRunning.value = true;
            meetingMode();
          }
          if (isMeetingPaused.value) {
            // isMeetingPaused.value = false;
            pauseMode();
          }
        }
      }
    });
  }
}
