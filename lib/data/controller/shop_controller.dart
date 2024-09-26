import 'package:get/get.dart';
import 'package:gully_app/data/model/vendor_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
import 'package:image_picker/image_picker.dart';


class ShopController extends GetxController {

  Rx<vendor_model?> vendor=Rx<vendor_model?>(null);
  Rx<shop_model?> shop=Rx<shop_model?>(null);
  RxList sociallinks=[].obs;
  Rx<XFile?> vendorDocumentImage = Rx<XFile?>(null);

  void updateVendorDetails(vendor_model vendorData) {
    vendor.value = vendorData;
  }

  void updateShopDetails(shop_model shopData) {
    shop.value = shopData;
  }
  void updateVendorDocumentImage(XFile? image) {
    vendorDocumentImage.value = image;
  }
  vendor_model? getVendorDetails() {
    return vendor.value;
  }

  XFile? getVendorDocumentImage() {
    return vendorDocumentImage.value;
  }
  void resetAllData() {
    vendor.value=null;
    vendorDocumentImage.value=null;
  }
}
