import 'package:cloud_firestore/cloud_firestore.dart';

class MeetupData {
  String? meetup_id;
  bool? featured;
  String? meetup_title;
  String? meetup_description;
  int? meetup_price;
  String? meetup_location;
  int? meetup_likes;
  bool? meetup_available_online;
  String? meetup_seller_uid;
  String? meetup_seller_name;
  String? meetup_seller_image;
  String? meetup_bannerImage;
  List? meetup_tags;
  double? lat;
  double? long;

  MeetupData(
      {this.meetup_id,
      this.lat,
      this.long,
      this.meetup_available_online,
      this.meetup_bannerImage,
      this.meetup_description,
      this.meetup_likes,
      this.meetup_location,
      this.meetup_price,
      this.meetup_seller_image,
      this.meetup_seller_name,
      this.meetup_seller_uid,
      this.meetup_tags,
      this.meetup_title,
      this.featured});

  MeetupData.fromSnap(DocumentSnapshot snap)
      : meetup_id = snap.id,
        meetup_title = snap['meetup_title'],
        meetup_description = snap['meetup_description'],
        meetup_price = snap['meetup_price'],
        meetup_location = snap['meetup_location'],
        meetup_likes = snap['meetup_likes'],
        meetup_available_online = snap['meetup_available_online'],
        meetup_seller_uid = snap['meetup_seller_uid'],
        meetup_seller_name = snap['meetup_seller_name'],
        meetup_seller_image = snap['meetup_seller_image'],
        meetup_bannerImage = snap['meetup_bannerImage'],
        meetup_tags = snap['meetup_tags'],
        lat = snap['lat'],
        long = snap['long'],
        featured = snap['featured'];
}
