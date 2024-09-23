
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../../screens/shop/add_product.dart';

class ProductDetails extends StatefulWidget{
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  const ProductDetails({Key? key, required this.formKey, required this.formData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Product();
}
class Product extends State<ProductDetails>{
  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.all(8.0),
     child: Column(
       children: [
         ElevatedButton(onPressed: (){
           final result=Get.to(()=>const AddProduct());

         }, child: Text("Add Product"))
       ],
     ),
   );
  }
}