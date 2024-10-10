
import 'dart:convert';

import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_logger.dart';
class ServiceController extends GetxController with StateMixin{

  Rx<ServiceModel?> service=Rx<ServiceModel?>(null);
  RxList<ServiceModel> servicelist = <ServiceModel>[].obs;


  void addShop(ServiceModel services) {
    servicelist.add(services);
    // saveShopData();
  }
  void resetAllData() {
    service.value=null;
  }

  //Shared preferences
  Future<void> saveServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('serviceList', jsonEncode(servicelist.map((s) => s.toJson()).toList()));
    logger.d('The Service data is saved');
  }

  Future<void> loadServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('serviceList');
    if (data!= null) {
      servicelist.clear();
      servicelist.addAll(jsonDecode(data).map((json) => ServiceModel.fromJson(json)));
    }
  }
  void removeService(ServiceModel services) {
    servicelist.remove(services);
    saveServiceData();
  }

}