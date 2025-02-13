import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/service_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import '../../../data/controller/auth_controller.dart';
import '../../../data/controller/service_controller.dart';
import '../../../data/controller/service_controller.dart';
import '../../../data/model/package_model.dart';
import '../../../data/model/service_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/geo_locator_helper.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../../widgets/create_tournament/form_input.dart';
import '../../widgets/custom_drop_down_field.dart';
import '../../widgets/primary_button.dart';
import '../legal_screen.dart';
import '../select_location.dart';
import '../service_payment_page.dart';

class ServiceRegister extends StatefulWidget {
  final ServiceModel? service;
  const ServiceRegister({super.key,this.service});

  @override
  State<StatefulWidget> createState() => RegisterService();
}

class RegisterService extends State<ServiceRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _serviceChargesController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // List<String> selectedServices = [];
  String selectedServices='';
  bool isLoading = false;
  bool tncAccepted = false;
  String selectedOnlineOption = 'no';
  String selectedDuration = 'per_hour';
  final _key = GlobalKey<FormState>();
  final List<XFile> _images = [];
  LatLng? location;
  String? charges_durations = '';
  String? package_duration = '';
  bool isOnline=false;
  Map<String, dynamic>? Duration;
  // String Duration='';


  Map<String, dynamic>? selectedPackage;
  // List<XFile> _documentImages = [];
  XFile? _documentImages ;
  late  ServiceModel serviceModel;

  void pickImages() async {
    final imgs = await multipleimagePickerHelper();
    if (imgs != null && imgs.isNotEmpty) {
      setState(() {
        _images.addAll(imgs.whereType<XFile>());
      });
    }
  }
  pickDocumentImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);

    if (images != null) {
      setState(() {
        _documentImages=images;
      });
    }
  }
  Future<void> fetchLocation() async {
    try {
      final position = await determinePosition();
      setState(() {
        location = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      logger.e('Error fetching location: $e');
      errorSnackBar('Failed to fetch location. Please try again.',
          title: "Error");
    }
  }

  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    _nameController.text = authController.state!.fullName;
    if (widget.service != null) {
      _nameController.text = widget.service!.name;
      _descriptionController.text = widget.service!.description;
      _serviceChargesController.text = widget.service!.fees.toString();
      _expController.text = widget.service!.experience.toString();
      _addressController.text = widget.service!.address ?? '';
      selectedServices = widget.service!.category;
      isOnline = widget.service!.serviceType == "online";
      // if (widget.service!.servicePackage != null) {
      //   selectedPackage = {
      //     'package': widget.service!.servicePackage!.name,
      //     'Duration': widget.service!.servicePackage!.duration,
      //     'price': widget.service!.servicePackage!.price,
      //     'EndDate': widget.service!.servicePackage!.endDate,
      //   };
      // }
      if (widget.service!.serviceImages != null &&
          widget.service!.serviceImages!.isNotEmpty) {
        for (var imagePath in widget.service!.serviceImages!) {
          _images.add(XFile(imagePath));
        }
      }

      _documentImages = XFile(widget.service!.identityProof!);
        }

  }
  List<String> cricketServices = [
    "Football Coaching", "Basketball Coaching", "Cricket Coaching", "Tennis Coaching",
    "Badminton Coaching", "Volleyball Coaching", "Table Tennis Coaching", "Rugby Coaching",
    "Hockey Coaching", "Squash Coaching", "Golf Coaching", "Baseball Coaching",
    "Softball Coaching", "Lacrosse Coaching", "Field Hockey Coaching", "Handball Coaching",
    "Netball Coaching", "Archery Coaching", "Fencing Coaching", "Wrestling Coaching"
  ];
  List<String> duration = [
    "Hours","Days","Months"
  ];
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ServiceController serviceController = Get.find<ServiceController>();
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
              title: Text(
                widget.service!=null? 'Edit Service':'Register Service',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 70,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, -1))
              ]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                      onTap: () async {
                        try {
                          if (!tncAccepted) {
                            throw Exception('Please accept the Terms and Conditions');
                          }
                          if (_images.isEmpty) {
                            throw Exception('Please select at least one image of your service');
                          }
                          if (_descriptionController.text.isEmpty) {
                            throw Exception('Please enter a description');
                          }
                          if (_expController.text.isEmpty) {
                            throw Exception('Please enter experience');
                          }
                          if (_documentImages == null) {
                            throw Exception('Please add document images');
                          }

                          // Convert images to Base64
                          List<String> serviceImagesBase64 = [];
                          for (var image in _images) {
                            String? base64Image = await convertImageToBase64(image);
                            serviceImagesBase64.add(base64Image);
                                                    }

                          String? identityProofBase64;
                          if (_documentImages != null) {
                            identityProofBase64 = await convertImageToBase64(_documentImages!);
                          }

                          // Prepare service data
                          Map<String, dynamic> serviceData = {
                            "name": authController.state!.fullName,
                            "address": isOnline ? " " : _addressController.text,
                            "phoneNumber": authController.state!.phoneNumber,
                            "email": authController.state!.email,
                            "identityProof": identityProofBase64,
                            "category": selectedServices.toString(),
                            "description": _descriptionController.text,
                            "experience": int.parse(_expController.text),
                            "duration": charges_durations,
                            "fees": int.parse(_serviceChargesController.text),
                            "serviceType": selectedOnlineOption == 'yes' ? "online" : "offline",
                            "serviceImages": serviceImagesBase64,
                          };

                          if (widget.service != null) {
                            bool isOk = await serviceController.updateservice({
                              ...serviceData
                            }, widget.service!.id);
                            if (isOk) {
                              Get.back();
                              Get.forceAppUpdate();
                              successSnackBar('Service Updated Successfully');
                            }
                          } else {
                            final serviceModel = await serviceController.addService(serviceData);
                            authController.getUser();
                            logger.d("The Service id is: ${serviceModel.id}");
                            Get.to(() => ServicePaymentPage(service: serviceModel));
                          }
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      isDisabled: !tncAccepted,
                      title: 'Submit',
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: ListView(children: [
                  FormInput(
                    controller: TextEditingController(
                        text: authController.state!.fullName),
                    label: "Name",
                    enabled: false,
                    readOnly: true,
                  ),
                  FormInput(
                    controller: TextEditingController(
                        text: authController.state!.phoneNumber),
                    label: "Contact Number",
                    enabled: false,
                    readOnly: true,
                    textInputType: TextInputType.number,
                  ),
                  FormInput(
                    controller: TextEditingController(
                        text: authController.state!.email),
                    label: "Email",
                    textInputType: TextInputType.emailAddress,
                    readOnly: true,
                    enabled: false,
                    // validator: (value) {
                    //   int age = value as int;
                    //   if (age >= 100) {
                    //     errorSnackBar("Sorry But Your Age is not a valid age");
                    //   }
                    // },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                    ),
                    padding: const EdgeInsets.symmetric( horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          'Is Your Service Online?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Radio<String>(
                          value: 'yes',
                          groupValue: selectedOnlineOption,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOnlineOption = value!;
                              isOnline = value == 'yes';
                              if (isOnline) {
                                location = null;
                                _addressController.clear();
                              }
                            });
                          },
                        ),
                        const Text('Yes'),
                        Radio<String>(
                          value: 'no',
                          groupValue: selectedOnlineOption,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOnlineOption = value!;
                              isOnline = value == 'yes';
                            });
                          },
                        ),
                        const Text('No'),
                      ],
                    ),
                  ),
                  if (!isOnline)
                    FormInput(
                      controller: _addressController,
                      label: "Address",
                      textInputType: TextInputType.streetAddress,
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "Service You will Offered",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  DropDownWidget(
                    isService: true,
                    title: "Select the Service",
                    onSelect: (dynamic selectedItems) {
                      setState(() {
                        selectedServices = selectedItems is List
                            ? selectedItems.join(', ')
                            : selectedItems.toString();
                      });
                    },
                    selectedValue: selectedServices,
                    items: cricketServices,
                    isAds: false,
                  ),
                  FormInput(
                    controller: _descriptionController,
                    label: "Service description ",
                    textInputType: TextInputType.multiline,
                  ),
                  FormInput(
                    controller: _serviceChargesController,
                    label: "Service Charges",
                    textInputType: TextInputType.number,
                  ),
                  DropDownWidget(
                    title: "Select the Duration ",
                    onSelect: (dynamic selectedItem) {
                      setState(() {
                        Duration = selectedItem;
                        // if (selectedItem is String) {
                        //   Duration = {
                        //     'type': selectedItem,
                        //     'value': {}
                        //   };
                        // } else {
                        //   Duration = selectedItem;
                        // }


                        if (selectedItem is Map<String, dynamic>) {
                          String type = selectedItem['type'] ?? '';
                          Map<String, dynamic>? value = selectedItem['value'] as Map<String, dynamic>?;

                          if (type == 'Hours' && value != null) {
                            charges_durations = '${value['hours'] ?? '0'} hours ${value['minutes'] ?? '0'} minutes';
                          } else if (type == 'Days' && value != null) {
                            charges_durations = '${value['days'] ?? '0'} days';
                          } else if (type == 'Months' && value != null) {
                            charges_durations = '${value['months'] ?? '0'} months';
                          } else {
                            charges_durations = '';
                          }
                        }
                      });
                    },
                    selectedValue: Duration,
                    items: duration,
                    isAds: false,
                    isDuration: true,
                  ),
                  FormInput(
                    controller: _expController,
                    label: "Year of Experience",
                    textInputType: TextInputType.number,
                  ),
                  const Text(
                    "Images of the service",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _images.isEmpty ? Container(
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
                    itemCount: _images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _images.length) {
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
                              imageViewer(context, _images[index].path, false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(File(_images[index].path)),
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
                                  _images.removeAt(index);
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
                  const Text(
                    "Document Verification",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _documentImages == null
                        ? GestureDetector(
                      onTap: pickDocumentImages,
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
                              "Select Document for Verification",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(File(_documentImages!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _documentImages = null;
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Package",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: ()async {
                      // final result = await Get.to(() =>  PackageScreen(selectedPackages:selectedPackage));
                      // if (result != null && result is Map<String, dynamic>) {
                      //   setState(() {
                      //     selectedPackage = result;
                      //   });
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedPackage == null || selectedPackage!.isEmpty
                            ? 'Select a package'
                            : '${selectedPackage!['package']} - ${selectedPackage!['Duration']} - ₹${selectedPackage!['price']}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: tncAccepted,
                              onChanged: (e) {
                                setState(() {
                                  tncAccepted = e!;
                                });
                              }),
                          RichText(
                            text: TextSpan(
                              text:
                              AppLocalizations.of(context)!.iHerebyAgreeToThe,
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .termsAndConditions,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.bottomSheet(BottomSheet(
                                        onClosing: () {},
                                        builder: (builder) =>
                                        const LegalViewScreen(
                                          title: 'Terms and Conditions',
                                          slug: 'terms',
                                          hideDeleteButton: true,
                                        ),
                                      ));
                                    },
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(
                                    text: " and \n", style: TextStyle()),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.disclaimer,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.bottomSheet(BottomSheet(
                                        onClosing: () {},
                                        builder: (builder) =>
                                        const LegalViewScreen(
                                            title: 'Disclaimer',
                                            slug: 'disclaimer',
                                            hideDeleteButton: true),
                                      ));
                                    },
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(
                                    text: " of the app ", style: TextStyle()),
                              ],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}