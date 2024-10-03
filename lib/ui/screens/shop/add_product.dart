
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/ui/widgets/custom_drop_down_field.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../theme/theme.dart';
import '../../widgets/create_tournament/form_input.dart';
import '../../widgets/primary_button.dart';

class AddProduct extends StatefulWidget{
  final Map<String,dynamic>? product;
  const AddProduct({super.key,this.product});

  @override
  State<StatefulWidget> createState()=>Product();
}
class Product extends State<AddProduct>{
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _Product_name = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<XFile> _product_image = [];

  final Map<String, List<String>> _categories = {
    'Cricket': ['Bat', 'Ball', 'T-shirt', 'Shorts', 'Boots', 'Wickets', 'Helmet', 'Gloves', 'Cap', 'Arm Guard'],
    'Soccer': ['Football', 'Goal Net', 'Jersey', 'Shorts', 'Cleats', 'Shin Guards', 'Socks', 'Water Bottle'],
    'Basketball': ['Basketball', 'Hoop', 'Jersey', 'Shorts', 'Sneakers', 'Headband'],
    'Tennis': ['Tennis Racket', 'Tennis Ball', 'T-shirt', 'Shorts/Skirt', 'Tennis Shoes', 'Wristbands', 'Visor'],
    'Swimming': ['Goggles', 'Swimming Cap', 'Swimsuit', 'Towel', 'Flip-flops', 'Kickboard'],
    'Running': ['Running Shorts', 'Running Shirt', 'Running Shoes', 'Sweatband', 'Hydration Belt', 'GPS Watch'],
    'Badminton': ['Shuttlecock', 'Badminton Racket', 'T-shirt', 'Shorts', 'Indoor Shoes'],
    'Baseball': ['Baseball Bat', 'Baseball Glove', 'Cap', 'Jersey', 'Cleats', 'Baseball', 'Helmet', 'Base'],
    'Golf': ['Golf Club', 'Golf Ball', 'Golf Cap', 'Golf Shoes', 'Golf Bag', 'Tee', 'Glove'],
    'Hockey': ['Hockey Stick', 'Hockey Ball', 'Jersey', 'Shorts', 'Shoes', 'Shin Guards'],
    'Football': ['Football', 'Football Boots', 'Goalkeeper Gloves', 'Shin Guards', 'Socks', 'Jerseys', 'Shorts', 'Goalkeeper Jersey', 'Cones', 'Training Bibs', 'Nets', 'Goal Posts', 'Pumps', 'Bags', 'Corner Flags', 'Whistles', 'Captain Armbands', 'Kit Bag', 'Agility Ladders', 'Speed Hurdles', 'Water Bottles', 'Training Balls', 'Medical Kit', 'Coaching Clipboard', 'Marker Discs'],
  };
  final List<Map<String, dynamic>> _addedProducts = [];

  String? selectedCategory;
  String? _selected_subcategory;
  int _productIdCounter = 1;

  @override
  void initState() {
    super.initState();
    if(widget.product!=null) {
      final product = widget.product!;
      _Product_name.text = product['name'] ?? '';
      _descriptionController.text = product['description'] ?? '';
      _priceController.text = product['price']?.toString() ?? '';
      _discountController.text = product['discount']?.toString() ?? '';
      selectedCategory = product['category'];
      _selected_subcategory = product['subcategory'];
      _product_image = (product['images'] as List<dynamic>?)
          ?.map((path) => XFile(path))
          .toList() ?? [];
    }
  }

  String _generateProductId() {
    String id = _productIdCounter.toString().padLeft(4, '0');
    _productIdCounter++;
    return id;
  }
  pickImages() async {
    final imgs = await multipleimagePickerHelper();

    if (imgs != null && imgs.isNotEmpty) {
      setState(() {
        _product_image.addAll(imgs.whereType<XFile>());
      });
    }
  }

  bool validatedCurrentProduct(){
    if (selectedCategory == null || _selected_subcategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and subcategory')),
      );
      return false;
    }
    if (_descriptionController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return false;
    }
    return true;
  }

  Map<String,dynamic> _getCurrentProductDetails(){
    return{
      'id': _generateProductId(),
      'name':_Product_name.text,
      'category': selectedCategory,
      'subcategory': _selected_subcategory,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'discount': _discountController.text,
      'images': _product_image.map((image) => image.path).toList(),
    };
  }
  void _resetform() {
    setState(() {
      _Product_name.clear();
      _descriptionController.clear();
      _priceController.clear();
      _discountController.clear();
      _product_image.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> subcategories = selectedCategory != null ? _categories[selectedCategory!]! : [];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          title: widget.product!=null ? Text(
            'Edit Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ):Text(
            'Add Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.product==null?
              Expanded(
                child: PrimaryButton(
                  onTap: (){
                    if(validatedCurrentProduct()){
                      setState(() {
                        _addedProducts.add(_getCurrentProductDetails());
                        _resetform();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product Saved. Total products: ${_addedProducts.length}')),
                      );
                    }
                  },
                  title: 'Add More Product',
                ),
              ):const SizedBox.shrink(),
              widget.product==null ?
              const SizedBox(width: 16):const SizedBox.shrink(),
              Expanded(
                child: PrimaryButton(
                  onTap: () async {
                    if(validatedCurrentProduct()){
                      _addedProducts.add(_getCurrentProductDetails());
                      for (var product in _addedProducts) {
                        logger.d("The total product are:$product");
                      }
                      widget.product==null ?Get.back(result: _addedProducts):Get.back(result: _addedProducts);
                    }else{
                      logger.d("Caught some error");
                    }
                  },
                  title:'Submit',
                ),
              ),
            ],
          ),
        ),
        body:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: Get.height,
            color: Colors.black26,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormInput(
                  controller: _Product_name,
                  label: "Product Name",
                  textInputType: TextInputType.text,
                ),
                const Text("Select The Product Category"),
                DropDownWidget(
                    onSelect: (value){
                      setState(() {
                        selectedCategory = value;
                        _selected_subcategory = null;
                      });
                    },
                    selectedValue: selectedCategory,
                    items: _categories.keys.toList(),
                    title: "Select The Product Category",
                    isAds: false),
                const SizedBox(height: 10),
                selectedCategory!=null ? const Text("Select The Product Sub Category") :const SizedBox.shrink(),
                if(selectedCategory!=null)
                  DropDownWidget(
                    key: UniqueKey(),
                      onSelect:(value){
                        setState(() {
                          _selected_subcategory = value;
                        });
                      },
                      selectedValue:_selected_subcategory,
                      items: subcategories,
                      title: "Sub Category of a Product",
                      isAds: false),
                FormInput(
                  controller: _descriptionController,
                  label: "Product Short Description",
                  textInputType: TextInputType.multiline,
                ),
                FormInput(
                  controller: _priceController,
                  label: "Product Price",
                  textInputType: TextInputType.text,
                ),
                FormInput(
                  controller: _discountController,
                  label: "Discount(if any)",
                  textInputType: TextInputType.number,
                ),
                const Text("Product Image"),
                const SizedBox(height: 10),
                _product_image.isEmpty ? Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: pickImages,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.black,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Select Images of the service",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ): GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _product_image.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _product_image.length) {
                      return GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey[600],
                            size: 40,
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            imageViewer(context, _product_image[index].path, false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(_product_image[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _product_image.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}