import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/ui/screens/search_places_screen.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../theme/theme.dart';

class SelectLocationScreen extends StatefulWidget {
  final Function(String address, LatLng? selectedLocation) onSelected;
  final LatLng? initialLocation;
  const SelectLocationScreen(
      {super.key, required this.onSelected, this.initialLocation});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLocation().then((value) {
        _kGooglePlex = CameraPosition(
          target:
              widget.initialLocation ?? LatLng(value.latitude, value.longitude),
          zoom: 14.4746,
        );
      });
    });
  }

  bool isLoading = true;
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  var markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: PopScope(
        // canPop: false,
        child: GradientBuilder(
            child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [
              Color(0xff5FBCFF),
              Color.fromARGB(34, 95, 188, 255),
            ], stops: [
              0.2,
              0.9,
            ], center: Alignment.topLeft),
          ),
          child: PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              // bottomNavigationBar: Container(
              //   height: 65,
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
              //             horizontal: 10.0, vertical: 5),
              //         child: PrimaryButton(
              //           onTap: () async {
              //             showModalBottomSheet(
              //                 context: context,
              //                 backgroundColor: Colors.grey.shade300,
              //                 showDragHandle: true,
              //                 isScrollControlled: true,
              //                 builder: (c) {
              //                   return _AddManualPlace(
              //                     onSelected: (e) {
              //                       widget.onSelected.call(e, null);
              //                       Get.back();
              //                     },
              //                   );
              //                 });
              //             setState(() {});
              //           },
              //           title: 'Add Manually',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              body: Stack(children: [
                Positioned(
                    top: 0,
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 30),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: BackButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.07,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text('Select a location',
                                          style: Get.textTheme.headlineSmall
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: Get.height * 0.04),
                                  ],
                                )),
                            // Add location search bar white container with text field and search icon
                            _SearchBar(
                              onSelected: (e, l) {
                                logger.i(e);
                                logger.i("SELECTED");
                                widget.onSelected.call(e, l);
                                Get.back();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SizedBox(
                                width: Get.width,
                                height: Get.height * 0.3,
                                // color: Colors.grey[200],
                                child: GoogleMap(
                                  markers: Set<Marker>.of(markers.values),
                                  mapType: MapType.hybrid,
                                  fortyFiveDegreeImageryEnabled: false,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    _controller.complete(controller);
                                    markers.clear();
                                    markers[const MarkerId('1')] = Marker(
                                      markerId: const MarkerId('1'),
                                      position: LatLng(
                                          widget.initialLocation!.latitude,
                                          widget.initialLocation!.longitude),
                                    );
                                    controller.animateCamera(
                                        CameraUpdate.newLatLng(LatLng(
                                            widget.initialLocation!.latitude,
                                            widget
                                                .initialLocation!.longitude)));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 28, vertical: 10),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text('Saved Locations',
                            //           style: Get.textTheme.headlineMedium
                            //               ?.copyWith(
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.black)),
                            //       ListView.separated(
                            //           itemCount: 4,
                            //           shrinkWrap: true,
                            //           padding: const EdgeInsets.only(
                            //               bottom: 30, top: 30),
                            //           separatorBuilder: (context, index) =>
                            //               const SizedBox(height: 20),
                            //           itemBuilder: (context, index) {
                            //             return Container(
                            //               decoration: BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius:
                            //                     BorderRadius.circular(10),
                            //               ),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(18.0),
                            //                 child: Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Text('Thakur Stadium',
                            //                         style: Get
                            //                             .textTheme.bodyMedium
                            //                             ?.copyWith(
                            //                                 fontWeight:
                            //                                     FontWeight.bold,
                            //                                 color:
                            //                                     Colors.black)),
                            //                     const SizedBox(height: 10),
                            //                     Text('409/c, D.S Road',
                            //                         style: Get
                            //                             .textTheme.labelMedium
                            //                             ?.copyWith(
                            //                                 color:
                            //                                     Colors.grey)),
                            //                   ],
                            //                 ),
                            //               ),
                            //             );
                            //           })
                            //     ],
                            //   ),
                            // )
                          ]),
                    )),
              ]),
            ),
          ),
        )),
      ),
    );
  }
}

class _AddManualPlace extends StatefulWidget {
  final Function(String address)? onSelected;
  const _AddManualPlace({
    required this.onSelected,
  });

  @override
  State<_AddManualPlace> createState() => _AddManualPlaceState();
}

class _AddManualPlaceState extends State<_AddManualPlace> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _nearbyLandmarkController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        // height: 200,
        color: Colors.grey.shade300,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Add a place manually',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black)),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _placeNameController,
                  filled: true,
                  hintText: 'Enter a place name',
                  validator: (e) {
                    if (e!.isEmpty) {
                      return 'Please enter a place name';
                    }
                    // check if the name contains emojis
                    if (e.contains(RegExp(r'[^\x00-\x7F]+'))) {
                      return 'Name cannot contain emojis';
                    }
                    // check if the name contains only numbers

                    // check if the name contains only special characters
                    if (e.contains(
                        RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                      return 'Name cannot contain special characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _nearbyLandmarkController,
                  filled: true,
                  hintText: 'Nearby Landmark',
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSelected?.call(
                          "${_placeNameController.text} ${_nearbyLandmarkController.text}");
                    }
                  },
                  title: 'Add',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Function(String address, LatLng? latlng)? onSelected;
  const _SearchBar({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: Get.width * 0.86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.search, color: AppTheme.secondaryYellowColor),
            ),
            Expanded(
              child: TextField(
                onTap: () {
                  Get.to(() => SearchPlacesScreen(
                        onSelected: (e) {
                          onSelected?.call(
                              e.description ?? "No Address",
                              e.lat == null
                                  ? null
                                  : LatLng(double.parse(e.lat!),
                                      double.parse(e.lng!)));
                        },
                      ));
                },
                decoration: InputDecoration(
                  hintText: 'Search for a location',
                  hintStyle: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
