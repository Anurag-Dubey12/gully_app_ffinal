import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
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
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/controller/auth_controller.dart';
import '../../utils/image_picker_helper.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';

class TournamentFormScreen extends StatefulWidget {
  final TournamentModel? tournament;
  const TournamentFormScreen({super.key, this.tournament});

  @override
  State<TournamentFormScreen> createState() => _TournamentFormScreenState();
}

class _TournamentFormScreenState extends State<TournamentFormScreen> {
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

  final _key = GlobalKey<FormState>();

  bool isLoading = false;

  XFile? _image;

  pickImage() async {
    final img = await imagePickerHelper();
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
    setState(() {});
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
    fetchLocation();
  }

  late LatLng location;
  fetchLocation() async {
    final postion = await determinePosition();
    location = LatLng(postion.latitude, postion.longitude);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController =
        Get.find<TournamentController>();

    final AuthController authController = Get.find<AuthController>();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            bottomNavigationBar: Container(
              height: 90,
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
                        horizontal: 35.0, vertical: 19),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            onTap: () async {
                              try {
                                if (_key.currentState!.validate()) {
                                  if (from == null || to == null) {
                                    errorSnackBar(
                                        'Please select tournament start and end date');
                                    return;
                                  }

                                  // tournmanent name should not contain emojis or special characters except for alphabets and numbers

                                  setState(() {
                                    isLoading = true;
                                  });

                                  String? base64;
                                  if (_image != null) {
                                    base64 =
                                        await convertImageToBase64(_image!);
                                  }
                                  Map<String, dynamic> tournament = {
                                    "tournamentStartDateTime":
                                        from?.toIso8601String(),
                                    "tournamentEndDateTime":
                                        to?.toIso8601String(),
                                    "tournamentName": _nameController.text,
                                    "tournamentCategory": tournamentType,
                                    "ballType": ballType.toLowerCase(),
                                    "pitchType": pitchType,
                                    "matchType": "Tennis ball cricket match",
                                    "tournamentPrize": _prizesController.text,
                                    "fees": _entryFeeController.text,
                                    "ballCharges": _ballChargesController.text,
                                    "breakfastCharges":
                                        _breakfastChargesController.text,
                                    "stadiumAddress": _addressController.text,
                                    "tournamentLimit":
                                        _teamLimitController.text,
                                    "gameType": "CRICKET",
                                    "selectLocation": _addressController.text,
                                    "latitude": tournamentController
                                        .coordinates.value.latitude,
                                    "longitude": tournamentController
                                        .coordinates.value.longitude,
                                    "rules": _rulesController.text,
                                    'coverPhoto': base64,
                                    'coHost1Name':
                                        _cohost1Name.text.trim().isEmpty
                                            ? null
                                            : _cohost1Name.text,
                                    'coHost1Phone':
                                        _cohost1Phone.text.trim().isEmpty
                                            ? null
                                            : _cohost1Phone.text,
                                    'coHost2Name': _cohost2Name.text.isEmpty
                                        ? null
                                        : _cohost2Name.text,
                                    'coHost2Phone': _cohost2Phone.text.isEmpty
                                        ? null
                                        : _cohost2Phone.text,
                                    // 'disclaimer': _disclaimerController.text,
                                  };
                                  if (widget.tournament != null) {
                                    bool isOk = await tournamentController
                                        .updateTournament({
                                      ...tournament,
                                    }, widget.tournament!.id);
                                    if (isOk) {
                                      Get.back();
                                      Get.forceAppUpdate();
                                      successSnackBar(
                                          'Tournament Updated Successfully');
                                    }
                                  } else {
                                    if(_image==null){
                                      errorSnackBar('Please select an cover image');
                                    }
                                    final tournamentModel =
                                        await tournamentController
                                            .createTournament(tournament);

                                    authController.getUser();
                                    Get.to(() => PaymentPage(
                                          tournament: tournamentModel,
                                        ));

                                    // Get.to(() => PaymentPage(
                                    //   tournamentData: tournament,
                                    //   onPaymentSuccess: (TournamentModel createdTournament) {
                                    //     authController.getUser();
                                    //     Get.offAll(() => const HomeScreen(),
                                    //         predicate: (route) => route.name == '/HomeScreen');
                                    //     successSnackBar(
                                    //       'Congratulations, Organizer!\nYour tournament has been successfully created.',
                                    //     );
                                    //   },
                                    // ));
                                    // Get.back();
                                    // successSnackBar(
                                    //   'Congratulations, Organizer!\nYour tournament has been successfully created.',
                                    // ).then((value) => Get.offAll(
                                    //     () => const HomeScreen(),
                                    //     predicate: (route) =>
                                    //         route.name == '/HomeScreen'));
                                  }
                                }
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              // Get.to(() => const SelectLocationScreen());
                            },
                            isDisabled: !tncAccepted,
                            title: 'Submit',
                          ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                ClipPath(
                  clipper: ArcClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xff368EBF),
                          AppTheme.primaryColor,
                        ],
                        center: Alignment(-0.4, -0.8),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color:
                                AppTheme.secondaryYellowColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 70))
                      ],
                    ),
                    width: double.infinity,
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 0, top: 0),
                    child: Form(
                      key: _key,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
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
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                  color: Colors.white,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                  width: Get.width,
                                                  height: 120,
                                                  child: Image.network(
                                                    toImageUrl(widget
                                                        .tournament!
                                                        .coverPhoto!),
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
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )
                                      : const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo),
                                              Text('Add Cover Photo',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          FormInput(
                            controller: _nameController,
                            label: AppLocalizations.of(context)!.tournamentName,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterTournamentName;
                              }
                              if (p0[0] == " ") {
                                return "First character should not be a space";
                              }
                              if (p0.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterTournamentName;
                              }
                              if (p0.length < 3) {
                                return "Tournament name should be atleast 3 characters long";
                              }
                              if (p0.isNotEmpty &&
                                  !RegExp(r'^[a-zA-Z]+$').hasMatch(p0[0])) {
                                return "Please enter valid name";
                              }
                              if (!p0.contains(RegExp(r'^[a-zA-Z0-9- ]*$'))) {
                                return "Special characters are not allowed (except -)";
                              }

                              if (p0.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .tournamentNameCannotContainEmojis;
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
                                  errorSnackBar(AppLocalizations.of(context)!
                                      .tournamentStartDateShouldBeLessThanEndDate);
                                  return;
                                }
                                from = e;
                              });
                            },
                            onToChanged: (e) {
                              setState(() {
                                if (from == null) {
                                  errorSnackBar(AppLocalizations.of(context)!
                                      .pleaseSelectTournamentStartDate);
                                  return;
                                }
                                if (e.isBefore(from!)) {
                                  errorSnackBar(AppLocalizations.of(context)!
                                      .tournamentEndDateShouldBeGreaterThanStartDate);
                                  return;
                                }
                                to = e;
                              });
                            },
                          ),
                          Text(AppLocalizations.of(context)!.tournamentCategory,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          DropDownWidget(
                            title: AppLocalizations.of(context)!
                                .selectTournamentCategory,
                            onSelect: (e) {
                              setState(() {
                                tournamentType = e;
                              });
                              // Get.back();
                              Get.close();
                            },
                            selectedValue: tournamentType.toUpperCase(),
                            items: const [
                              'turf',
                              'corporate',
                              'series',
                              'open'
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(AppLocalizations.of(context)!.ballType,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          DropDownWidget(
                            title: AppLocalizations.of(context)!.selectBallType,
                            onSelect: (e) {
                              setState(() {
                                ballType = e;
                              });
                              // Get.back();
                              Get.close();
                            },
                            selectedValue: ballType.toUpperCase(),
                            items: const [
                              'tennis',
                              'leather',
                              'others',
                            ],
                          ),
                          tournamentType == "turf"
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!.pitchType,
                                        style: Get.textTheme.headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 16)),
                                    DropDownWidget(
                                      title: AppLocalizations.of(context)!
                                          .selectPitchType,
                                      onSelect: (e) {
                                        setState(() {
                                          pitchType = e;
                                        });
                                        Get.close();
                                        Get.close();
                                      },
                                      selectedValue: pitchType.toUpperCase(),
                                      items: const [
                                        'rough',
                                        'cement',
                                      ],
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 9,
                          ),
                          FormInput(
                            controller: TextEditingController(
                                text: authController.state!.fullName),
                            label: AppLocalizations.of(context)!.organizerName,
                            enabled: false,
                            readOnly: true,
                          ),
                          FormInput(
                            controller: TextEditingController(
                                text: authController.state!.phoneNumber),
                            label: AppLocalizations.of(context)!
                                .organizerContactNo,
                            enabled: false,
                            readOnly: true,
                            textInputType: TextInputType.number,
                          ),
                          FormInput(
                            controller: _cohost1Name,
                            label: AppLocalizations.of(context)!.cohost1Name,
                            textInputType: TextInputType.text,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return null;
                              }
                              if (e[0] == " ") {
                                return "First character should not be a space";
                              }
                              if (e.trim().isEmpty &&
                                  _cohost1Phone.text.isNotEmpty) {
                                return "Please enter co-host 1 name";
                              }
                              if (_cohost1Phone.text.isEmpty && e.isNotEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterCohost1ContactNo;
                              }
                              // first character should be a alphabet
                              if (e.isNotEmpty &&
                                  !RegExp(r'^[a-zA-Z]+$').hasMatch(e[0])) {
                                return "First character should be an alphabet";
                              }
                              if (!e.contains(RegExp(r'^[a-zA-Z0-9- ]*$'))) {
                                return "Please enter valid name";
                              }

                              // if (e.contains(RegExp(
                              //     r'[^\x00-\x7F\uD800-\uDBFF\uDC00-\uDFFF]+'))) {
                              //   return AppLocalizations.of(context)!
                              //       .rulesCannotContainEmojis;
                              // }
                              return null;
                            },
                          ),
                          FormInput(
                            controller: _cohost1Phone,
                            label:
                                AppLocalizations.of(context)!.cohost1ContactNo,
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return null;
                              }
                              if (e.trim().isEmpty) {
                                return "First character should not be a space";
                              }
                              if ((_cohost1Name.text.isNotEmpty) && e.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterCohost1ContactNo;
                              }

                              if ((_cohost1Name.text.isEmpty) && e.isNotEmpty) {
                                return "Please enter co-host 1 name";
                              }

                              if (!RegExp(r'^\d+$').hasMatch(e)) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidCohost1ContactNo;
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .rulesCannotContainEmojis;
                              }
                              if (_cohost2Phone.text == e) {
                                return AppLocalizations.of(context)!
                                    .cohost1AndCohost2ContactNoCannotBeSame;
                              }
                              if (e.length != 10) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidContactNo;
                              }
                              return null;
                            },
                          ),
                          FormInput(
                            controller: _cohost2Name,
                            label: AppLocalizations.of(context)!.cohost2Name,
                            textInputType: TextInputType.text,
                            validator: (e) {
                              if (e!.trim().isEmpty &&
                                  _cohost2Phone.text.isNotEmpty) {
                                return "Please enter co-host 2 name";
                              }
                              if (_cohost2Phone.text.trim().isEmpty &&
                                  e.isNotEmpty) {
                                return 'Please enter co-host 2 contact no';
                              }
                              if (e.isNotEmpty &&
                                  !RegExp(r'^[a-zA-Z]+$').hasMatch(e[0])) {
                                return "First character should be an alphabet";
                              }
                              if (!e.contains(RegExp(r'^[a-zA-Z0-9- ]*$'))) {
                                return "Please enter valid name";
                              }

                              // if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                              //   return AppLocalizations.of(context)!
                              //       .rulesCannotContainEmojis;
                              // }
                              return null;
                            },
                          ),
                          FormInput(
                            controller: _cohost2Phone,
                            label:
                                AppLocalizations.of(context)!.cohost2ContactNo,
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            validator: (e) {
                              if ((_cohost2Name.text.isNotEmpty) &&
                                  e!.trim().isEmpty) {
                                return 'Please enter co-host 2 contact no';
                              }
                              if (e!.trim().isEmpty) {
                                return null;
                              }
                              if (!RegExp(r'^\d+$').hasMatch(e)) {
                                return 'Please enter co-host 2 contact no';
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .rulesCannotContainEmojis;
                              }
                              if (_cohost1Phone.text == e) {
                                return AppLocalizations.of(context)!
                                    .cohost1AndCohost2ContactNoCannotBeSame;
                              }
                              if (e.length != 10) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidContactNo;
                              }
                              return null;
                            },
                          ),
                          FormInput(
                            controller: _rulesController,
                            label: AppLocalizations.of(context)!.rules,
                            textInputType: TextInputType.multiline,
                            validator: (e) {
                              if (e!.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterRules;
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
                            label: AppLocalizations.of(context)!.prizes,
                            maxLines: 3,
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
                            label: AppLocalizations.of(context)!
                                .selectStadiumAddress,
                            readOnly: true,
                            onTap: () async {
                              // Get.dialog(const Dialog(
                              //   child: Padding(
                              //     padding: EdgeInsets.all(28.0),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         CircularProgressIndicator(),
                              //       ],
                              //     ),
                              //   ),
                              // ));

                              // Get.back();
                              Get.to(
                                () => SelectLocationScreen(
                                  onSelected: (e, l) {
                                    setState(() {
                                      _addressController.text = e;
                                    });
                                    if (l != null) {
                                      setState(() {
                                        location = l;
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   SnackBar(content: Text(l.toString())),
                                        // );
                                        logger.d("The Location is $l");
                                      });
                                    }
                                    // if(l==null){
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(
                                    //       content: Text("Location not selected"),
                                    //     ),
                                    //   );
                                    // }

                                    FocusScope.of(context).unfocus();
                                  },
                                  initialLocation: LatLng(
                                      location.latitude, location.longitude),
                                ),
                              );
                            },
                          ),
                          FormInput(
                            controller: _entryFeeController,
                            label: AppLocalizations.of(context)!.entryFee,
                            validator: (e) {
                              if (e == null || e.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterEntryFee;
                              }
                              if (!RegExp(r'^\d+$').hasMatch(e)) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidEntryFee;
                              }
                              if (e.startsWith('0')) {
                                return AppLocalizations.of(context)!
                                    .entryFeeCannotStartWith0;
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .rulesCannotContainEmojis;
                              }
                              return null;
                            },
                            maxLength: 9,
                            textInputType: TextInputType.number,
                          ),
                          FormInput(
                            controller: _ballChargesController,
                            label: AppLocalizations.of(context)!.ballCharges,
                            validator: (e) {
                              if (e == null || e.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterBallCharges;
                              }
                              if (!RegExp(r'^\d+$').hasMatch(e)) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidBallCharges;
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .rulesCannotContainEmojis;
                              }
                              return null;
                            },
                            maxLength: 6,
                            textInputType: TextInputType.number,
                          ),
                          FormInput(
                            controller: _breakfastChargesController,
                            label:
                                AppLocalizations.of(context)!.breakfastCharges,
                            textInputType: TextInputType.number,
                            validator: (e) {
                              if (e == null || e.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterBreakfastCharges;
                              }
                              if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(e)) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidBreakfastCharges;
                              }
                              if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidBreakfastCharges;
                              }
                              return null;
                            },
                            maxLength: 6,
                          ),
                          FormInput(
                            controller: _teamLimitController,
                            label: AppLocalizations.of(context)!.teamLimit,
                            validator: (e) {
                              if (e == null || e.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterTeamLimit;
                              } else if (!RegExp(r'^\d+$').hasMatch(e)) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterValidTeamLimit;
                              } else if (int.parse(e) < 2) {
                                return AppLocalizations.of(context)!
                                    .teamLimitShouldBeEqualOrGreaterThan2;
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
              ],
            ),
          ),
        ));
  }
}
