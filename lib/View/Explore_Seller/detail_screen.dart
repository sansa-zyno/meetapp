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
  String timesAgo = "";

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

  calcTimesAgo() {
    Duration dur = DateTime.now().difference(widget.meeter.meetup_date!);
    print(dur.inHours);
    if (dur.inHours < 24) {
      timesAgo = "Moments ago";
      setState(() {});
    }
    if (dur.inDays > 0 && dur.inDays < 7) {
      timesAgo =
          dur.inDays == 1 ? "${dur.inDays} day ago" : "${dur.inDays} days ago";
      setState(() {});
    }
    if (dur.inDays >= 7 && dur.inDays < 30) {
      timesAgo = (dur.inDays / 7).truncate() == 1
          ? "${(dur.inDays / 7).truncate()} week ago"
          : "${(dur.inDays / 7).truncate()} weeks ago";
      setState(() {});
    }
    if (dur.inDays >= 30 && dur.inDays < 365) {
      timesAgo = (dur.inDays / 30).truncate() == 1
          ? "${(dur.inDays / 30).truncate()} month ago"
          : "${(dur.inDays / 30).truncate()} months ago";
      setState(() {});
    }
    if (dur.inDays >= 365) {
      timesAgo = (dur.inDays / 365).truncate() == 1
          ? "${(dur.inDays / 365).truncate()} year ago"
          : "${(dur.inDays / 365).truncate()} years ago";
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calcTimesAgo();
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
                timesAgo: timesAgo,
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
                      child: DetailBar(
                        widget.meeter,
                        sellerDetails!,
                        likes!,
                      ),
                    ),
                  )
                : Container()
            : Container()
      ]),
    );
  }
}
