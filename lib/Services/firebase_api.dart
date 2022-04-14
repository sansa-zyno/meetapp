import 'package:async/async.dart';
import 'package:meeter/Model/demand.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Model/meetup.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Services/geolocator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class FirebaseApi {
  Stream<List<Meetup>> getMeeterUids() {
    return FirebaseFirestore.instance.collection('meeters').snapshots().map(
        (snapshots) =>
            snapshots.docs.map((doc) => Meetup.fromSnap(doc)).toList());
  }

  StreamZip<List<MeetupData>> getMeeterCollection(List<Meetup> meetups) {
    Stream<List<MeetupData>> stream;
    List<Stream<List<MeetupData>>> listOfStreams = [];
    for (Meetup meetup in meetups) {
      stream = FirebaseFirestore.instance
          .collection('meeters')
          .doc(meetup.uid)
          .collection('meeter')
          .snapshots()
          .map((snapshots) =>
              snapshots.docs.map((doc) => MeetupData.fromSnap(doc)).toList());
      listOfStreams.add(stream);
    }
    StreamZip<List<MeetupData>> output = StreamZip(listOfStreams);
    return output;
  }

  Future<List<List<MeetupData>>> getNearestMeeterCollection(
      List<List<MeetupData>> z) async {
    Position pos = await GeoLocatorService().getLocation();
    List<MeetupData> y = z.expand((x) => x).toList();
    List<MeetupData> lmeetups = [];
    List<List<MeetupData>> llmeetups = [];
    for (MeetupData x in y) {
      GeoLocatorService()
          .getDistance(pos.latitude, pos.longitude, x.lat!, x.long!)
          .then((value) {
        if (value <= 300000) {
          lmeetups.add(x);
        }
      });
    }
    llmeetups.add(lmeetups);
    return llmeetups;
  }

  Stream<List<Demand>> getDemandUids() {
    return FirebaseFirestore.instance.collection('demands').snapshots().map(
        (snapshots) =>
            snapshots.docs.map((doc) => Demand.fromSnap(doc)).toList());
  }

  StreamZip<List<DemandData>> getDemandCollection(List<Demand> demands) {
    Stream<List<DemandData>> stream;
    List<Stream<List<DemandData>>> listOfStreams = [];
    for (Demand demand in demands) {
      stream = FirebaseFirestore.instance
          .collection('demands')
          .doc(demand.uid)
          .collection('demand')
          .snapshots()
          .map((snapshots) =>
              snapshots.docs.map((doc) => DemandData.fromSnap(doc)).toList());
      listOfStreams.add(stream);
    }
    StreamZip<List<DemandData>> output = StreamZip(listOfStreams);
    return output;
  }

  Future<List<List<DemandData>>> getNearestDemandCollection(
      List<List<DemandData>> z) async {
    Position pos = await GeoLocatorService().getLocation();
    List<DemandData> y = z.expand((x) => x).toList();
    List<DemandData> ldemands = [];
    List<List<DemandData>> lldemands = [];
    for (DemandData x in y) {
      GeoLocatorService()
          .getDistance(pos.latitude, pos.longitude, x.lat!, x.long!)
          .then((value) {
        if (value <= 300000) {
          ldemands.add(x);
        }
      });
    }
    lldemands.add(ldemands);
    return lldemands;
  }
}
