
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget{
  const AddProduct({super.key});

  @override
  State<StatefulWidget> createState()=>Product();
}
class Product extends State<AddProduct>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }

}