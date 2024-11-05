import 'dart:convert';
import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../api/service_api.dart';

class ServiceController extends GetxController with StateMixin<ServiceModel> {
  final ServiceApi serviceApi;
  ServiceController({required this.serviceApi}) {
    // getCurrentLocation();
    // Geolocator.getServiceStatusStream().listen((event) {
    //   getCurrentLocation();
    // });
    change(GetStatus.empty());
  }
  // Rx<ServiceModel?> service = Rx<ServiceModel?>(null);
  RxList<ServiceModel> servicelist = <ServiceModel>[].obs;
  //
  // final RxList<String> selectedServices = <String>[].obs;
  // final RxList<XFile> images = <XFile>[].obs;
  // final RxList<XFile> documentImages = <XFile>[].obs;
  // final Rx<LatLng?> location = Rx<LatLng?>(null);
  // final Rx<Map<String, dynamic>?> selectedPackage = Rx<Map<String, dynamic>?>(null);
  // RxString error = ''.obs;
  RxBool isLoading = false.obs;

  Future<ServiceModel> addService(Map<String,dynamic> service) async{
    try{
      final response=await serviceApi.addService(service);
      return ServiceModel.fromJson(response.data!);
    }catch(e){
      logger.e('Error registering service: $e');
      rethrow;
    }
  }

  Future<List<ServiceModel>> getVendors() async {
    try {
      final response = await serviceApi.getService();
      logger.d('Raw API Response: ${response.data}');

      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to fetch vendors');
        return [];
      }
      if (response.data != null) {
        final vendors = (response.data as List)
            .map((service) => ServiceModel.fromJson(service))
            .toList();

        logger.d('Parsed Vendors Count: ${vendors.length}');
        servicelist.value = vendors;
        return vendors;
      } else {
        logger.d('No vendors data received');
        servicelist.clear();
        return [];
      }
    } catch (e) {
      logger.e('Error getting vendors: $e');
      errorSnackBar('Unable to fetch vendors. Please try again later.');
      return [];
    }
  }
}