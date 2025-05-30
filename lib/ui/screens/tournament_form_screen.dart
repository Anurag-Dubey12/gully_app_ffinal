import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/screens/legal_screen.dart';
import 'package:gully_app/ui/screens/payment_page.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/create_tournament/top_card.dart';
import 'package:gully_app/ui/widgets/custom_drop_down_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/app_constants.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/controller/misc_controller.dart';
import '../../utils/image_picker_helper.dart';
import '../theme/theme.dart';

class TournamentFormScreen extends StatefulWidget {
  final TournamentModel? tournament;
  const TournamentFormScreen({super.key, this.tournament});
  @override
  State<TournamentFormScreen> createState() => _TournamentFormScreenState();
}

class _TournamentFormScreenState extends State<TournamentFormScreen>
    with SingleTickerProviderStateMixin {
  String tournamentType = 'turf';
  String ballType = 'tennis';
  String pitchType = 'cement';
  DateTime? from;
  DateTime? to;
  bool tncAccepted = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _prizesController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _ballChargesController = TextEditingController();
  final TextEditingController _breakfastChargesController =
      TextEditingController();
  final TextEditingController _teamLimitController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _disclaimerController = TextEditingController();
  final TextEditingController _cohost1Name = TextEditingController();
  final TextEditingController _cohost1Phone = TextEditingController();
  final TextEditingController _cohost2Name = TextEditingController();
  final TextEditingController _cohost2Phone = TextEditingController();

  //Focus Node
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _rulesFocusNode = FocusNode();
  final FocusNode _prizesFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _ballChargesFocusNode = FocusNode();
  final FocusNode _breakfastChargesFocusNode = FocusNode();
  final FocusNode _teamLimitFocusNode = FocusNode();

  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _disclaimerFocusNode = FocusNode();
  final FocusNode _cohost1NameFocusNode = FocusNode();
  final FocusNode _cohost1PhoneFocusNode = FocusNode();
  final FocusNode _cohost2NameFocusNode = FocusNode();
  final FocusNode _cohost2PhoneFocusNode = FocusNode();

  bool isLoading = false;
  int currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final List<String> _stepTitles = [
    'Basic Info',
    'Organizer Info',
    'Tournament Details'
  ];

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  XFile? _image;
  String defaultImagePath = 'assets/images/logo.png';
  bool isDefaultImage = true;

  pickImage() async {
    if (widget.tournament != null && isCoHost()) {
      errorSnackBar('Co-hosts are not allowed to change the cover photo');
      return;
    }
    final img = await imagePickerHelper();
    if (img != null) {
      setState(() {
        _image = img;
        isDefaultImage = false;
      });
    }
    setState(() {});
  }

  bool isCoHost() {
    final authController = Get.find<AuthController>();
    final currentUserId = authController.state?.id;
    return (widget.tournament?.coHost1?.id == currentUserId) ||
        (widget.tournament?.coHost2?.id == currentUserId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });

    if (widget.tournament != null) {
      _nameController.text = widget.tournament!.tournamentName;
      _rulesController.text = widget.tournament!.rules ?? "";
      _entryFeeController.text =
          int.parse(widget.tournament!.fees.toStringAsFixed(0)).toString();
      _ballChargesController.text = widget.tournament!.ballCharges.toString();
      _breakfastChargesController.text =
          widget.tournament!.breakfastCharges.toString();
      _teamLimitController.text = widget.tournament!.tournamentLimit.toString();
      _addressController.text = widget.tournament!.stadiumAddress;
      _disclaimerController.text = widget.tournament!.disclaimer ?? "";
      _prizesController.text = widget.tournament!.tournamentPrize ?? "";

      from = widget.tournament!.tournamentStartDateTime;
      to = widget.tournament!.tournamentEndDateTime;
      _cohost1Name.text = widget.tournament!.coHost1?.fullName ?? "";
      _cohost1Phone.text = widget.tournament!.coHost1?.phoneNumber ?? "";
      _cohost2Name.text = widget.tournament!.coHost2?.fullName ?? "";
      _cohost2Phone.text = widget.tournament!.coHost2?.phoneNumber ?? "";
      // tournamentType = widget.tournament!.tournamentCategory!;
      ballType = widget.tournament!.ballType;
      pitchType = widget.tournament!.pitchType;
    }
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressController);
    fetchLocation();
  }

  late LatLng location;
  fetchLocation() async {
    final postion = await determinePosition();
    location = LatLng(postion.latitude, postion.longitude);
    setState(() {});
  }

  void _updateProgress() {
    setState(() {
      double endValue = currentStep / (_formKeys.length - 1);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: endValue,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      _progressController.forward(from: 0);
    });
  }

  void _nextPage() {
    if (_formKeys[currentStep].currentState!.validate()) {
      _formKeys[currentStep].currentState!.save();
      if (widget.tournament == null) {
        if (from == null && to == null) {
          errorSnackBar('Please select tournament start and end date');
          return;
        }
        // if (currentStep == 0 && _image == null) {
        //   errorSnackBar('Please select a cover image');
        //   return;
        // }
      }
      if (currentStep < _formKeys.length - 1) {
        setState(() {
          currentStep++;
        });
        _updateProgress();
      }
    }
  }

  void _previousPage() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
    _updateProgress();
  }

  void _submitForm() async {
    if (tncAccepted == false) {
      errorSnackBar('Please accept the Terms and Conditions');
      return;
    }
    if (_formKeys[currentStep].currentState!.validate()) {
      try {
        final TournamentController tournamentController =
            Get.find<TournamentController>();
        final MiscController connectionController = Get.find<MiscController>();
        if (isCoHost()) {
          errorSnackBar('Co-hosts are not allowed to edit tournament details');
          return;
        }
        // tournmanent name should not contain emojis or special characters except for alphabets and numbers

        setState(() {
          isLoading = true;
        });
        if (tncAccepted == false) {
          errorSnackBar('Please accept the Terms and Conditions');
          return;
        }
        String? base64;
        if (_image != null) {
          base64 = await convertImageToBase64(_image!);
        }
        Map<String, dynamic> tournament = {
          "tournamentStartDateTime": from?.toIso8601String(),
          "tournamentEndDateTime": to?.toIso8601String(),
          "tournamentName": _nameController.text,
          "tournamentCategory": tournamentType,
          "ballType": ballType.toLowerCase(),
          "pitchType": pitchType,
          "matchType": "Tennis ball cricket match",
          "tournamentPrize": _prizesController.text,
          "fees": _entryFeeController.text,
          "ballCharges": _ballChargesController.text,
          "breakfastCharges": _breakfastChargesController.text,
          "stadiumAddress": _addressController.text,
          "tournamentLimit": _teamLimitController.text,
          "gameType": "CRICKET",
          "selectLocation": _addressController.text,
          "latitude": location.latitude,
          "longitude": location.longitude,
          "rules": _rulesController.text,
          'coverPhoto': base64,
          'coHost1Name':
              _cohost1Name.text.trim().isEmpty ? null : _cohost1Name.text,
          'coHost1Phone':
              _cohost1Phone.text.trim().isEmpty ? null : _cohost1Phone.text,
          'coHost2Name': _cohost2Name.text.isEmpty ? null : _cohost2Name.text,
          'coHost2Phone':
              _cohost2Phone.text.isEmpty ? null : _cohost2Phone.text,
          // 'disclaimer': _disclaimerComntroller.text,
        };
        if (connectionController.isConnected.value) {
          if (widget.tournament != null) {
            bool isOk = await tournamentController.updateTournament({
              ...tournament,
            }, widget.tournament!.id);
            if (isOk) {
              successSnackBar('Tournament Updated Successfully',
                  istournamentScreen: true);
              Get.forceAppUpdate();
            }
            // }
          } else {
            // final tournamentModel =
            // await tournamentController
            //     .createTournament(tournament);
            // authController.getUser();
            // //logger.d"The Tournament id is:${tournamentModel.id}");
            // if (tournament != null) {
            //   final result = await Get.to(() => PaymentPage(tournament: tournamentModel));
            //   if (result == null || result == false) {
            //     await tournamentController.cancelTournament(tournamentModel.id);
            //     Get.snackbar("Tournament", "Your tournament Deleted Successfully");
            //   }
            // }
            // successSnackBar('Tournament Create Successfully',istournamentScreen: true);
            // Get.offAll(() => const HomeScreen(),
            //     predicate: (route) => route.name == '/HomeScreen');

            tournamentController.tournamentModel.value = tournament;
            Get.to(() => PaymentPage(
                tournament: tournamentController.tournamentModel.value));
          }
        } else {
          errorSnackBar('No Internet Connection. Please try again later.');
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose each FocusNode
    _nameFocusNode.dispose();
    _rulesFocusNode.dispose();
    _prizesFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _ballChargesFocusNode.dispose();
    _breakfastChargesFocusNode.dispose();
    _teamLimitFocusNode.dispose();

    _addressFocusNode.dispose();
    _disclaimerFocusNode.dispose();
    _cohost1NameFocusNode.dispose();
    _cohost1PhoneFocusNode.dispose();
    _cohost2NameFocusNode.dispose();
    _cohost2PhoneFocusNode.dispose();

    // Dispose controllers as well
    _nameController.dispose();
    _rulesController.dispose();
    _prizesController.dispose();
    _entryFeeController.dispose();
    _ballChargesController.dispose();
    _breakfastChargesController.dispose();
    _teamLimitController.dispose();

    _addressController.dispose();
    _disclaimerController.dispose();
    _cohost1Name.dispose();
    _cohost1Phone.dispose();
    _cohost2Name.dispose();
    _cohost2Phone.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            // bottomNavigationBar: Container(
            //   height: 90,
            //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
            //     BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         blurRadius: 5,
            //         spreadRadius: 2,
            //         offset: const Offset(0, -1))
            //   ]),
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 35.0, vertical: 19),
            //         child: isLoading
            //             ? const CircularProgressIndicator()
            //             : PrimaryButton(
            //                 onTap: () async {
            //                   try {
            //                     if (_key.currentState!.validate()) {
            //                       if (from == null || to == null) {
            //                         errorSnackBar(
            //                             'Please select tournament start and end date');
            //                         return;
            //                       }
            //                       if (_image == null &&
            //                           widget.tournament?.coverPhoto == null) {
            //                         errorSnackBar(
            //                             'Please select a cover image');
            //                         return;
            //                       }
            //                       if (isCoHost()) {
            //                         errorSnackBar(
            //                             'Co-hosts are not allowed to edit tournament details');
            //                         return;
            //                       }
            //                       // tournmanent name should not contain emojis or special characters except for alphabets and numbers
            //
            //                       setState(() {
            //                         isLoading = true;
            //                       });
            //
            //                       String? base64;
            //                       if (_image != null) {
            //                         base64 =
            //                             await convertImageToBase64(_image!);
            //                       }
            //                       Map<String, dynamic> tournament = {
            //                         "tournamentStartDateTime":
            //                             from?.toIso8601String(),
            //                         "tournamentEndDateTime":
            //                             to?.toIso8601String(),
            //                         "tournamentName": _nameController.text,
            //                         "tournamentCategory": tournamentType,
            //                         "ballType": ballType.toLowerCase(),
            //                         "pitchType": pitchType,
            //                         "matchType": "Tennis ball cricket match",
            //                         "tournamentPrize": _prizesController.text,
            //                         "fees": _entryFeeController.text,
            //                         "ballCharges":
            //                             _ballChargesController.text,
            //                         "breakfastCharges":
            //                             _breakfastChargesController.text,
            //                         "stadiumAddress": _addressController.text,
            //                         "tournamentLimit":
            //                             _teamLimitController.text,
            //                         "gameType": "CRICKET",
            //                         "selectLocation": _addressController.text,
            //                         "latitude": tournamentController
            //                             .coordinates.value.latitude,
            //                         "longitude": tournamentController
            //                             .coordinates.value.longitude,
            //                         "rules": _rulesController.text,
            //                         'coverPhoto': base64,
            //                         'coHost1Name':
            //                             _cohost1Name.text.trim().isEmpty
            //                                 ? null
            //                                 : _cohost1Name.text,
            //                         'coHost1Phone':
            //                             _cohost1Phone.text.trim().isEmpty
            //                                 ? null
            //                                 : _cohost1Phone.text,
            //                         'coHost2Name': _cohost2Name.text.isEmpty
            //                             ? null
            //                             : _cohost2Name.text,
            //                         'coHost2Phone': _cohost2Phone.text.isEmpty
            //                             ? null
            //                             : _cohost2Phone.text,
            //                         // 'disclaimer': _disclaimerController.text,
            //                       };
            //                       if (widget.tournament != null) {
            //                         bool isOk = await tournamentController
            //                             .updateTournament({
            //                           ...tournament,
            //                         }, widget.tournament!.id);
            //                         if (isOk) {
            //                           Get.back();
            //                           Get.forceAppUpdate();
            //                           successSnackBar(
            //                               'Tournament Updated Successfully');
            //                         }
            //                       } else {
            //                         final tournamentModel =
            //                             await tournamentController
            //                                 .createTournament(tournament);
            //
            //                         authController.getUser();
            //                         // if (tournament != null) {
            //                         //   final result = await Get.to(() => PaymentPage(tournament: tournamentModel));
            //                         //   if (result == null || result == false) {
            //                         //     await tournamentController.cancelTournament(tournamentModel.id);
            //                         //     Get.snackbar("Tournament", "Your tournament Deleted Successfully");
            //                         //   }
            //                         // }
            //                         Get.to(() => PaymentPage(
            //                             tournament: tournamentModel));
            //                       }
            //                     }
            //                   } finally {
            //                     setState(() {
            //                       isLoading = false;
            //                     });
            //                   }
            //                   // Get.to(() => const SelectLocationScreen());
            //                 },
            //                 isDisabled: !tncAccepted,
            //                 title: 'Submit',
            //               ),
            //       ),
            //     ],
            //   ),
            // ),
            bottomNavigationBar: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
              width: Get.width,
              child: currentStep == 0
                  ? nextNavigationButton('Next', _nextPage)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentStep > 0)
                          previousNavigationButton(_previousPage)
                        else
                          const SizedBox(width: 80),
                        if (currentStep < _formKeys.length - 1)
                          nextNavigationButton('Next', _nextPage)
                        else if (currentStep == _formKeys.length - 1)
                          nextNavigationButton('Submit', _submitForm)
                        else
                          const SizedBox(width: 80),
                      ],
                    ),
            ),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.tournament != null
                    ? 'Edit Tournament'
                    : 'Create Tournament',
                style: Get.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.height,
                  // color: Colors.black26,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              _stepTitles[currentStep],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 20),
                            child: AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Text(
                                  "${currentStep + 1}/${_stepTitles.length}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              borderRadius: BorderRadius.circular(20),
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor),
                              minHeight: 12,
                            );
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Text(
                      //     _stepTitles[currentStep],
                      //     style: const TextStyle(color: Colors.white, fontSize: 20),
                      //   ),
                      // ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: currentStepBuild(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget currentStepBuild() {
    switch (currentStep) {
      case 0:
        return firstStep();
      case 1:
        return secondStep();
      case 2:
        return ThirdStep();
      default:
        return firstStep();
    }
  }

  Widget firstStep() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.04),
          InkWell(
            onTap: () {
              pickImage();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: Get.width,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 1))
                  ]),
              child: _image != null
                  ? SizedBox(
                      height: 130,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: Get.width,
                              height: 120,
                              child: Image.file(
                                File(
                                  _image!.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                                onPressed: () {
                                  pickImage();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                    )
                  : widget.tournament?.coverPhoto != null
                      ? SizedBox(
                          height: 130,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: Get.width,
                                  height: 120,
                                  child: Image.network(
                                    toImageUrl(widget.tournament!.coverPhoto!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: IconButton(
                                    onPressed: () {
                                      pickImage();
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    )),
                              )
                            ],
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // if () {
                              //   errorSnackBar('Co-hosts are not allowed to edit tournament details');
                              //   return;
                              // }
                              Icon(Icons.photo),
                              Text('Add Cover Photo',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          FormInput(
            controller: _nameController,
            label: AppConstants.tournamentName,
            // readOnly: widget.tournament != null && isCoHost(),
            iswhite: false,
            focusNode: _nameFocusNode,
            filled: true,
            validator: (p0) {
              if (p0!.isEmpty) {
                return AppConstants.pleaseEnterTournamentName;
              }
              if (p0[0] == " ") {
                return "First character should not be a space";
              }
              if (p0.trim().isEmpty) {
                return AppConstants.pleaseEnterTournamentName;
              }
              if (p0.length < 3) {
                return "Tournament name should be atleast 3 characters long";
              }
              if (p0.isNotEmpty && !RegExp(r'^[a-zA-Z]+$').hasMatch(p0[0])) {
                return "Please enter valid name";
              }
              if (!p0.contains(RegExp(r'^[a-zA-Z0-9- ]*$'))) {
                return "Special characters are not allowed (except -)";
              }

              if (p0.contains(RegExp(r'[^\x00-\x7F]+'))) {
                return AppConstants.tournamentNameCannotContainEmojis;
              }
              return null;
            },
          ),
          TopCard(
            from: from,
            key: const Key('date_picker'),
            to: to,
            controller: _nameController,
            onFromChanged: (e) {
              setState(() {
                if (to != null && e.isAfter(to)) {
                  errorSnackBar(
                      AppConstants.tournamentStartDateShouldBeLessThanEndDate);

                  return;
                }
                from = e;
                FocusManager.instance.primaryFocus?.unfocus();
              });
            },
            onToChanged: (e) {
              setState(() {
                if (from == null) {
                  errorSnackBar(AppConstants.pleaseSelectTournamentStartDate);
                  return;
                }
                if (e.isBefore(from!)) {
                  errorSnackBar(AppConstants
                      .tournamentEndDateShouldBeGreaterThanStartDate);
                  return;
                }
                to = e;
                FocusManager.instance.primaryFocus?.unfocus();
              });
            },
            isAds: false,
          ),
          Text(AppConstants.tournamentCategory,
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16)),
          DropDownWidget(
            title: AppConstants.selectTournamentCategory,
            onSelect: (e) {
              Future.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).unfocus();
              });
              setState(() {
                tournamentType = e;
              });
            },
            selectedValue: tournamentType.toUpperCase(),
            items: const ['turf', 'corporate', 'series', 'open'],
            isAds: false,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(AppConstants.ballType,
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16)),
          DropDownWidget(
            title: AppConstants.selectBallType,
            onSelect: (e) {
              Future.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).unfocus();
              });
              setState(() {
                ballType = e;
              });
            },
            selectedValue: ballType.toUpperCase(),
            items: const [
              'tennis',
              'leather',
              'others',
            ],
            isAds: false,
          ),
          tournamentType == "turf"
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Text(AppConstants.pitchType,
                        style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16)),
                    DropDownWidget(
                      title: AppConstants.selectPitchType,
                      onSelect: (e) {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).unfocus();
                        });
                        setState(() {
                          pitchType = e;
                        });
                      },
                      selectedValue: pitchType.toUpperCase(),
                      items: const [
                        'rough',
                        'cement',
                      ],
                      isAds: false,
                    ),
                  ],
                ),
          const SizedBox(
            height: 9,
          ),
        ],
      ),
    );
  }

  Widget secondStep() {
    final AuthController authController = Get.find<AuthController>();
    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          const SizedBox(
            height: 9,
          ),
          FormInput(
            controller:
                TextEditingController(text: authController.state!.fullName),
            label: AppConstants.organizerName,
            enabled: false,
            iswhite: false,
            filled: true,
            readOnly: true,
          ),
          FormInput(
            controller:
                TextEditingController(text: authController.state!.phoneNumber),
            label: AppConstants.organizerContactNo,
            enabled: false,
            readOnly: true,
            textInputType: TextInputType.number,
            iswhite: false,
            filled: true,
          ),
          FormInput(
            controller: _cohost1Name,
            label: AppConstants.cohost1Name,
            textInputType: TextInputType.text,
            iswhite: false,
            filled: true,
            validator: (e) {
              final name = e ?? '';
              final phone = _cohost1Phone.text;

              if (name.trim().isEmpty && phone.trim().isNotEmpty) {
                return "Please enter co-host 1 name";
              }
              if (name.startsWith(" ")) {
                return "First character should not be a space";
              }
              if (name.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(name)) {
                return "First character should be an alphabet";
              }
              if (name.isNotEmpty &&
                  !RegExp(r'^[a-zA-Z0-9\- ]+$').hasMatch(name)) {
                return "Please enter valid name";
              }
              return null;
            },
          ),
          FormInput(
            controller: _cohost1Phone,
            label: AppConstants.cohost1ContactNo,
            textInputType: TextInputType.number,
            iswhite: false,
            filled: true,
            maxLength: 10,
            validator: (e) {
              final phone = e ?? '';
              final name = _cohost1Name.text;

              if (name.trim().isNotEmpty && phone.trim().isEmpty) {
                return AppConstants.pleaseEnterCohost1ContactNo;
              }
              if (phone.trim().isEmpty) {
                return null;
              }
              if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                return AppConstants.pleaseEnterValidContactNo;
              }
              if (_cohost2Phone.text == phone) {
                return AppConstants.cohost1AndCohost2ContactNoCannotBeSame;
              }
              return null;
            },
          ),
          FormInput(
            controller: _cohost2Name,
            label: AppConstants.cohost2Name,
            textInputType: TextInputType.text,
            iswhite: false,
            filled: true,
            validator: (e) {
              final name = e ?? '';
              final phone = _cohost2Phone.text;

              if (name.trim().isEmpty && phone.trim().isNotEmpty) {
                return "Please enter co-host 2 name";
              }
              if (name.startsWith(" ")) {
                return "First character should not be a space";
              }
              if (name.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(name)) {
                return "First character should be an alphabet";
              }
              if (name.isNotEmpty &&
                  !RegExp(r'^[a-zA-Z0-9\- ]+$').hasMatch(name)) {
                return "Please enter valid name";
              }
              return null;
            },
          ),
          FormInput(
            controller: _cohost2Phone,
            label: AppConstants.cohost2ContactNo,
            textInputType: TextInputType.number,
            iswhite: false,
            filled: true,
            maxLength: 10,
            validator: (e) {
              final phone = e ?? '';
              final name = _cohost2Name.text;

              if (name.trim().isNotEmpty && phone.trim().isEmpty) {
                return AppConstants.pleaseEnterCohost2ContactNo;
              }
              if (phone.trim().isEmpty) {
                return null; // allow empty if name is also empty
              }
              if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                return AppConstants.pleaseEnterValidContactNo;
              }
              if (_cohost1Phone.text == phone) {
                return AppConstants.cohost1AndCohost2ContactNoCannotBeSame;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget ThirdStep() {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInput(
            controller: _rulesController,
            label: AppConstants.rules,
            textInputType: TextInputType.multiline,
            iswhite: false,
            filled: true,
            validator: (e) {
              if (e!.trim().isEmpty) {
                return AppConstants.pleaseEnterRules;
              }
              // RegExp regex = RegExp(
              //     r'^(?:(?![\u2000-\u3300]|[\uE000-\uF8FF]|[\uD800-\uDBFF]|[\uDC00-\uDFFF]).)*$');
              // if (!regex.hasMatch(e)) {
              //   return "Please enter valid rules";
              // }
              return null;
            },
            maxLines: 5,
          ),
          FormInput(
            controller: _prizesController,
            label: AppConstants.prizes,
            maxLines: 3,
            iswhite: false,
            filled: true,
            textInputType: TextInputType.multiline,
            validator: (e) {
              if (e!.trim().isEmpty) {
                return "Please enter prizes";
              }
              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                return 'Prizes cannot contain emojis or special characters';
              }
              return null;
            },
          ),
          FormInput(
            controller: _addressController,
            label: AppConstants.selectStadiumAddress,
            readOnly: true,
            iswhite: false,
            filled: true,
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
                        //logger.d
                        // "The selected Location is $l and address is:${_addressController.text}");
                      });
                    }
                    FocusScope.of(context).unfocus();
                  },
                  initialLocation:
                      LatLng(location.latitude, location.longitude),
                ),
              );
            },
            validator: (e) {
              if (e!.trim().isEmpty) {
                return "Please enter stadium address";
              }
              return null;
            },
          ),
          FormInput(
            controller: _entryFeeController,
            label: AppConstants.entryFee,
            iswhite: false,
            filled: true,
            validator: (e) {
              if (e == null || e.trim().isEmpty) {
                return AppConstants.pleaseEnterEntryFee;
              }
              if (!RegExp(r'^\d+$').hasMatch(e)) {
                return AppConstants.pleaseEnterValidEntryFee;
              }
              if (e.startsWith('0')) {
                return AppConstants.entryFeeCannotStartWith0;
              }
              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                return AppConstants.rulesCannotContainEmojis;
              }
              return null;
            },
            maxLength: 9,
            textInputType: TextInputType.number,
          ),
          FormInput(
            controller: _ballChargesController,
            label: AppConstants.ballCharges,
            iswhite: false,
            filled: true,
            validator: (e) {
              if (e == null || e.trim().isEmpty) {
                return AppConstants.pleaseEnterBallCharges;
              }
              if (!RegExp(r'^\d+$').hasMatch(e)) {
                return AppConstants.pleaseEnterValidBallCharges;
              }
              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                return AppConstants.rulesCannotContainEmojis;
              }
              return null;
            },
            maxLength: 6,
            textInputType: TextInputType.number,
          ),
          FormInput(
            controller: _breakfastChargesController,
            label: AppConstants.breakfastCharges,
            textInputType: TextInputType.number,
            iswhite: false,
            filled: true,
            validator: (e) {
              if (e == null || e.trim().isEmpty) {
                return AppConstants.pleaseEnterBreakfastCharges;
              }
              if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(e)) {
                return AppConstants.pleaseEnterValidBreakfastCharges;
              }
              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                return AppConstants.pleaseEnterValidBreakfastCharges;
              }
              return null;
            },
            maxLength: 6,
          ),
          FormInput(
            controller: _teamLimitController,
            label: AppConstants.teamLimit,
            iswhite: false,
            filled: true,
            validator: (e) {
              if (e == null || e.trim().isEmpty) {
                return AppConstants.pleaseEnterTeamLimit;
              } else if (!RegExp(r'^\d+$').hasMatch(e)) {
                return AppConstants.pleaseEnterValidTeamLimit;
              } else if (int.parse(e) < 2) {
                return AppConstants.teamLimitShouldBeEqualOrGreaterThan2;
              }
              return null;
            },
            maxLength: 3,
            textInputType: TextInputType.number,
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
                  text: AppConstants.iHerebyAgreeToThe,
                  children: [
                    TextSpan(
                      text: "Terms and Conditions",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.bottomSheet(BottomSheet(
                            onClosing: () {},
                            builder: (builder) => const LegalViewScreen(
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
                    const TextSpan(text: " and \n", style: TextStyle()),
                    TextSpan(
                      text: "Disclaimer",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.bottomSheet(BottomSheet(
                            onClosing: () {},
                            builder: (builder) => const LegalViewScreen(
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
                    const TextSpan(text: " of the app ", style: TextStyle()),
                  ],
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
