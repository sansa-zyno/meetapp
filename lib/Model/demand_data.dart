import 'package:cloud_firestore/cloud_firestore.dart';

class DemandData {
  String? demand_id;
  bool? featured;
  String? demand_title;
  String? demand_description;
  int? demand_price;
  String? demand_location;
  int? demand_likes;
  bool? demand_available_online;
  String? demand_person_uid;
  String? demand_person_name;
  String? demand_person_image;
  String? demand_bannerImage;
  List? demand_tags;
  DateTime? demand_date;
  double? lat;
  double? long;

  DemandData(
      {this.demand_id,
      this.lat,
      this.long,
      this.demand_available_online,
      this.demand_bannerImage,
      this.demand_description,
      this.demand_likes,
      this.demand_location,
      this.demand_price,
      this.demand_person_image,
      this.demand_person_name,
      this.demand_person_uid,
      this.demand_tags,
      this.demand_title,
      this.demand_date,
      this.featured});

  DemandData.fromSnap(DocumentSnapshot snap)
      : demand_id = snap.id,
        demand_title = snap['demand_title'],
        demand_description = snap['demand_description'],
        demand_price = snap['demand_price'],
        demand_location = snap['demand_location'],
        demand_likes = snap['demand_likes'],
        demand_available_online = snap['demand_available_online'],
        demand_person_uid = snap['demand_person_uid'],
        demand_person_name = snap['demand_person_name'],
        demand_person_image = snap['demand_person_image'],
        demand_bannerImage = snap['demand_bannerImage'],
        demand_tags = snap['demand_tags'],
        demand_date = snap['demand_date'].toDate(),
        lat = snap['lat'],
        long = snap['long'],
        featured = snap['featured'];
}
