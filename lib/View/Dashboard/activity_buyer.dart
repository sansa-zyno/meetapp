import 'package:flutter/material.dart';
import 'package:meeter/Widgets/HWidgets/upcoming_data.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar_buyer.dart';
import 'package:meeter/Widgets/HWidgets/recent_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerActivityScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> requests;
  BuyerActivityScreen({required this.requests});
  @override
  _BuyerActivityScreenState createState() => _BuyerActivityScreenState();
}

class _BuyerActivityScreenState extends State<BuyerActivityScreen> {
  bool recent = true;
  bool upcomming = false;
  String? myUsername;
  Stream<QuerySnapshot>? chatroomStream;

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    myUsername = _pref.getString('userName');
    setState(() {});
    Stream<QuerySnapshot> chatroomStream = FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .where("read", isEqualTo: false)
        .snapshots();

    return chatroomStream;
  }

  getChatRoomStream() async {
    chatroomStream = await getChatRooms();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRoomStream();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: h * 16.8,
                ),
                Container(
                  height: h * 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    border: Border.all(
                      width: w * 0.2,
                      color: Colors.green,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 1.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: recent == true
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Colors.green,
                                            width: w * 0.4,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 2.4, vertical: h * 1.1),
                                  child: Text(
                                    "Recent",
                                    style: TextStyle(
                                      fontSize: w * 6.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  recent = true;
                                  upcomming = false;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: upcomming == true
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Colors.green,
                                            width: w * 0.4,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 2.4, vertical: h * 1.1),
                                  child: Text(
                                    "Upcoming ",
                                    style: TextStyle(
                                      fontSize: w * 6.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  recent = false;
                                  upcomming = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: h * 2.2,
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.5,
                      ),
                      recent
                          ? StreamBuilder<QuerySnapshot>(
                              stream: chatroomStream,
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        reverse: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(0),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return RecentData(
                                            clr: Colors.green,
                                            msg: snapshot.data!.docs[index],
                                            text: "msg",
                                            username: myUsername,
                                          );
                                        })
                                    : Container();
                              })
                          : Container(),
                      recent
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              reverse: true,
                              itemCount: widget.requests.length,
                              itemBuilder: (context, index) {
                                return widget.requests[index]["accepted"] ==
                                            null &&
                                        widget.requests[index]["modified"] ==
                                            null
                                    ? RecentData(
                                        clr: Colors.green,
                                        request: widget.requests[index],
                                        text: "new",
                                      )
                                    : widget.requests[index]["accepted"]
                                        ? RecentData(
                                            clr: Colors.green,
                                            request: widget.requests[index],
                                            text: "accepted",
                                          )
                                        : widget.requests[index]["modified"]
                                            ? RecentData(
                                                clr: Colors.green,
                                                request: widget.requests[index],
                                                text: "modified",
                                              )
                                            : !(widget.requests[index]
                                                        ["accepted"] ??
                                                    true)
                                                ? RecentData(
                                                    clr: Colors.green,
                                                    request:
                                                        widget.requests[index],
                                                    text: "cancelled",
                                                  )
                                                : Container();
                              })
                          : Container(),
                      upcomming
                          ? UpcomingData(
                              clr: Colors.green, requests: widget.requests)
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 8.9,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Activity",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: w * 6.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
