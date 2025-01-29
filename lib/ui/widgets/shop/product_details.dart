
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_logger.dart';
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
         ElevatedButton(onPressed: ()async {
           final result = await Get.to(() => const AddProduct());
           if (result != null && result is List<Map<String, dynamic>>) {

           }

         }, child: const Text("Add Product"))
       ],
     ),
   );
  }
}