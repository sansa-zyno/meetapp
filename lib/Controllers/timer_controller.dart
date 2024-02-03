import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeter/View/feedback_screen.dart';
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

  //RxInt timerCount = 0.obs;
  //RxInt startAt = 0.obs;
  RxInt timerSeconds = 0.obs;

  RxBool isMeetingRunning = false.obs;
  RxBool isMeetingPaused = false.obs;
  // RxBool isMeetingStarted = false.obs;
  //bool isDialogShown = false;
  //bool isExtraChargeTimeDialogShown = false;

  RxString minutes = '00'.obs;
  RxString seconds = '00'.obs;

  //String lMinutes = "00";
  //String lSeconds = "00";
  bool dialogShown = false;

  static Duration duration = Duration();
  static Timer? timer;
  Timer? timer1;
  Timer? timer2;
  Timer? timer3;

  RxBool isStartAnswered = false.obs;
  //RxBool isEndAnswered = false.obs;
  RxBool isPauseAnswered = false.obs;
  RxBool isExtraChargeAnswered = false.obs;

  //Map<String, dynamic> requestData = {};
  late DocumentSnapshot request;

  void addTime() {
    final addSeconds = 1;
    final seconds = duration.inSeconds + addSeconds;
    duration = Duration(seconds: seconds);
    buildTime();
  }

  void resetTimer() async {
    duration = Duration();
    minutes.value = '00';
    seconds.value = '00';
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    bool isWakelock = await Wakelock.enabled;
    if (isWakelock) {
      Wakelock.disable();
    }
  }

  void startTimer() {
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    minutes.value = twoDigits(duration.inMinutes);
    seconds.value = twoDigits(duration.inSeconds.remainder(60));
    if (int.parse(minutes.value) == request['duration'] &&
        int.parse(seconds.value) == 0) {
      var directory =
          getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);

      // final ref2 = FirebaseDatabase.instance.ref().child('$directory/');
      final ref2 = FirebaseFirestore.instance
          .collection("InMeetingRecord")
          .doc(directory);
      ref2.update({
        // "startAt": FieldValue.serverTimestamp(),
        "seconds": -3,
      }).then((value) => log("-3 in db now because time is up"));
    }
  }

  void pauseMode() {
    isMeetingPaused.value = !isMeetingPaused.value;
    if (isMeetingPaused.value) {
      //pause
      log("in pause mode function, shouldnt be called");
      timer?.cancel();
      timer?.cancel();
      timer?.cancel();
      timer?.cancel();
      timer?.cancel();
    } else {
      //resume
      startTimer();
    }
  }

  void meetingMode() {
    isMeetingRunning.value = !isMeetingRunning.value;
    if (isMeetingRunning.value) {
      //start
      startTimer();
      Wakelock.enable();
    } else {
      //stop
      log("in meeting mode function, shouldnt be called");
      resetTimer();
    }
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

  startStream() {
    log("startStream called ....................");
    isStreamCalled = true;
    // requestData = request.data() as Map<String, dynamic>;
    var directory =
        getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
    // final ref2 = FirebaseDatabase.instance.ref().child('$directory/');
    final ref2DocSnap = FirebaseFirestore.instance
        .collection("InMeetingRecord")
        .doc(directory)
        .snapshots();
    final ref2 =
        FirebaseFirestore.instance.collection("InMeetingRecord").doc(directory);

    ref2DocSnap.listen((event) async {
      var data = event.data();
      // var jsonString = json.encode(event.snapshot.value);
      // log("jsonString: $jsonString");
      // var jsonData = jsonDecode(jsonString);
      // log("jsonData is: $jsonData");
      Map<String, dynamic>? dataMap = data ?? {};
      // log("jsonData is: $jsonData");
      // log("dataMap is: ${dataMap['lSeconds'].runtimeType}");
      // Timestamp tmp = dataMap['startAt'] ?? Timestamp(0, 0);
      // startAt.value = dataMap != {} ? tmp.millisecondsSinceEpoch : 0;
      timerSeconds.value = dataMap != {} ? dataMap['seconds'] : 0;
      // log("values are: startAt.value: ${startAt.value} and "
      //     " timerSeconds.value: ${timerSeconds.value} and ");
      if (timerSeconds.value == 0) {
        //+ 0 means nothing for the other user -> means the timer won't start
        //+ when page is opened and 0 is in RTDB
        // isMeetingRunning.value = false;
        // if(timer.isActive){
        //   log("inside timer is active");
        //timer.cancel();
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
        log("in -1 block called");
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          isMeetingRunning.value = false;
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();

          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();

          if (request["buyer_id"] == FirebaseAuth.instance.currentUser!.uid) {
            QuerySnapshot snap = await FirebaseFirestore.instance
                .collection("connections")
                .where("meeters", arrayContains: request["seller_id"])
                .get();
            List docs = snap.docs.isNotEmpty
                ? snap.docs.where((element) {
                    List meeters = element["meeters"];
                    return meeters.contains(request["buyer_id"]);
                  }).toList()
                : [];
            if (docs.isNotEmpty) {
              DateTime dt = DateTime.now();
              String dte =
                  "${dt.day.floor() < 10 ? "0" : ""}${dt.day.floor()}-${dt.month.floor() < 10 ? "0" : ""}${dt.month.floor()}-${dt.year}";
              DocumentSnapshot doc = snap.docs[0];
              List items = doc["items"];
              items.add({"item": request["title"], "date": dte});
              FirebaseFirestore.instance
                  .collection("connections")
                  .doc(snap.docs[0].id)
                  .update({
                "ts": dt,
                "recentMeetingDate": dte,
                "items": items,
                "meetingCount": FieldValue.increment(1)
              }).then((value) =>
                      log("connection exist before, so items just added"));
            } else {
              DateTime dt = DateTime.now();
              String dte =
                  "${dt.day.floor() < 10 ? "0" : ""}${dt.day.floor()}-${dt.month.floor() < 10 ? "0" : ""}${dt.month.floor()}-${dt.year}";
              FirebaseFirestore.instance.collection("connections").add({
                "ts": dt,
                "recentMeetingDate": dte,
                "items": [
                  {"item": request["title"], "date": dte}
                ],
                "meetingCount": 1,
                "seller_id": request["seller_id"],
                "seller_name": request["seller_name"],
                "seller_image": request["seller_image"],
                "buyer_id": request["buyer_id"],
                "buyer_name": request["buyer_name"],
                "buyer_image": request["buyer_image"],
                "meeters": ["${request["seller_id"]}", "${request["buyer_id"]}"]
              }).then((value) => log("new connection created"));
            }
          }
          // meetingMode(); //+ I added this 23-4
          totalCharge = 0;
          extraMinutes = 0;
          extraSeconds = 0;
          extraTimeCharge = 0;
          currentCharge = request["price"] / 30;
          extraCharge = currentCharge;
          ;
          if (int.parse(dataMap['finished_at_minutes']) > request["duration"] ||
              (int.parse(dataMap['finished_at_minutes']) ==
                  request["duration"])) {
            totalCharge = request["duration"] * currentCharge;
            extraMinutes = (int.parse(dataMap['finished_at_minutes']) -
                    request["duration"])
                .toInt();
            extraSeconds = int.parse(dataMap['finished_at_seconds']);
            extraTimeCharge = extraMinutes * extraCharge;
            extraTimeCharge += extraSeconds * (extraCharge / 60);
            totalCharge += extraTimeCharge;
          } else {
            totalCharge =
                int.parse(dataMap['finished_at_minutes']) * currentCharge;
            totalCharge += ((int.parse(dataMap['finished_at_seconds']) *
                        (currentCharge / 60))
                    .toPrecision(3))
                .toPrecision(2);
          }
          String name = "";
          String pronoun = "";
          if (UserController().auth.currentUser?.uid == request["seller_id"]) {
            name = request["buyer_name"];
            pronoun = "He";
          } else {
            name = "You";
            pronoun = "You";
          }

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

                Get.back();
                if (FirebaseAuth.instance.currentUser!.uid ==
                    request["seller_id"]) {
                  Get.off(
                    () => FeedbackScreen(request["buyer_id"],
                        request["buyer_name"], request["buyer_image"]),
                    transition: Transition.rightToLeft,
                  );
                } else {
                  Get.off(
                    () => FeedbackScreen(request["seller_id"],
                        request["seller_name"], request["seller_image"]),
                    transition: Transition.rightToLeft,
                  );
                }

                await Future.delayed(Duration(seconds: 5), () {
                  FirebaseFirestore.instance
                      .collection("requests")
                      .doc(request["seller_id"])
                      .collection("request")
                      .doc(request.id)
                      .delete()
                      .then((value) => log("request deleted"));
                });

                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
              }).then((value) => log("in -1 update 0 to db"));

          if (timer != null) {
            if (timer!.isActive) {
              timer!.cancel();
            }
          }
          resetTimer();

          log("in -1 block ending");
        } else {
          log("in stop else meaning this is some other meeting page and the stop was called for some other one");
        }
      } else if (timerSeconds.value == 1) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          isMeetingPaused.value = true;
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();

          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();
          ref2.update({
            // "startAt": FieldValue.serverTimestamp(),
            "seconds": 0,
            "start_requester_id": dataMap["start_requester_id"],
            "pause_requester_id": dataMap["pause_requester_id"]
          }).then((value) => log("in 1 meeting paused then 0 updated to db"));
        } else {
          log("in paused else meaning this is some other meeting page and the pause was called for some other one");
        }
      } else if (timerSeconds.value == -2) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();
          //lMinutes = minutes.value;
          //lSeconds = seconds.value;
          if (UserController().auth.currentUser?.uid !=
              dataMap["start_requester_id"]) {
            var name = "";
            if (dataMap["start_requester_id"] == request["seller_id"]) {
              name = request["seller_name"];
            } else {
              name = request["buyer_name"];
            }

            if (!dialogShown) {
              dialogShown = true;
              Get.defaultDialog(
                barrierDismissible: false,
                title: "Attention!",
                middleText:
                    "$name has requested to ${!isMeetingRunning.value ? 'start' : 'stop'} the meeting. Do you agree?",
                confirmTextColor: Colors.white,
                textConfirm: "Yes",
                onConfirm: () async {
                  isStartAnswered.value = true;
                  if (!isMeetingRunning.value) {
                    //meetingMode();
                    ref2.update({
                      // "startAt": FieldValue.serverTimestamp(),
                      "seconds": request["duration"],
                      "start_requester_id": dataMap["start_requester_id"],
                      "pause_requester_id": dataMap["pause_requester_id"]
                    }).then((value) => log(
                        "in -2 duration updated to db for meeting to start"));
                    Get.back();
                    dialogShown = false;
                  } else {
                    //lMinutes = minutes.value;
                    //lSeconds = seconds.value;
                    //meetingMode();
                    ref2.update({
                      // "startAt": FieldValue.serverTimestamp(),
                      "seconds": -1,
                      "start_requester_id": dataMap["start_requester_id"],
                      "pause_requester_id": dataMap["pause_requester_id"]
                    }).then((value) =>
                        log("in -2, -1 updated to db for meeting to stop"));
                    Get.back();
                    dialogShown = false;
                  }
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
                  }).then((value) =>
                      log("in -2, No selected means update 0 to db"));
                  dialogShown = false;
                },
              );
            }
            //if isStarted ==false
            timer1 = Timer(Duration(minutes: 1), () {
              if (!isStartAnswered.value) {
                //within 1 minute duration time isAnswered could have changed
                // Get.back();
                if (isMeetingRunning.value) {
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": -1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  }).then((value) => log(
                      "in -2 timer because answered = false, update -1 to db "));
                  if (dataMap["start_requester_id"] !=
                      UserController().auth.currentUser?.uid) {
                    Get.back();
                    dialogShown = false;
                  }
                } else {
                  ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": 0,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  }).then((value) => log(
                      "in -2 timer because answered = false but meeting not running, update 0 to db"));
                }
              } else {
                log("timer1 cancelled");
                timer1?.cancel();
                timer1 = null;
              }
            });
            isStartAnswered.value = false;
          } else {
            log("in else of is not my id means it is my id");
          }
        } else {
          log("in -2 else not the meeting, the request was made for.");
        }
      } else if (timerSeconds.value == 2) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();
          var name = "";
          if (UserController().auth.currentUser?.uid !=
              dataMap["pause_requester_id"]) {
            //+ this means I am the buyer and I should see the dialog regarding start of meeting
            if (dataMap["pause_requester_id"] == request["seller_id"]) {
              name = request["seller_name"];
            } else {
              name = request["buyer_name"];
            }
            if (!dialogShown) {
              dialogShown = true;
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
                    }).then((value) =>
                        log("in 2, 1 updated to db for meeting to pause"));
                    Get.back();
                    dialogShown = false;
                  } else {
                    ref2.update({
                      // "startAt": FieldValue.serverTimestamp(),
                      "seconds": request["duration"],
                      "start_requester_id": dataMap["start_requester_id"],
                      "pause_requester_id": dataMap["pause_requester_id"]
                    }).then((value) => log(
                        "in 2, duration updated to db for meeting to resume"));
                    Get.back();
                    dialogShown = false;
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
                  }).then(
                      (value) => log("in 2, No selected means update 0 to db"));
                  dialogShown = false;
                },
              );
            }
            timer2 = Timer(Duration(minutes: 1), () {
              if (!isPauseAnswered.value) {
                log("Automatic pause called");
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 1,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                }).then((value) =>
                    log("in 2 timer because answer = false, update 1 to db"));
                Get.back();
                dialogShown = false;
              } else {
                log("timer 2 cancelled");
                timer2?.cancel();
                timer2 = null;
              }
            });

            isPauseAnswered.value = false;
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
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();
          if (UserController().auth.currentUser?.uid == request["buyer_id"]) {
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
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 10,
                }).then((value) =>
                    log("in -3 update 10 to db for meeting to continue."));
                Get.back();
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
                }).then(
                    (value) => log("in -3 No selected means update -1 to db "));
              },
            );
            timer3 = Timer(Duration(minutes: 1), () {
              // Get.back();
              if (!isExtraChargeAnswered.value) {
                log("Automatic stop in extraCharge displayed called");
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": -1,
                  "finished_at_minutes": minutes.value,
                  "finished_at_seconds": seconds.value,
                }).then((value) =>
                    log("in -3 timer because answer = false, update -1 to db"));
              } else {
                log("Timer 3 cancelled");
                timer3?.cancel();
                timer3 = null;
              }
            });
            isExtraChargeAnswered.value = false;
          }
        }
      } else {
        //+ if the number is none of the code related things
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();
          timer?.cancel();

          timer1?.cancel();
          timer2?.cancel();
          timer3?.cancel();

          if (!isMeetingRunning.value) {
            // isMeetingRunning.value = true;
            meetingMode();
            log("meeting called");
          }
          if (isMeetingPaused.value) {
            // isMeetingPaused.value = false;
            pauseMode();
            log("resumed called");
          }
        }
      }
    });
  }
}
