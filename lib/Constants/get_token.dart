import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:meeter/Widgets/LoadingIndicator/showLoading.dart';

class GetToken {
  /*
  *https://meeter-app-token-server.herokuapp.com/rtc/abc/:role/uid/578858/
  * https://nikah--match.herokuapp.com/access_token?
  * channel=hdjfdhfdfhdjfdjhfjdh-shhfsjdfsdhfsjdhf&uid=hsfysufghsdjfbsdjhfb
  *
  * {"token":"00640216abc119348c4a6236c11ab1a0c3eIAAcfnsa2UG1D4MTKwSwkXNqXPrga5HhlFMigi/vx7+hYiDGAgkfRf9/EABGDBlc7RYKYgEAAQAAAAAA"}
  * // older link 'https://nikah--match.herokuapp.com/access_token?uid=0&channel=$channelName'));*/

  Future<String> getTokenMethod({required String channelName, required String uid}) async {
    String token = "";
    // showLoading();
    log("in getToken channelName: $channelName and  $uid");
    try {
      var client = http.Client();
      if (channelName != "" && uid != "") {
        var response = await client.get(
          Uri.parse('https://meeter-app-token-server.herokuapp.com/rtc/$channelName/:role/uid/0/'),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          log("response is: $data");
          token = data["rtcToken"];
          return token;
        } else {
          Get.defaultDialog(
              title: "Error",
              middleText:
                  "seems to have an error returned response is: ${jsonDecode(response.body)} "
                  "and response.statusCode: ${response.statusCode}");
          log("seems to have an error returned response is: ${jsonDecode(response.body)} "
              "and response.statusCode: ${response.statusCode}");
          return token;
        }
      } else {
        log("No channel name or user Id found: $channelName & $uid");
        return token;
      }
      // }else{
      //   Get.snackbar("The token already exists", "A token was already generated. "
      //       "Please join the call");
      //   return chatRoomMap['token'];
      // }
      // });
    } catch (e) {
      Get.defaultDialog(
          title: "Error in getting the token", middleText: "Error is: $e");
      return token;
    }
  }
}
