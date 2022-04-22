import 'dart:developer';
import 'package:achievement_view/achievement_view.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Constants/controllers.dart';
import '../../Constants/get_token.dart';

const appId = "22c3a09e17c14a218162b6ee8ef8450e";

class Timer extends StatefulWidget {
  final DocumentSnapshot request;

  // bool haveMoreMembers;
  // final String token;
  // final String channelName;

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

  late int _remoteUid;
  late RtcEngine _engine;

  // String channelName = "";
  bool muted = false;
  String token = "";
  String channelName = "";

  // AgoraClient client;

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
    currentCharge = widget.request["price"] / widget.request["price"];
    extraCharge = currentCharge + (currentCharge * 0.3);
    log("currentCharge is: $currentCharge and extraCharge is: $extraCharge");
    initAgora();
  }

  Future<void> initAgora() async {
    // client.initialize();
    // retrieve permissions
    await [
      Permission.microphone,
      //Permission.camera
    ].request();
    //create the engine
    RtcEngineContext context = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(context);
    // _engine = await RtcEngine.create(appId);
    await _engine.disableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          log("local user in RtcEngineEventHandler $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          log("remote user in RtcEngineEventHandler $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user in RtcEngineEventHandler $uid left channel");
          setState(() {
            _remoteUid = 0;
          });
        },
        error: (e) {
          log("error in RtcEngineEventHandler is: ${e.toString()}");
        },
      ),
    );

    // log("\n and widget.token: ${token}"
    //     "\n widget.channelName: ${channelName}"
    // );
    // await _engine.joinChannel(
    //     token, channelName,
    //     null,
    //     0);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: h * 3.3, horizontal: w * 7.3),
                child: Obx(() {
                  return Column(
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
                                      : 'Touch to\nbegin your\nmeeting',
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
                            //+start the timer here.
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: []);
                            channelName = getChatRoomIdByUsernames(
                                widget.request["buyer_id"],
                                widget.request["seller_id"]);
                            log("channelName is: $channelName");
                            token = await GetToken().getTokenMethod(
                                channelName: channelName, uid: '0');
                            if (token != "") {
                              log("token is not null and token is: $token");
                              log("\n and token: $token"
                                  "\n channelName: $channelName "
                                  "before joining channel");
                              try {
                                if (!timerController.isMeetingRunning.value) {
                                  await _engine
                                      .joinChannel(token, channelName, null, 0)
                                      .then((value) {
                                    log("\n\n started the timer in then after "
                                        "joining the channel.\n\n");
                                    timerController.meetingMode();
                                  });
                                }
                              } catch (e) {
                                Get.defaultDialog(
                                    title: "Error!",
                                    middleText:
                                        "Following error was thrown while "
                                        "joining the channel: ${e.toString()}");
                              }
                            } else {
                              log("token is null.");
                            }
                          },
                        );
                      }),
                      SizedBox(
                        height: h * 1.1,
                      ),
                      //+set these call buttons please
                      if (timerController.isMeetingRunning.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "muteButton",
                              onPressed: () {
                                setState(() {
                                  muted = !muted;
                                });
                                _engine.muteLocalAudioStream(muted);
                              },
                              child: Icon(
                                Icons.mic,
                                color: muted ? Colors.red : Colors.blue,
                              ),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FloatingActionButton(
                              heroTag: "endCallButton",
                              onPressed: () async {
                                await _engine.leaveChannel();
                                // SystemChrome.restoreSystemUIOverlays();
                                SystemChrome.setEnabledSystemUIMode(
                                    SystemUiMode.manual,
                                    overlays: [
                                      SystemUiOverlay.bottom,
                                      SystemUiOverlay.top
                                    ]);
                                log("before refreshing minutes: ${timerController.minutes}"
                                    " seconds: ${timerController.seconds}");
                                timerController.meetingMode();
                                String minutes = timerController.minutes.value;
                                String seconds = timerController.seconds.value;
                                log("local values are: minutes: $minutes and "
                                    "seconds: $seconds");
                                totalCharge = 0;
                                extraMinutes = 0;
                                extraSeconds = 0;
                                extraTimeCharge = 0;
                                if (int.parse(minutes) >
                                        widget.request["duration"] ||
                                    (int.parse(minutes) ==
                                        widget.request["duration"])) {
                                  totalCharge = widget.request["duration"] *
                                      currentCharge;
                                  extraMinutes = (int.parse(minutes) -
                                          widget.request["duration"])
                                      .toInt();
                                  extraSeconds = int.parse(seconds);
                                  extraTimeCharge = extraMinutes * extraCharge;
                                  extraTimeCharge +=
                                      extraSeconds * (extraCharge / 60);
                                  totalCharge += extraTimeCharge;
                                } else {
                                  totalCharge =
                                      int.parse(minutes) * currentCharge;
                                  totalCharge += ((int.parse(seconds) *
                                          (currentCharge / 60))
                                      .toPrecision(3)).toPrecision(2);
                                }
                                timerController.resetTimer();
                                log("after refreshing minutes: ${timerController.minutes}"
                                    " seconds: ${timerController.seconds}");
                                log("returnVValue of leaveChannel is:");
                                log("\n\n\n"
                                    "You were in the meeting for "
                                    "$minutes minutes and $seconds seconds. "
                                    "You are being charged \$$totalCharge for "
                                    "this meeting."
                                    "\n\n\n");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                              "${widget.request["buyer_name"]} "
                                              "was in the meeting for "
                                              "$minutes minutes and $seconds seconds. "
                                              "He is being charged \$$totalCharge for "
                                              "this meeting."),
                                          actions: [
                                            TextButton(
                                              child: const Text("Ok"),
                                              onPressed: () async {
                                                // AchievementView(
                                                //   context,
                                                //   color: Colors
                                                //       .green,
                                                //   icon: const Icon(
                                                //     FontAwesomeIcons
                                                //         .check,
                                                //     color: Colors
                                                //         .white,
                                                //   ),
                                                //   title:
                                                //   "Succesfull!",
                                                //   elevation:
                                                //   20,
                                                //   subTitle:
                                                //   "Request Cancelled succesfully",
                                                //   isCircle:
                                                //   true,
                                                // ).show();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            // FlatButton(
                                            //   child:
                                            //   const Text("No"),
                                            //   onPressed: () {
                                            //     Navigator.pop(
                                            //         context);
                                            //   },
                                            // )
                                          ],
                                        ));
                                // Get.defaultDialog(
                                //     barrierDismissible: false,
                                //     title: "Charge Info!",
                                //     middleText: "You were in the meeting for "
                                //         "$minutes minutes and $seconds seconds. "
                                //         "You are being charged \$$totalCharge for "
                                //         "this meeting.");
                              },
                              child: const Icon(
                                Icons.local_phone_rounded,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: h * 1.1,
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
                            'You are Meeting: ${widget.request["buyer_name"]}',
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
                                  '\$$extraCharge/1 min',
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
                                child: Text(
                                  '\$$currentCharge/1 min',
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
                                  onPressed: () {},
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
                                  onPressed: () {},
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
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
