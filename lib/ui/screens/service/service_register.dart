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
import '../../widgets/service/package_screen.dart';
import '../legal_screen.dart';
import '../select_location.dart';
import '../service_payment_page.dart';

class ServiceRegister extends StatefulWidget {
  const ServiceRegister({super.key});

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
  List<String> selectedServices = [];
  bool isLoading = false;
  bool tncAccepted = false;
  final _key = GlobalKey<FormState>();
  final List<XFile> _images = [];
  LatLng? location;
  String? charges_durations = '';
  String? package_duration = '';
  bool isOnline=false;


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
    final ImagePicker _picker = ImagePicker();
    final XFile? images = await _picker.pickImage(source: ImageSource.gallery);

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
    serviceModel = ServiceModel(
      serviceId: '',
      name: authController.state!.fullName,
      phoneNumber: authController.state!.phoneNumber ??" ",
      email: '',
      fees: 0,
      description: '',
      experience: 0,
      category: [],
      address: '',
      serviceImages: [],
      identityProof: '',
      servicePackage: PackageModel(name: '', duration: '', price: 0,endDate: ''), duration: '', serviceType: '',
    );
  }

  List<String> cricketServices = [
    "Football Coaching", "Basketball Coaching", "Cricket Coaching", "Tennis Coaching",
    "Badminton Coaching", "Volleyball Coaching", "Table Tennis Coaching", "Rugby Coaching",
    "Hockey Coaching", "Squash Coaching", "Golf Coaching", "Baseball Coaching",
    "Softball Coaching", "Lacrosse Coaching", "Field Hockey Coaching", "Handball Coaching",
    "Netball Coaching", "Archery Coaching", "Fencing Coaching", "Wrestling Coaching"
  ];

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ServiceController serviceController = Get.put(ServiceController());
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
              title: const Text(
                'Register Service',
                style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            onTap: () async {
                              if (!tncAccepted) {
                                errorSnackBar(
                                    'Please accept the Terms and Conditions',
                                    title: "Error"
                                );
                                return;
                              }
                              if (_images.isEmpty) {
                                errorSnackBar('Please select at least one image of your service',
                                    title: "Error");
                                return;
                              }
                              if (location == null) {
                                errorSnackBar('Please select your location',
                                    title: "Error");
                                return;
                              }
                              if (_descriptionController.text.isEmpty) {
                                errorSnackBar('Please enter description',
                                    title: "Error");
                                return;
                              }
                              if (_expController.text.isEmpty) {
                                errorSnackBar('Please enter experience',
                                    title: "Error");
                                return;
                              }
                              if(_images.isEmpty){
                                errorSnackBar('Please Add Some Images',
                                    title: "Error");
                                return;
                              }
                              if(_documentImages==null){
                                errorSnackBar('Please Add Document Images',
                                    title: "Error");
                                return;
                              }

                              Map<String,dynamic> bannerdata={
                                "name":_nameController.text,

                              };

                              final serviceModel = ServiceModel(
                                serviceId: '',
                                name: authController.state!.fullName,
                                phoneNumber: authController.state!.phoneNumber ?? "",
                                email: _emailController.text.toString(),
                                fees: int.parse(_serviceChargesController.text),
                                description: _descriptionController.text,
                                experience: int.parse(_expController.text),
                                category: selectedServices,
                                address: _addressController.text,
                                serviceImages: _images.map((image) => image.path).toList(),
                                identityProof: _documentImages.toString(),
                                servicePackage: PackageModel(
                                  name: selectedPackage!['package'],
                                  duration: selectedPackage!['Duration'],
                                  price: double.parse(selectedPackage!['price'].toString()),
                                  endDate: selectedPackage!['EndDate'],
                                ), duration: '', serviceType: '',
                              );
                              serviceController.addService(serviceModel);

                              // Navigate to ServicePaymentPage
                              Get.to(() => ServicePaymentPage(service: serviceModel));
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
                    // padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Is Your Service Online?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Switch(
                          value: isOnline,
                          activeColor: AppTheme.primaryColor,
                          inactiveThumbImage: const AssetImage("assets/images/logo.png"),
                          activeThumbImage: const AssetImage("assets/images/logo.png"),
                          inactiveThumbColor: Colors.grey,
                          activeTrackColor: Colors.grey,
                          // trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
                          //   if (states.contains(WidgetState.selected)) {
                          //     return Colors.grey;
                          //   }
                          //   return Colors.white;
                          // }),
                          onChanged: (bool value) {
                            setState(() {
                              isOnline = value;
                              if (value) {
                                location = null;
                                _addressController.clear();
                              }
                            });
                          },
                        ),
                        Text(
                          isOnline?"Yes": "No",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isOnline)
                    // FormInput(
                    //   controller: _addressController,
                    //   label: 'Select Location for Your Service',
                    //   readOnly: true,
                    //   onTap: () async {
                    //     Get.to(
                    //           () => SelectLocationScreen(
                    //         onSelected: (e, l) {
                    //           setState(() {
                    //             _addressController.text = e;
                    //           });
                    //           if (l != null) {
                    //             setState(() {
                    //               location = l;
                    //               logger.d("The Location is $l");
                    //             });
                    //           }
                    //           FocusScope.of(context).unfocus();
                    //         },
                    //         initialLocation: location != null
                    //             ? LatLng(location!.latitude, location!.longitude)
                    //             : null,
                    //       ),
                    //     );
                    //   },
                    // ),
                    FormInput(
                      controller: _addressController,
                      label: "Address",
                      textInputType: TextInputType.streetAddress,
                    ),
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
                        if (selectedItems is List<String>) {
                          selectedServices = selectedItems;
                        } else if (selectedItems is String) {
                          selectedServices = [selectedItems];
                        }
                      });
                    },
                    selectedValue: selectedServices,
                    items: cricketServices,
                    isAds: true,
                  ),
                  FormInput(
                    controller: _descriptionController,
                    label: "Service description ",
                    textInputType: TextInputType.multiline,
                  ),
                  FormInput(
                    controller: _serviceChargesController,
                    label: "Services Charges",
                    textInputType: TextInputType.number,
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
                      final result = await Get.to(() =>  PackageScreen(selectedPackages:selectedPackage));
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          selectedPackage = result;
                        });
                      }
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
