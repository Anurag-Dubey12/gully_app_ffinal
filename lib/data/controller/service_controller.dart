import 'package:get/get.dart';
import 'package:gully_app/data/model/service_model.dart';

import '../../utils/app_logger.dart';
import '../../utils/utils.dart';
import '../api/service_api.dart';

class ServiceController extends GetxController with StateMixin<ServiceModel> {
  final ServiceApi serviceApi;
  ServiceController({required this.serviceApi}) {
    change(GetStatus.empty());
  }

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

  RxList<ServiceModel> service = <ServiceModel>[].obs;

  Future<List<ServiceModel>> getService() async {
    try {
      final response = await serviceApi.getService();
      logger.d('controller API Response: ${response.data}');
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to fetch vendors');
        return [];
      }
      service.value=(response.data!['vendors'] as List)
      .map((e)=>ServiceModel.fromJson(e)).toList();
      logger.d("The Service list is :${service.length}");
      return service;
    } catch (e) {
      logger.e('Error getting vendors: $e');
      errorSnackBar('Unable to fetch vendors. Please try again later.');
      return [];
    }
  }

  Future<bool> updateservice(String serviceId,Map<String,dynamic> service)
  async{
    try {
      final response = await serviceApi.updateService(serviceId, service);
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to update service');
        return false;
      }
      return true;
    }catch(e){
      logger.e('Error updating service: $e');
      rethrow;
    }
  }
  Future<bool> deleteService(String serviceId,)
  async{
    try {
      final response = await serviceApi.deleteService(serviceId);
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to update service');
        return false;
      }
      return true;
    }catch(e){
      logger.e('Error updating service: $e');
      rethrow;
    }
  }

}