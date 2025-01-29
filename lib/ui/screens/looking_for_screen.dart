import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/model/looking_for_model.dart';
import 'package:gully_app/ui/screens/search_places_screen.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../data/controller/tournament_controller.dart';
import '../../utils/app_logger.dart';
import '../../utils/internetConnectivty.dart';
import '../theme/theme.dart';
import '../widgets/custom_drop_down_field.dart';
import 'home_screen.dart';

class LookingForScreen extends StatefulWidget {
  const LookingForScreen({super.key});

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends State<LookingForScreen> {
  LatLng? location;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? selectedValue;
  bool isFirstBuild = true;
  final Internetconnectivty _connectivityService = Internetconnectivty();
  bool _isConnected = true;
  @override
  initState() {
    super.initState();
    logger.d("Connectivity Status:$_isConnected");
    _connectivityService.listenToConnectionChanges((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
      if (!isConnected) {
        errorSnackBar("Please connect to the network");
      }
    });
  }
  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final MiscController miscController = Get.find<MiscController>();
    if (isFirstBuild) {
      _contactController.text = authController.state!.phoneNumber ?? "";
      isFirstBuild = false;
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/sports_icon.png'),
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('What i am looking for?',
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What are you looking for?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropDownWidget(
                  title: 'What Are You Looking  For?',
                  onSelect: (e) {
                    setState(() {
                      selectedValue = e;
                    });
                    // Get.close();
                    // Get.back();
                  },
                  selectedValue: selectedValue,
                  items: const [
                    "I am looking for a team to join as a Bowler",
                    "I am looking for a team to join as a Batsman",
                    "I am looking for a team to join as a Wicket-keeper",
                    "I am looking for a team to join as an All-rounder",
                    "I am looking for a Teammate to join as a Bowler",
                    "I am looking for a Teammate to join as a Batsman",
                    "I am looking for a Teammate to join as a Wicket-keeper",
                    "I am looking for a Teammate to join as an All-rounder"
                  ], isAds: false,
                ),
                const SizedBox(height: 5),
                FormInput(
                  controller: _addressController,
                  label: 'Select Location',
                  readOnly: true,
                  onTap: () async {
                    Get.dialog(const Dialog(
                        child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    )));
                    // Get.back();
                    Get.close();
                    Get.to(
                      () => SearchPlacesScreen(
                        onSelected: (e) {
                          setState(() {
                            _addressController.text = e.description!;
                          });
                          if (e.lat != null) {
                            setState(() {
                              location = LatLng(
                                  double.parse(e.lat!), double.parse(e.lng!));
                            });
                            logger.d('location: ${e.lat} ${e.lng}');
                            Get.back();
                          }
                          FocusScope.of(context).unfocus();
                        },
                        title: null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                const Text('Contact No',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                CustomTextField(
                  controller: _contactController,
                  filled: true,
                  helperText: 'Contact Number',
                  textInputType: TextInputType.number,
                  maxLen: 10,
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: Get.width / 2,
                    child: PrimaryButton(
                      onTap: () async {
                        try {
                          if (selectedValue == null) {
                            errorSnackBar('Please select a role');
                            return;
                          }
                          if (_addressController.text.isEmpty) {
                            errorSnackBar('Please select a location');
                            return;
                          }
                          if (_contactController.text.isEmpty) {
                            errorSnackBar('Please enter a contact number');
                            return;
                          }
                          if (_contactController.text.length < 10) {
                            errorSnackBar(
                                'Please enter a valid contact number');
                            return;
                          }
                          if (location == null) {
                            final authController =
                                Get.find<TournamentController>();
                            location = LatLng(
                                authController.coordinates.value.latitude,
                                authController.coordinates.value.longitude);
                            setState(() {});
                          }
                          miscController.addLookingFor({
                            'latitude': location!.latitude,
                            'longitude': location!.longitude,
                            'role': selectedValue,
                            'placeName': _addressController.text,
                            // 'contact': _contactController.text,
                          });
                          Get.bottomSheet(
                              BottomSheet(
                                  onClosing: () {},
                                  enableDrag: false,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return SizedBox(
                                      width: Get.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Icon(
                                            Icons.verified,
                                            size: 98,
                                            color:
                                                AppTheme.secondaryYellowColor,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Post Submitted Successfully',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Your post has been successfully submitted.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: PrimaryButton(
                                              onTap: () {
                                                Get.offAll(
                                                    () => const HomeScreen(),
                                                    predicate: (route) =>
                                                        route.name ==
                                                        '/HomeScreen');
                                              },
                                              title: 'OK',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 80,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              isDismissible: false,
                              enableDrag: false);
                        } catch (e) {
                          errorSnackBar('Something went wrong $e');
                        }
                      },
                      isLoading: false,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('My Posts',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: _isConnected ? FutureBuilder<List<LookingForPlayerModel>>(
                      future: miscController.getMyLookings(),
                      builder: (context, snapshot) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length ?? 0,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return _PostCard(
                                key: ValueKey(snapshot.data![index].id),
                                post: snapshot.data![index],
                                onDelete: () {
                                  setState(() {});
                                },
                              );
                            });
                      }):const Center(
                    child: Text("No Data Found"),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final LookingForPlayerModel post;
  final Function()? onDelete;
  const _PostCard({
    super.key,
    required this.post,
    this.onDelete,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.post.role} in ${widget.post.location}'),
                  Text(
                      DateFormat('dd MMM yyy hh:mm a')
                          .format(widget.post.createdAt.toLocal()),
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Delete Post',
                          middleText:
                              'Are you sure you want to delete this post?',
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Get.find<MiscController>()
                                      .removeLookingFor(widget.post.id);
                                  Get.back();
                                  setState(() {});
                                  widget.onDelete!();
                                },
                                child: const Text('Delete')),
                          ]);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
