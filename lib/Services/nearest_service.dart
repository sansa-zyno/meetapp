import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/Services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class NearestService {
  Future<List<MeetupData>> getNearestMeeterCollection(
      List<MeetupData> z, Position pos) async {
    List<MeetupData> lmeetups = [];
    for (MeetupData x in z) {
      GeoLocatorService()
          .getDistance(pos.latitude, pos.longitude, x.lat!, x.long!)
          .then((value) {
        if (value <= 300000) {
          lmeetups.add(x);
        }
      });
    }
    return lmeetups;
  }

  Future<List<DemandData>> getNearestDemandCollection(
      List<DemandData> z, Position pos) async {
    List<DemandData> ldemands = [];
    for (DemandData x in z) {
      GeoLocatorService()
          .getDistance(pos.latitude, pos.longitude, x.lat!, x.long!)
          .then((value) {
        if (value <= 300000) {
          ldemands.add(x);
        }
      });
    }
    return ldemands;
  }
}
