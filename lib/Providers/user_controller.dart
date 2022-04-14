import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meeter/Model/user.dart';
import 'package:uuid/uuid.dart';

class UserController with ChangeNotifier {
  final OurUser _currentUser = OurUser();
  OurUser get getCurrentUser => _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> updateDisplay(String name) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"displayName": name});
    } catch (e) {
      return false;
    }
    return true;
  }

  bool isUploading = false;
  late File file;
  ImagePicker img = ImagePicker();
  String postId = Uuid().v4();

  Future<bool> updateAvatar(String uid) async {
    Future<String> uploadImage(File imageFile, String uid) async {
      late String downloadUrl;
      Reference reference =
          FirebaseStorage.instance.ref().child("profilePictures/$uid.jpg");
      UploadTask uploadTask = reference.putData(imageFile.readAsBytesSync());

      await uploadTask.whenComplete(() async {
        downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
      });

      return downloadUrl;
    }

    updatePostInFirestore({String? mediaUrl, String? uid}) async {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "avatarUrl": mediaUrl,
      });
      await getCurrentUserInfo();
    }

    uploadToStorage(String uid) async {
      String mediaUrl = await uploadImage(file, uid);
      await updatePostInFirestore(mediaUrl: mediaUrl, uid: uid);
    }

    handleChooseFromGallery(String uid) async {
      var getImage =
          await img.getImage(source: ImageSource.gallery, imageQuality: 25);
      File file = File(getImage!.path);
      this.file = file;
      await uploadToStorage(uid);
    }

    handleChooseFromGallery(uid);

    return true;
  }

  Future<bool> updateBanner(String uid, String collection) async {
    Future<String> uploadImage(File imageFile, String uid) async {
      late String downloadUrl;
      Reference reference =
          FirebaseStorage.instance.ref().child("profileBanners/$uid.jpg");
      UploadTask uploadTask = reference.putData(imageFile.readAsBytesSync());
      await uploadTask.whenComplete(() async {
        downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
      });
      return downloadUrl;
    }

    updatePostInFirestore({String? mediaUrl, String? uid}) async {
      await FirebaseFirestore.instance.collection(collection).doc(uid).update({
        "bannerImage": mediaUrl,
      });
      await getCurrentUserInfo();
    }

    uploadToStorage(String uid) async {
      String mediaUrl = await uploadImage(file, uid);
      await updatePostInFirestore(mediaUrl: mediaUrl, uid: uid);
    }

    handleChooseFromGallery(String uid) async {
      var getImage = await img.getImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 25);
      File file = File(getImage!.path);
      this.file = file;
      await uploadToStorage(uid);
    }

    handleChooseFromGallery(uid);

    return true;
  }

  Future<bool> updateBio(String bio) async {
    try {
      await _firestore
          .collection("users")
          .doc(_currentUser.uid)
          .update({"bio": bio});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateOccupation(String occupation) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"occupation": occupation});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateAge(String age) async {
    try {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({"age": age});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateCountry(String country) async {
    try {
      await _firestore
          .collection("users")
          .doc(_currentUser.uid)
          .update({"country": country});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<OurUser> getCurrentUserInfo() async {
    try {
      if (auth.currentUser != null) {
        DocumentSnapshot _documentSnapshot = await _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get();
        Map<String, dynamic> snapshotData =
            _documentSnapshot.data()! as Map<String, dynamic>;
        _currentUser.uid = auth.currentUser!.uid;
        _currentUser.phone = snapshotData["phoneNumber"];
        _currentUser.accountCreated = snapshotData["accountCreated"];
        _currentUser.avatarUrl = snapshotData["avatarUrl"];
        _currentUser.age = snapshotData["age"];
        _currentUser.bio = snapshotData["bio"];
        _currentUser.displayName = snapshotData["displayName"];
        _currentUser.country = snapshotData["country"];
        _currentUser.userType = snapshotData["userType"];
        _currentUser.bannerImage = snapshotData["bannerImage"];
        _currentUser.occupation = snapshotData["occupation"];
        notifyListeners();
        return _currentUser;
      } else {
        return _currentUser;
      }
    } catch (e) {
      return _currentUser;
    }
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser usr = OurUser();
    try {
      DocumentSnapshot _documentSnapshot =
          await _firestore.collection("users").doc(uid).get();
      Map<String, dynamic> snapshotData =
          _documentSnapshot.data()! as Map<String, dynamic>;
      usr.uid = snapshotData["uid"];
      usr.phone = snapshotData["phoneNumber"];
      usr.accountCreated = snapshotData["accountCreated"];
      usr.avatarUrl = snapshotData["avatarUrl"];
      usr.age = snapshotData["age"];
      usr.bio = snapshotData["bio"];
      usr.displayName = snapshotData["displayName"];
      usr.country = snapshotData["country"];
      usr.userType = snapshotData["userType"];
      usr.occupation = snapshotData["occupation"];
      return usr;
    } catch (e) {
      return usr;
    }
  }
}
