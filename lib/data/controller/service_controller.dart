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
  RxList<ServiceModel> servicelist = <ServiceModel>[].obs;

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

  Future<List<ServiceModel>> getService() async {
    try {
      final response = await serviceApi.getService();
      if (response.status == false) {
        logger.i('Error: ${response.message}');
        errorSnackBar(response.message ?? 'Unable to fetch vendors');
        return [];
      }
     final List<ServiceModel> service = (response.data as List<dynamic>?)
            ?.map((service) =>
            ServiceModel.fromJson(service ))
            .toList() ?? [];
      servicelist.addAll(service);
      logger.d("The Service list is :${servicelist.length}");
      return servicelist;
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