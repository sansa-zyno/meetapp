import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  LocationPermission? permission;

  Future<Position> getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<double> getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
