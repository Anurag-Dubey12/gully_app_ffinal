import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationScreenController extends GetxController {
  final TextEditingController _yourLoaction = TextEditingController();
  final RxList<Marker> _marker = <Marker>[].obs;
  final Completer<GoogleMapController> _controller = Completer();
  final RxInt _chipSelectedIndex = 0.obs;

  //* Getters
  TextEditingController get yourLocationController => _yourLoaction;
  RxList<Marker> get markers => _marker;
  Completer<GoogleMapController> get mapController => _controller;
  RxInt get chipSelectedIndex => _chipSelectedIndex;

  //* MARK:- select Chip
  void selectChip(int index) {
    _chipSelectedIndex.value = index;
  }

  //* MARK:- Get user location
  Future<void> getUserLocation() async {
    try {
      final location = await LocationService().getUserCurrentLocation();
      final latLng = LatLng(location.latitude, location.longitude);

      await updateMarkerAndAddress(latLng);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  //* MARK:- Search and update location from address
  Future<void> searchLocation() async {
    if (_yourLoaction.text.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(_yourLoaction.text);
      if (locations.isNotEmpty) {
        final newLatLng =
            LatLng(locations.first.latitude, locations.first.longitude);

        await updateMarkerAndAddress(newLatLng);
      }
    } catch (e) {
      print("Error finding location: $e");
    }
  }

  //* MARK:- Update marker and address
  Future<void> updateMarkerAndAddress(LatLng latLng) async {
    final address =
        await _getAddressFromLatLng(latLng.latitude, latLng.longitude);
    _yourLoaction.text = address;
    _marker.clear();
    _marker.add(
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: latLng,
        infoWindow: const InfoWindow(title: "Selected Location"),
      ),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 14),
    ));
  }

  //* MARK:- Convert LatLng to Address using Geocoding
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String address = [
          if (place.street?.isNotEmpty ?? false) place.street,
          if (place.subLocality?.isNotEmpty ?? false) place.subLocality,
          if (place.locality?.isNotEmpty ?? false) place.locality,
          if (place.administrativeArea?.isNotEmpty ?? false)
            place.administrativeArea,
          if (place.country?.isNotEmpty ?? false) place.country,
          if (place.postalCode?.isNotEmpty ?? false) place.postalCode,
        ].join(", ");

        return address;
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Unknown Location";
    }
  }
}

class LocationService {
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stacktrace) async {
      await Geolocator.requestPermission();
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
