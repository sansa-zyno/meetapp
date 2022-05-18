import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/HWidgets/detail_data.dart';
import 'package:meeter/Widgets/HWidgets/detail_appbar_buyer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsBuyerScreen extends StatefulWidget {
  final DemandData demands;
  DetailsBuyerScreen(this.demands);
  @override
  _DetailsBuyerScreenState createState() => _DetailsBuyerScreenState();
}

class _DetailsBuyerScreenState extends State<DetailsBuyerScreen> {
  OurUser? demandPerson;
  int? likes;
  late FirebaseAuth _auth;

  onLoad() async {
    UserController user = UserController();
    demandPerson = await user.getUserInfo(widget.demands.demand_person_uid!);
    if (demandPerson != null) {
      FirebaseFirestore.instance
          .collection('demands')
          .doc(demandPerson!.uid)
          .collection('demand')
          .doc(widget.demands.demand_id)
          .snapshots()
          .listen((event) {
        likes = event['demand_likes'];
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                DetailsData(
                  bannerImage: widget.demands.demand_bannerImage,
                  titleText: widget.demands.demand_title,
                  priceText: "\$${widget.demands.demand_price}",
                  priceText1: '/ 30 min',
                  timeText: widget.demands.demand_available_online!
                      ? "Availabe virtually"
                      : "Not available virtually",
                  likesText: likes,
                  // categoryText: 'In Category',
                  detailText: widget.demands.demand_description,
                  location: widget.demands.demand_location,
                ),
              ],
            ),
          ),
          demandPerson != null
              ? _auth.currentUser!.uid != demandPerson!.uid
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: DetailBarBuyer(
                            widget.demands, demandPerson!, likes!),
                      ),
                    )
                  : Container()
              : Container()
        ],
      ),
    );
  }
}
