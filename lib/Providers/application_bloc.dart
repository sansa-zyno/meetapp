import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meeter/Model/place.dart';
import 'package:meeter/Services/geolocator_service.dart';
import 'package:meeter/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeoLocatorService();
  final placesService = PlacesService();

  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();

  late Position currentLocation;
  List? searchResults;
  StreamController? selectedLocation = StreamController.broadcast();
  late List<Place> placeResults;

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation!.add(sLocation);
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation!.add(null);
    searchResults = null;
    notifyListeners();
  }

  void dispose() {
    searchResults = null;
    notifyListeners();
    if (selectedLocation != null) {
      selectedLocation!.close();
    }
    super.dispose();
  }
}
