import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/shop/categorySelection.dart';
import 'package:gully_app/ui/widgets/shop/itemSelectedField.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/image_picker_helper.dart';
import '../../../widgets/create_tournament/form_input.dart';
import '../../../widgets/primary_button.dart';

class AddProduct extends StatefulWidget {
  final ProductModel? product;
  const AddProduct({super.key, this.product});

  @override
  State<StatefulWidget> createState() => Product();
}

class Product extends State<AddProduct> {
  final TextEditingController productdescriptionController =
      TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productpriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<XFile> productImage = [];

  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedBrand;

  final controller = Get.find<ShopController>();
  bool? isDialogshown;

  bool isDiscount = false;
  @override
  void initState() {
    super.initState();
    isDialogshown = false;
    if (widget.product != null) {
      productName.text = widget.product!.productName;
      productdescriptionController.text =
          widget.product!.productsDescription ?? '';
      productpriceController.text = widget.product!.productsPrice.toString();
      selectedCategory = widget.product!.productCategory;
      selectedSubcategory = widget.product!.productSubCategory;
      selectedBrand = widget.product!.productBrand;
      // productImage = widget.product.productsImage.;
    }
    controller.getCategory();
    controller.getbrands();
  }

  pickImages() async {
    final imgs = await multipleimagePickerHelper();

    if (imgs != null && imgs.isNotEmpty) {
      setState(() {
        productImage.addAll(imgs.whereType<XFile>());
      });
    }
  }

  Future<String?> showSelectionBottomSheet(BuildContext context,
      List<String> items, String title, String? currentSelection) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CategorySelection(
          items: items,
          title: title,
          currentSelection: currentSelection,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: widget.product != null
                ? const Text(
                    'Edit Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : const Text(
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
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.product == null
                    ? Expanded(
                        child: PrimaryButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  title: Row(
                                    children: [
                                      const Icon(Icons.add_circle_rounded,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Add More Product",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.info_outline_rounded,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Your current product has been saved. The new product will be added under the same category. You can change the category if needed.",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[800],
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.tune_rounded,
                                          color: Colors.deepPurple),
                                      label: const Text(
                                        "Change Category",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    FilledButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                          Icons.check_circle_rounded),
                                      label: const Text("OK"),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          title: 'Add More Product',
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.product == null
                    ? const SizedBox(width: 16)
                    : const SizedBox.shrink(),
                Expanded(
                  child: PrimaryButton(
                    onTap: () async {
                      try {
                        List<String> productbase64Image = [];
                        for (XFile images in productImage) {
                          String converImage =
                              await convertImageToBase64(images);
                          productbase64Image.add(converImage);
                        }
                        Map<String, dynamic> product = {
                          "productsImage": productbase64Image,
                          "productName": productName.text,
                          "productsDescription":
                              productdescriptionController.text,
                          "productsPrice": productpriceController.text,
                          "productCategory": selectedCategory,
                          "productSubCategory": selectedSubcategory,
                          "productBrand": selectedBrand,
                          "shopId": "67ea8204d3eaae65cdc7a455"
                        };
                        if (widget.product != null) {
                        } else {
                          bool isOk = await controller.addShopProduct(product);
                          if (isOk) {
                            Get.snackbar(
                              'Yayy',
                              AppConstants.productaddedsuccessfully,
                              snackPosition: SnackPosition.top,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(12),
                              borderRadius: 8,
                            );
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    title: 'Save Product',
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Product Images",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        productImage.isEmpty
                            ? GestureDetector(
                                onTap: pickImages,
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[50],
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Add Product Images",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : widget.product != null
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount:
                                        widget.product!.productsImage!.length +
                                            1,
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          widget
                                              .product!.productsImage!.length) {
                                        return GestureDetector(
                                          onTap: pickImages,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ),
                                          ),
                                        );
                                      }
                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              imageViewer(
                                                  context,
                                                  productImage[index].path,
                                                  false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.network(
                                                toImageUrl(widget.product!
                                                    .productsImage![index]),
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/logo.png',
                                                      fit: BoxFit.cover);
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 5,
                                            top: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  productImage.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: productImage.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == productImage.length) {
                                        return GestureDetector(
                                          onTap: pickImages,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ),
                                          ),
                                        );
                                      }
                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              imageViewer(
                                                  context,
                                                  productImage[index].path,
                                                  false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: FileImage(File(
                                                      productImage[index]
                                                          .path)),
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
                                                  productImage.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 14,
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
                  FormInput(
                    iswhite: false,
                    controller: productName,
                    label: "Product Name",
                    textInputType: TextInputType.text,
                  ),
                  FormInput(
                    iswhite: false,
                    controller: productdescriptionController,
                    label: "Product Short Description",
                    textInputType: TextInputType.multiline,
                  ),
                  Text("Product Category ",
                      style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16)),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final selected = await showSelectionBottomSheet(
                            context,
                            controller.category,
                            "Category",
                            selectedCategory,
                          );
                          if (selected != null) {
                            controller.getsubCategory(selected);
                            setState(() {
                              selectedCategory = selected;
                              selectedSubcategory = null;
                            });
                          }
                        },
                        child: itemselectedField(
                          title: "Category",
                          value: selectedCategory,
                          placeholder: "Select Category",
                          icon: Icons.category_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: selectedCategory == null
                            ? () {
                                Get.snackbar(
                                  'Oops',
                                  AppConstants.selectproductcategory,
                                  snackPosition: SnackPosition.top,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(12),
                                  borderRadius: 8,
                                );
                              }
                            : () async {
                                final selected = await showSelectionBottomSheet(
                                  context,
                                  controller.subcategory,
                                  "Subcategory",
                                  selectedSubcategory,
                                );
                                if (selected != null) {
                                  setState(() {
                                    selectedSubcategory = selected;
                                  });
                                }
                              },
                        child: Opacity(
                          opacity: selectedCategory == null ? 0.6 : 1.0,
                          child: itemselectedField(
                            title: "Subcategory",
                            value: selectedSubcategory,
                            placeholder: "Select Subcategory",
                            icon: Icons.label_outline,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final selected = await showSelectionBottomSheet(
                            context,
                            controller.brands,
                            "Brand",
                            selectedBrand,
                          );
                          if (selected != null) {
                            setState(() {
                              selectedBrand = selected;
                            });
                          }
                        },
                        child: itemselectedField(
                          title: "Brand",
                          value: selectedBrand,
                          placeholder: "Select Brand",
                          icon: Icons.business_outlined,
                          color: Colors.teal[600],
                        ),
                      ),
                    ],
                  ),
                  FormInput(
                    iswhite: false,
                    controller: productpriceController,
                    label: "Product Price",
                    textInputType: TextInputType.text,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Is there any discount?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "No",
                            style: TextStyle(fontSize: 15),
                          ),
                          Switch.adaptive(
                            value: isDiscount,
                            onChanged: (value) {
                              setState(() {
                                isDiscount = value;
                              });
                            },
                          ),
                          const Text(
                            "Yes",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isDiscount)
                    FormInput(
                      iswhite: false,
                      controller: _discountController,
                      label: "Discount (%)",
                      textInputType: TextInputType.number,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
