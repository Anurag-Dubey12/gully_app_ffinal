import 'dart:convert';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/app_logger.dart';

class ServiceController extends GetxController with StateMixin {
  Rx<ServiceModel?> service = Rx<ServiceModel?>(null);
  RxList<ServiceModel> servicelist = <ServiceModel>[].obs;

  final RxList<String> selectedServices = <String>[].obs;
  final RxList<XFile> images = <XFile>[].obs;
  final RxList<XFile> documentImages = <XFile>[].obs;
  final Rx<LatLng?> location = Rx<LatLng?>(null);
  final Rx<Map<String, dynamic>?> selectedPackage = Rx<Map<String, dynamic>?>(null);




  void addService(ServiceModel service) {
    servicelist.add(service);
    saveServiceData();
  }

  Future<void> saveServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('serviceList', jsonEncode(servicelist.map((s) => s.toJson()).toList()));
    logger.d('The Service data is saved and the service list is ${servicelist.map((s) => s.toJson()).toList()}');
  }

  Future<void> loadServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('serviceList');
    if (data != null) {
      servicelist.add(jsonDecode(data).map<ServiceModel>((json) => ServiceModel.fromJson(json)).toList());
      logger.d('The Service data is loaded and the service list is ${servicelist.map((s) => s.toJson()).toList()}');
    }
  }

  void removeService(ServiceModel service) {
    servicelist.remove(service);
    saveServiceData();
  }

  void updateSelectedServices(List<String> services) {
    selectedServices.value = services;
  }

  void addImages(List<XFile> newImages) {
    images.addAll(newImages);
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void addDocumentImages(List<XFile> newDocImages) {
    documentImages.addAll(newDocImages);
  }

  void removeDocumentImage(int index) {
    documentImages.removeAt(index);
  }

  void updateLocation(LatLng newLocation) {
    location.value = newLocation;
  }

  void updateSelectedPackage(Map<String, dynamic> package) {
    selectedPackage.value = package;
  }

  void resetAllData() {
    service.value = null;
    selectedServices.clear();
    images.clear();
    documentImages.clear();
    location.value = null;
    selectedPackage.value = null;
  }
}