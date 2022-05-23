import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String? uid;
  String? phone;
  String? displayName;
  String? country;
  String? avatarUrl;
  String? userType;
  String? bannerImage;
  String? verified;
  String? age;
  String? bio;
  String? occupation;
  Timestamp? accountCreated;
  String? lastSeen;

  OurUser(
      {this.accountCreated,
      this.phone,
      this.uid,
      this.avatarUrl,
      this.country,
      this.displayName,
      this.userType,
      this.verified,
      this.bio,
      this.age,
      this.bannerImage,
      this.occupation,
      this.lastSeen});

  factory OurUser.fromFireStore(DocumentSnapshot _data) {
    return OurUser(
        uid: _data["uid"],
        phone: _data["phoneNumber"] ?? "",
        age: _data["age"] ?? "",
        displayName: _data["displayName"] ?? "",
        country: _data["country"] ?? "",
        avatarUrl: _data["avatarUrl"] ?? "",
        accountCreated: _data["accountCreated"],
        userType: _data["userType"] ?? "",
        verified: _data["verified"] ?? "",
        bio: _data["bio"] ?? "",
        occupation: _data["occupation"] ?? "",
        bannerImage: _data["bannerImage"] ?? "",
        lastSeen: _data["lastSeen"] ?? "");
  }
}
