import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import '../../../data/controller/auth_controller.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/geo_locator_helper.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../../widgets/arc_clipper.dart';
import '../../widgets/create_tournament/form_input.dart';
import '../../widgets/custom_drop_down_field.dart';
import '../../widgets/primary_button.dart';
import '../legal_screen.dart';
import '../select_location.dart';

class ServiceRegister extends StatefulWidget {
  const ServiceRegister({super.key});

  @override
  State<StatefulWidget> createState() => RegisterService();
}

class RegisterService extends State<ServiceRegister> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading=false;
  bool tncAccepted = false;
  final _key = GlobalKey<FormState>();
  List<XFile> _images = [];
  List<String> selectedServices = [];
  LatLng? location;

  pickImages() async {
    final imgs = await multipleimagePickerHelper();

    if (imgs != null && imgs.isNotEmpty) {
      setState(() {
        _images.addAll(imgs.whereType<XFile>());
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

  List<String> cricketServices = [
    'Batting Coaching',
    'Bowling Coaching',
    'Fielding Coaching',
    'Wicketkeeping Coaching',
    'Fitness & Conditioning Training',
    'Mentoring & Strategy Sessions',
    'Youth Cricket Camps',
    'Specialized Skill Camps',
    'Elite Player Camps',
    'Team Selection & Analysis',
    'Match Strategy Development',
    'Tournament & League Organization',
    'Net Practice Rentals',
    'Pitch Preparation',
    'Indoor Cricket Facilities',
    'Cricket Gear Sales',
    'Cricket Gear Customization',
    'Cricket Gear Rental',
    'Academy Enrollments',
    'High-Performance Academies',
    'Scholarships & Talent Scouting',
    'Fitness Training Programs',
    'Recovery & Physiotherapy',
    'Nutrition Plans for Cricketers',
    'Player Performance Analysis',
    'Match Video Analysis',
    'Smart Cricket Devices',
    'Cricket Broadcasting & Commentary Services',
    'Cricket Events & Corporate Tournaments',
    'Cricket Clinics & Workshops'
  ];

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
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
                      errorSnackBar('Please accept the Terms and Conditions',
                          title: "Error");
                      return;
                    }
                    if (_images.isEmpty) {
                      errorSnackBar('Please select at least one image',
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
                    if (_feeController.text.isEmpty) {
                      errorSnackBar('Please enter fee',
                          title: "Error");
                      return;
                    }
                    if (_expController.text.isEmpty) {
                      errorSnackBar('Please enter experience',
                          title: "Error");
                      return;
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
          color: Colors.black26,
          child: Form(
            key: _key,
            child: ListView(
              children: [
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
                  controller: _ageController,
                  label: "Age",
                  textInputType: TextInputType.number,
                  validator: (value) {
                    int age = value as int;
                    if (age >= 100) {
                      errorSnackBar("Sorry But Your Age is not a valid age");
                    }
                  },
                ),
                FormInput(
                  controller: _addressController,
                  label: 'Select Location for Your Service',
                  readOnly: true,
                  onTap: () async {
                    Get.to(
                      () => SelectLocationScreen(
                        onSelected: (e, l) {
                          setState(() {
                            _addressController.text = e;
                          });
                          if (l != null) {
                            setState(() {
                              location = l;
                              logger.d("The Location is $l");
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        initialLocation: location != null
                            ? LatLng(location!.latitude, location!.longitude)
                            : null,
                      ),
                    );
                  },
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
                  controller: _feeController,
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
                GridView.builder(
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
                            imageViewer(context, _images[index].path,false);
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
                        //i hereby agree to the terms and conditions and disclaimer of the app
                        text: AppLocalizations.of(context)!
                            .iHerebyAgreeToThe,
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
                            text: AppLocalizations.of(context)!
                                .disclaimer,
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
                              text: " of the app ",
                              style: TextStyle()),
                        ],
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
