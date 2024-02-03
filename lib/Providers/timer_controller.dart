/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/feedback_screen.dart';
import 'dart:async';
import 'package:wakelock/wakelock.dart';
import 'dart:developer';

class TimerController with ChangeNotifier {
  bool isStreamCalled = false;
  double currentCharge = 0.0;
  double extraCharge = 0.0;
  double extraTimeCharge = 0.0;
  int extraMinutes = 0;
  int extraSeconds = 0;
  double totalCharge = 0.0;

  bool isMeetingRunning = false;
  bool isMeetingPaused = false;

  String minutes = '00';
  String seconds = '00';

  static Duration duration = Duration();
  static Timer? timer;

  bool isStartAnswered = false;
  bool isPauseAnswered = false;
  bool isExtraChargeAnswered = false;

  int timerSeconds = 0;
  late DocumentSnapshot request;

  void addTime() {
    final addSeconds = 1;
    final seconds = duration.inSeconds + addSeconds;
    duration = Duration(seconds: seconds);
    buildTime();
  }

  void resetTimer() {
    duration = Duration();
    minutes = '00';
    seconds = '00';
    timer = null;
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  buildTime() async{
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    minutes = twoDigits(duration.inMinutes);
    seconds = twoDigits(duration.inSeconds.remainder(60));
    notifyListeners();
    if (int.parse(minutes) == request['duration'] && int.parse(seconds) == 0) {
      var directory =
          getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
      final ref2 = FirebaseFirestore.instance
          .collection("InMeetingRecord")
          .doc(directory);
     await ref2.update({
        "seconds": -3,
      });
    }
    getCurrentCharge();
  }

  getCurrentCharge() {
    currentCharge = request["price"] / 30;
    if (int.parse(minutes) > request["duration"] ||
        (int.parse(minutes) == request["duration"])) {
      totalCharge = request["duration"] * currentCharge;
      extraMinutes = (int.parse(minutes) - request["duration"]).toInt();
      extraSeconds = int.parse(seconds);
      extraTimeCharge = extraMinutes * extraCharge;
      extraTimeCharge += extraSeconds * (extraCharge / 60);
      totalCharge += extraTimeCharge;
      notifyListeners();
    } else {
      totalCharge = int.parse(minutes) * currentCharge;
      totalCharge +=
          ((int.parse(seconds) * (currentCharge / 60)).toPrecision(3))
              .toPrecision(2);
      notifyListeners();
    }
    //return totalCharge.toPrecision(2);
  }

  void pauseMode() {
    isMeetingPaused = !isMeetingPaused;
    notifyListeners();
    if (!isMeetingPaused) {
      //resume
      startTimer();
    } else {
      //pause
      timer?.cancel();
    }
  }

  void meetingMode() async {
    isMeetingRunning = !isMeetingRunning;
    notifyListeners();
    if (isMeetingRunning) {
      //start
      startTimer();
      Wakelock.enable();
    } else {
      //stop
      timer?.cancel();
      resetTimer();
      Wakelock.disable();
    }
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

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
      log("listening .......");
      var data = event.data();
      Map<String, dynamic>? dataMap = data ?? {};
      timerSeconds = dataMap != {} ? dataMap['seconds'] : 0;
      if (timerSeconds == 0) {
      } else if (timerSeconds == -1) {
        print("-1 called");
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          isMeetingRunning = false;
          timer?.cancel();
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
                print("goooooooooooooooo");
                if (docs.isNotEmpty) {
                  print("g777777777777");
                  DateTime dt = DateTime.now();
                  String dte =
                      "${dt.day.floor() < 10 ? "0" : ""}${dt.day.floor()}-${dt.month.floor() < 10 ? "0" : ""}${dt.month.floor()}-${dt.year}";
                  DocumentSnapshot doc = snap.docs[0];
                  List items = doc["items"];
                  items.add({"item": request["title"], "date": dte});
                  await FirebaseFirestore.instance
                      .collection("connections")
                      .doc(snap.docs[0].id)
                      .update({
                    "ts": dt,
                    "recentMeetingDate": dte,
                    "items": items,
                    "meetingCount": FieldValue.increment(1)
                  });
                } else {
                  print("wooooooooooooooooooo");
                  DateTime dt = DateTime.now();
                  String dte =
                      "${dt.day.floor() < 10 ? "0" : ""}${dt.day.floor()}-${dt.month.floor() < 10 ? "0" : ""}${dt.month.floor()}-${dt.year}";
                  await FirebaseFirestore.instance
                      .collection("connections")
                      .add({
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
                    "meeters": [
                      "${request["seller_id"]}",
                      "${request["buyer_id"]}"
                    ]
                  });
                }
                Get.back();
                // Get.back();
                // Get.back();
                if (FirebaseAuth.instance.currentUser!.uid ==
                    request["seller_id"]) {
                  Get.offAll(
                    () => FeedbackScreen(request["buyer_id"],
                        request["buyer_name"], request["buyer_image"]),
                    transition: Transition.rightToLeft,
                  );
                } else {
                  Get.offAll(
                    () => FeedbackScreen(request["seller_id"],
                        request["seller_name"], request["seller_image"]),
                    transition: Transition.rightToLeft,
                  );
                }

                log("deleting the item with ${request["seller_id"]} and request.id: ${request.id}");
                await FirebaseFirestore.instance
                    .collection("requests")
                    .doc(request["seller_id"])
                    .collection("request")
                    .doc(request.id)
                    .delete();

               await ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
              });

          if (timer != null) {
            if (timer!.isActive) {
              timer!.cancel();
            }
          }

          resetTimer();
          bool isWakelock = await Wakelock.enabled;
          if (isWakelock) {
            Wakelock.disable();
          }

          log("Called till this point");
        } else {
          log("in stop else meaning this is some other meeting page and the stop was called for some other one");
        }
      } else if (timerSeconds == 1) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          pauseMode();
         await ref2.update({
            // "startAt": FieldValue.serverTimestamp(),
            "seconds": 0,
            "start_requester_id": dataMap["start_requester_id"],
            "pause_requester_id": dataMap["pause_requester_id"]
          });
        } else {
          log("in paused else meaning this is some other meeting page and the pause was called for some other one");
        }
      } else if (timerSeconds == -2) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
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

            Get.defaultDialog(
              barrierDismissible: false,
              title: "Attention!",
              middleText:
                  "$name has requested to ${!isMeetingRunning ? 'start' : 'stop'} the meeting. Do you agree?",
              confirmTextColor: Colors.white,
              textConfirm: "Yes",
              onConfirm: () async {
                isStartAnswered = true;
                if (!isMeetingRunning) {
                  //meetingMode();
                  await ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": request["duration"],
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                } else {
                  //lMinutes = minutes.value;
                  //lSeconds = seconds.value;
                  //meetingMode();
                  await ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": -1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                }
              },
              cancelTextColor: Colors.red,
              textCancel: "No",
              onCancel: () {
                isStartAnswered = true;
                ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
              },
            );

           await Future.delayed(const Duration(minutes: 1), () async{
              if (!isStartAnswered) {
                log("inside delayed check if");
                // Get.back();
                if (isMeetingRunning) {
                  log("inside delayed check if in is meeting running");
                 await ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": -1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  if (dataMap["start_requester_id"] !=
                      UserController().auth.currentUser?.uid) {
                    log("inside the start requester id check if");
                    Get.back();
                  }
                } else {
                 await ref2.update({
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
          log("in -2 else not the meeting the request was made for.");
        }
      } else if (timerSeconds == 2) {
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          var name = "";
          if (UserController().auth.currentUser?.uid !=
              dataMap["pause_requester_id"]) {
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
                  "$name has requested to ${!isMeetingPaused ? 'pause' : 'continue'} the meeting. Do you agree?",
              confirmTextColor: Colors.white,
              textConfirm: "Yes",
              onConfirm: () async{
                isPauseAnswered = true;
                if (!isMeetingPaused) {
                 await ref2.update({
                    // "startAt": FieldValue.serverTimestamp(),
                    "seconds": 1,
                    "start_requester_id": dataMap["start_requester_id"],
                    "pause_requester_id": dataMap["pause_requester_id"]
                  });
                  Get.back();
                } else {
                 await ref2.update({
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
              onCancel: () async{
                isPauseAnswered = true;
               await ref2.update({
                  // "startAt": FieldValue.serverTimestamp(),
                  "seconds": 0,
                  "start_requester_id": dataMap["start_requester_id"],
                  "pause_requester_id": dataMap["pause_requester_id"]
                });
              },
            );
           await Future.delayed(Duration(minutes: 1), () async{
              if (!isPauseAnswered) {
              await  ref2.update({
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
      } else if (timerSeconds == -3) {
        // timer.cancel();
        if (UserController().auth.currentUser?.uid == request["buyer_id"]) {
          Get.defaultDialog(
            barrierDismissible: false,
            title: "Attention!",
            middleText:
                "The meeting time has reached the requested time limit. If you continue, you would be charged based on "
                "the extra charge rate for this extra time. Do you wish to continue?",
            confirmTextColor: Colors.white,
            textConfirm: "Yes",
            onConfirm: () async{
              isExtraChargeAnswered = true;
             await ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": 10,
              });
              Get.back();
            },
            cancelTextColor: Colors.red,
            textCancel: "No",
            onCancel: ()async {
              isExtraChargeAnswered = true;
              await ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": -1,
                "finished_at_minutes": minutes,
                "finished_at_seconds": seconds,
                "start_requester_id": dataMap["start_requester_id"],
                "pause_requester_id": dataMap["pause_requester_id"]
              });
            },
          );
         await Future.delayed(Duration(minutes: 1), () async{
            log("is pause answered delayed checking");
            // Get.back();
            if (!isExtraChargeAnswered) {
             await ref2.update({
                // "startAt": FieldValue.serverTimestamp(),
                "seconds": -1,
                "finished_at_minutes": minutes,
                "finished_at_seconds": seconds,
              }).then((value) => log("from !isPauseAnswered.value"));
            }
          });
        }
      } else {
        //+ if the number is none of the code related things
        var id =
            getChatRoomIdByUsernames(request['seller_id'], request['buyer_id']);
        if (id == dataMap['meetId']) {
          if (!isMeetingRunning) {
            // isMeetingRunning.value = true;
            meetingMode();
          }
          if (isMeetingPaused) {
            // isMeetingPaused.value = false;
            pauseMode();
          }
        }
      }
    });
  }
}*/
