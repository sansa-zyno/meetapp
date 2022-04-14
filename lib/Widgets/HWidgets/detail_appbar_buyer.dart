import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';
import 'package:meeter/View/chat_screen.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:meeter/View/Explore_buyer/request_offer_buyer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:provider/provider.dart';

class DetailBarBuyer extends StatefulWidget {
  final DemandData demand;
  final OurUser personDetails;
  final int likes;
  DetailBarBuyer(this.demand, this.personDetails, this.likes);

  @override
  _DetailBarBuyerState createState() => _DetailBarBuyerState();
}

class _DetailBarBuyerState extends State<DetailBarBuyer> {
  bool isLiked = false;
  late UserController _currentUser;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    _currentUser = Provider.of<UserController>(context);
    return SafeArea(
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
            width: w * 0.2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isLiked
                ? IconButton(
                    onPressed: () async {
                      int previousLikes = widget.likes;
                      int prev = previousLikes - 1;
                      await FirebaseFirestore.instance
                          .collection('demands')
                          .doc(widget.personDetails.uid)
                          .collection('demand')
                          .doc(widget.demand.demand_id)
                          .update({"demand_likes": prev});
                      await FirebaseFirestore.instance
                          .collection('favourites')
                          .doc(_currentUser.getCurrentUser.uid)
                          .collection('favourite')
                          .doc(widget.demand.demand_id)
                          .delete();

                      isLiked = !isLiked;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 40,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      int previousLikes = widget.likes;
                      int prev = previousLikes + 1;
                      await FirebaseFirestore.instance
                          .collection('demands')
                          .doc(widget.personDetails.uid)
                          .collection('demand')
                          .doc(widget.demand.demand_id)
                          .update({"demand_likes": prev});
                      isLiked = !isLiked;
                      setState(() {});
                      await FirebaseFirestore.instance
                          .collection('favourites')
                          .doc(_currentUser.getCurrentUser.uid)
                          .set({'f': "f"});
                      await FirebaseFirestore.instance
                          .collection("favourites")
                          .doc(_currentUser.getCurrentUser.uid)
                          .collection('favourite')
                          .doc(widget.demand.demand_id)
                          .set({
                        "type": "demand",
                        "featured": widget.demand.featured,
                        "lat": widget.demand.lat,
                        "long": widget.demand.long,
                        "demand_title": widget.demand.demand_title,
                        "demand_description": widget.demand.demand_description,
                        "demand_price": widget.demand.demand_price,
                        "demand_likes": widget.demand.demand_likes,
                        "demand_location": widget.demand.demand_location,
                        "demand_available_online":
                            widget.demand.demand_available_online,
                        "demand_person_uid": widget.demand.demand_person_uid,
                        "demand_person_name": widget.demand.demand_person_name,
                        "demand_person_image":
                            widget.demand.demand_person_image,
                        "demand_bannerImage": widget.demand.demand_bannerImage,
                        "demand_tags": widget.demand.demand_tags
                      });
                    },
                    icon: Icon(
                      Icons.favorite_outline_rounded,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
            Container(
              height: 40,
              child: GradientButton(
                textClr: Colors.black,
                title: "Chat",
                clrs: [Colors.white, Colors.white],
                //border: Border(bottom: BorderSide(color: Color(0XFF00FF00))),
                onpressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String userName = preferences.getString('userName')!;
                  if (widget.personDetails != null) {
                    var chatroomId = getChatRoomIdByUsernames(
                        userName, widget.personDetails.displayName!);
                    Map<String, dynamic> chatroomInfo = {
                      "users": [userName, widget.personDetails.displayName]
                    };
                    Database().createChatRoom(chatroomId, chatroomInfo);

                    QuerySnapshot q = await FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatroomId)
                        .collection('chats')
                        .where("read", isEqualTo: false)
                        .get();
                    for (int i = 0; i < q.docs.length; i++) {
                      await FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(chatroomId)
                          .collection('chats')
                          .doc(q.docs[i].id)
                          .update({"read": true});
                    }

                    await FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(chatroomId)
                        .update({"read": true});

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(widget.personDetails),
                        ));
                  } else {}
                },
              ),
            ),
            Container(
              height: 40,
              child: GradientButton(
                clrs: [Colors.green, Colors.green],
                title: 'Make Offer',
                onpressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          RequestOfferBuyer(
                              doc: widget.demand,
                              personDetails: widget.personDetails),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
