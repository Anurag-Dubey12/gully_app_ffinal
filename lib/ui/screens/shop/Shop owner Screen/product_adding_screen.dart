import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/model/product_model.dart';
import 'package:gully_app/data/model/shop_model.dart';
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
  final ShopModel? shop;
  final VoidCallbackAction? onProductAdded;
  const AddProduct({super.key, this.product, this.shop, this.onProductAdded});

  @override
  State<StatefulWidget> createState() => Product();
}

class Product extends State<AddProduct> {
  final TextEditingController productdescriptionController =
      TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productpriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<dynamic> productImage = [];

  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedBrand;
  final _formKeys = GlobalKey<FormState>();
  final controller = Get.find<ShopController>();
  bool? isDialogshown;
  bool isDiscount = false;
  bool isImageEditDone = false;
  bool isuploaded = false;
  final misccontroller = Get.find<MiscController>();

  @override
  void initState() {
    super.initState();
    isDialogshown = false;
    if (widget.product != null) {
      getproductData();
    }
    controller.getCategory();
    controller.getbrands();
  }

  Future<void> getproductData() async {
    productName.text = widget.product!.productName;
    productdescriptionController.text =
        widget.product!.productsDescription ?? '';
    productpriceController.text = widget.product!.productsPrice.toString();
    selectedCategory = widget.product!.productCategory;
    selectedSubcategory = widget.product!.productSubCategory;
    selectedBrand = widget.product!.productBrand;
    isDiscount =
        widget.product!.productDiscount!.discountType == 'fixed' ? false : true;
    _discountController.text =
        widget.product!.productDiscount!.discountType == 'fixed'
            ? '0'
            : widget.product!.productDiscount!.discountPrice.toString();
    // productImage = widget.product!.productsImage ?? [];
    if (widget.product!.productsImage != null) {
      productImage = List.from(widget.product!.productsImage!);
    }
    await misccontroller.getPackagebyId(controller.shop.value!.package!.id);
  }

