import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RequestBloc with ChangeNotifier {
  Stream? infoStream;
  List<QueryDocumentSnapshot> _requests = [];
  List<String> requestUids = [];
  List<QueryDocumentSnapshot> get requests => _requests;

  RequestBloc() {
    getRequestUids();
    getStreamData();
  }

  getStreamData() {
    infoStream ??= Stream<List<int>>.periodic(const Duration(seconds: 5), (x) {
      //for listening sake but List not used
      getRequests(requestUids);
      return [0, 1];
    });
    infoStream!.listen((event) {});
  }

  getRequestUids() {
    FirebaseFirestore.instance
        .collection('requests')
        .snapshots()
        .listen((event) async {
      requestUids = [];
      for (int i = 0; i < event.docs.length; i++) {
        requestUids.add(event.docs[i].id);
      }
    });
  }

  getRequests(ids) async {
    _requests = [];
    for (int i = 0; i < ids.length; i++) {
      QuerySnapshot event = await FirebaseFirestore.instance
          .collection('requests')
          .doc(ids[i])
          .collection('request')
          .orderBy("ts")
          .get();

      for (int i = 0; i < event.docs.length; i++) {
        _requests.add(event.docs[i]);
      }
      if (i == ids.length - 1) {
        notifyListeners();
      }
    }
  }
}
