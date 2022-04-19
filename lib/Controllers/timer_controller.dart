

import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

class TimerController extends GetxController{
  static TimerController instance = Get.find();

  RxBool isMeetingRunning = false.obs;
  RxBool isMeetingStarted = false.obs;

  RxString minutes = '00'.obs;
  RxString seconds = '00'.obs;

  Duration duration = Duration();
  late Timer timer;


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
  }

  void meetingMode() {
    isMeetingRunning.value = !isMeetingRunning.value;
    if (isMeetingRunning.value) {
      log("inside if(isRecordingAudio.value)");
      startTimer();
      // buildTime();
    } else {
      log("the time is:: ${minutes.value}:${seconds.value}");
      timer.cancel();
    }
    update();
  }
}