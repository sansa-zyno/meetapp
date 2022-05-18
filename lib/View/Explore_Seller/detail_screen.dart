import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/HWidgets/detail_data.dart';
import 'package:meeter/Widgets/HWidgets/detail_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsScreen extends StatefulWidget {
  final MeetupData meeter;
  DetailsScreen(this.meeter);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  OurUser? sellerDetails;
  int? likes;
  late FirebaseAuth _auth;

  onLoad() async {
    UserController user = UserController();
    sellerDetails = await user.getUserInfo(widget.meeter.meetup_seller_uid!);
    if (sellerDetails != null) {
      FirebaseFirestore.instance
          .collection('meeters')
          .doc(sellerDetails!.uid)
          .collection('meeter')
          .doc(widget.meeter.meetup_id)
          .snapshots()
          .listen((event) {
        likes = event['meetup_likes'];
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad();
    _auth = FirebaseAuth.instance;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              DetailsData(
                bannerImage: widget.meeter.meetup_bannerImage!,
                titleText: widget.meeter.meetup_title!,
                priceText: "\$${widget.meeter.meetup_price}",
                priceText1: '/ 30 min',
                timeText: widget.meeter.meetup_available_online!
                    ? "Availabe virtually"
                    : "Not available virtually",
                likesText: likes ?? 0,
                // categoryText: 'In Category',
                detailText: widget.meeter.meetup_description!,
                location: widget.meeter.meetup_location!,
              ),
            ],
          ),
        ),
        sellerDetails != null
            ? _auth.currentUser!.uid != sellerDetails!.uid
                ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: DetailBar(widget.meeter, sellerDetails!, likes!),
                    ),
                  )
                : Container()
            : Container()
      ]),
    );
  }
}