  pickImages() async {
    final imgs = await multipleimagePickerHelper();

    if (imgs != null && imgs.isNotEmpty) {
      setState(() {
        productImage.addAll(imgs);
        if (kDebugMode) {
          print("Find Added image:$imgs");
        }
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
    final product = widget.product;
    final totalEditDone = controller.shop.value?.totalEditDone ?? 0;
    final editLimit = misccontroller.packageLimit.value;
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
                      final BuildContext dialogContext = context;
                      try {
                        if (_formKeys.currentState!.validate()) {
                          showDialog(
                            context: dialogContext,
                            barrierDismissible: false,
                            builder: (_) => const UploadingDialog(),
                          );
                          List<String> productbase64Image = [];
                          for (dynamic image in productImage) {
                            if (image is XFile) {
                              String base64Image =
                                  await convertImageToBase64(image);
                              if (widget.product != null) {
                                isImageEditDone = true;
                              }
                              productbase64Image.add(base64Image);
                            } else if (image is String) {
                              productbase64Image.add(image);
                            }
                          }

                          Map<String, dynamic> product = {
                            if (widget.product != null)
                              "productId": widget.product!.id,
                            if (widget.product != null)
                              "isImageEditDone": isImageEditDone,
                            "productsImage": productbase64Image,
                            "productName": productName.text,
                            "productsDescription":
                                productdescriptionController.text,
                            "productsPrice": productpriceController.text,
                            "productCategory": selectedCategory,
                            "productSubCategory": selectedSubcategory,
                            "productBrand": selectedBrand,
                            if (widget.product == null)
                              "shopId": widget.shop?.id,
                            "discounttype": isDiscount ? "percent" : "fixed",
                            "discountedvalue": isDiscount
                                ? int.parse(_discountController.text)
                                : 0
                          };
                          if (widget.product != null) {
                            bool isOk = await controller.editProduct(product);
                            // if (Navigator.canPop(dialogContext)) {
                            //   Navigator.of(dialogContext).pop();
                            // }
                            if (isOk) {
                              if (isImageEditDone) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => WillPopScope(
                                    onWillPop: () async => false,
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: Colors.blueAccent),
                                          SizedBox(width: 8),
                                          Text(
                                            "Heads Up!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "You're editing an image. This will use 1 image edit from your remaining limit.",
                                            style: TextStyle(
                                                fontSize: 16, height: 1.4),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Edits left: ${misccontroller.packageLimit.value - controller.shop.value!.totalEditDone}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            successSnackBar(
                                              AppConstants
                                                  .producteditedsuccessfully,
                                            ).then(
                                              (value) => Get.back(),
                                            );
                                            await controller
                                                .getProduct(widget.product!.id);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                          ),
                                          child: const Text("Continue"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                successSnackBar(
                                  AppConstants.producteditedsuccessfully,
                                ).then(
                                  (value) => Get.back(),
                                );
                                await controller.getProduct(widget.product!.id);
                              }
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to add product. Please try again.',
                                snackPosition: SnackPosition.top,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(12),
                                borderRadius: 8,
                              );
                            }
                          } else {
                            bool isOk =
                                await controller.addShopProduct(product);
                            if (Navigator.canPop(dialogContext)) {
                              Navigator.of(dialogContext).pop();
                            }
                            if (isOk) {
                              Get.snackbar(
                                'Success',
                                AppConstants.productaddedsuccessfully,
                                snackPosition: SnackPosition.top,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(12),
                                borderRadius: 8,
                              );
                              Navigator.pop(context, {'IsDone': true});
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to add product. Please try again.',
                                snackPosition: SnackPosition.top,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(12),
                                borderRadius: 8,
                              );
                            }
                          }
                        }
                      } catch (e) {
                        if (kDebugMode) print(e);
                        if (Navigator.canPop(dialogContext)) {
                          Navigator.of(dialogContext).pop();
                        }
                        Get.snackbar(
                          'Error',
                          'An unexpected error occurred. Please try again.',
                          snackPosition: SnackPosition.top,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(12),
                          borderRadius: 8,
                        );
                      } finally {
                        isuploaded = false;
                      }
                    },
                    title: widget.product != null
                        ? 'Edit Product'
                        : 'Save Product',
                  ),
                )
              ],
            ),
          ),
          body: Form(
            key: _formKeys,
            child: SingleChildScrollView(
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
                              : SizedBox(
                                  height: 250,
                                  child: PageView.builder(
                                    controller:
                                        PageController(viewportFraction: 0.85),
                                    itemCount: productImage.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == productImage.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (product != null) {
                                              if (totalEditDone >= editLimit) {
                                                errorSnackBar(
                                                    "Your image edit limit has been reached.");
                                              } else {
                                                pickImages();
                                              }
                                            } else {
                                              pickImages();
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                              color: Colors.grey[100],
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add_photo_alternate,
                                                color: Colors.blue,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final image = productImage[index];
                                      final isNetworkImage = image is String;

                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (isNetworkImage) {
                                                imageViewer(
                                                    context, image, true);
                                              } else {
                                                imageViewer(
                                                    context,
                                                    (image as XFile).path,
                                                    false);
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: isNetworkImage
                                                      ? NetworkImage(
                                                              toImageUrl(image))
                                                          as ImageProvider
                                                      : FileImage(File(
                                                          (image as XFile)
                                                              .path)),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 15,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (product != null) {
                                                  if (totalEditDone <
                                                      editLimit) {
                                                    setState(() {
                                                      productImage
                                                          .removeAt(index);
                                                    });
                                                  } else {
                                                    errorSnackBar(
                                                        "Your image edit limit has been reached.");
                                                  }
                                                } else {
                                                  setState(() {
                                                    productImage
                                                        .removeAt(index);
                                                  });
                                                }
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
                                ),
                        ],
                      ),
                    ),
                    FormInput(
                      iswhite: false,
                      controller: productName,
                      label: "Product Name",
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Product name is required';
                        }
                        final regex = RegExp(r'[^a-zA-Z0-9\s]');
                        if (regex.hasMatch(value)) {
                          return 'No special characters or emojis allowed';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      iswhite: false,
                      controller: productdescriptionController,
                      label: "Product Short Description",
                      textInputType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        final regex = RegExp(r'[^a-zA-Z0-9\s.,-]');
                        if (regex.hasMatch(value)) {
                          return 'No emojis or disallowed special characters';
                        }
                        return null;
                      },
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
                                  final selected =
                                      await showSelectionBottomSheet(
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
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Product price is required';
                        }

                        final regex = RegExp(r'^\d+(\.\d{1,2})?$');

                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid price (numbers only, up to 2 decimals)';
                        }

                        return null;
                      },
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
                        label: "Discount (In Rupees)",
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Discount is required';
                          }
                          final num? discount = num.tryParse(value);
                          if (discount == null) {
                            return 'Enter a valid number';
                          }
                          if (discount < 0) {
                            return 'Discount cannot be negative';
                          }
                          return null;
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UploadingDialog extends StatefulWidget {
  const UploadingDialog({super.key});

  @override
  State<UploadingDialog> createState() => _UploadingDialogState();
}

class _UploadingDialogState extends State<UploadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                strokeWidth: 3.5,
              ),
              SizedBox(height: 24),
              Text(
                "Uploading Product...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Please wait while we upload your product details.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
