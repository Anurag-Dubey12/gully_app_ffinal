import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/model/package_model.dart';
import 'package:gully_app/ui/screens/banner_payment_page.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/controller/banner_promotion_controller.dart';
import '../../../data/controller/misc_controller.dart';
import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/PromotionalBannerModel.dart';
import '../../../data/model/tournament_model.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/geo_locator_helper.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/home_screen.dart';
import '../create_tournament/form_input.dart';
import '../create_tournament/top_card.dart';
import '../gradient_builder.dart';
import '../primary_button.dart';
import 'package_screen.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (17, 5);

  @override
  String get name => '2x3 (customized)';
}

class BannerAdding extends StatefulWidget {
  final PromotionalBanner? banner;
  const BannerAdding({super.key, this.banner});
  @override
  State<StatefulWidget> createState() => BannerAddingState();
}

class BannerAddingState extends State<BannerAdding> {
  PromotionalBanner? advertisementModel;
  DateTime? from;
  DateTime? to;
  XFile? _image;
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController bannerTitleController = TextEditingController();
  final tournamentController = Get.find<TournamentController>();
  TournamentModel? selectedTournament;
  Map<String, dynamic>? selectedPackage;
  bool isInfoShown = false;
  DateTime now = DateTime.now();
  DateTime? endDate;
  Package? package;

  @override
  void initState() {
    if (widget.banner != null) {
      bannerTitleController.text = widget.banner!.bannerTitle;
      _addressController.text = widget.banner!.bannerlocationaddress;
      from = widget.banner?.startDate;
      to = widget.banner?.endDate;
      endDate = widget.banner!.endDate;
      selectedPackage = {
        'package': {
          '_id': widget.banner!.packageId.id,
          'name': widget.banner!.packageId.name,
          'price': widget.banner!.packageId.price,
          'duration': widget.banner!.packageId.duration,
        }
      };
    }
    fetchLocation();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Promotional Banner ',
              toolbarColor: AppTheme.primaryColor,
              toolbarWidgetColor: Colors.white,
              statusBarColor: AppTheme.primaryColor,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio5x4,
              ],
            ),
            IOSUiSettings(
              title: 'Promotional Banner',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPresetCustom(),
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          final File file = File(croppedFile.path);
          final decodedImage =
              await decodeImageFromList(file.readAsBytesSync());
          // if (decodedImage.width >= 100 && decodedImage.height >= 560) {
          if (decodedImage != null) {
            final String extension = image.path.split('.').last.toLowerCase();
            // if (decodedImage.width == decodedImage.height) {
            //   errorSnackBar('Image Width And the Height Cannot be the same.',
            //       title: "Invalid file!");
            //   return;
            // }
            if (extension == 'png' ||
                extension == 'jpg' ||
                extension == 'jpeg') {
              setState(() {
                _image = XFile(file.path);
              });
            } else {
              _image = null;
              errorSnackBar('Please select a PNG or JPG image.',
                  title: "Invalid file format!");
            }
          } else {
            errorSnackBar(
                'Please select an image with dimensions where \nWidth=1000 \nHeight=560.',
                title: "Invalid image dimensions!");
          }
        }
      }
    } catch (e) {
      //logger.d'Error picking image: $e');
      errorSnackBar('An error occurred while picking the image.',
          title: "Error");
    }
  }

  late LatLng location;
  fetchLocation() async {
    final postion = await determinePosition();
    location = LatLng(postion.latitude, postion.longitude);
    setState(() {});
  }

  bool isInfoSheetShown = false;
  Future<void> showInfoSheet(BuildContext context) async {
    if (!isInfoSheetShown) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orange,
                    size: 60.0,
                  ),
                  const SizedBox(height: 12),

                  // Title Text
                  const Text(
                    'Important Notice',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message Content
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      AppConstants.bannerwarningtext,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PrimaryButton(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage();
                      },
                      title: 'Got it, Let’s Go!',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );
    } else {
      pickImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final MiscController connectionController = Get.find<MiscController>();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.banner != null ? 'Edit Banner' : 'Promote Banner',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: !connectionController.isConnected.value
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.signal_wifi_off,
                          size: 48,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No internet connection',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            showInfoSheet(context);
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
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          width: Get.width,
                                          height: 200,
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
                                  )
                                : widget.banner?.bannerImage != null
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
                                                      .banner!.bannerImage),
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
                                            Text('Add Banner Photo',
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
                        const SizedBox(height: 10),
                        FormInput(
                          controller: bannerTitleController,
                          label: "Banner Title",
                          textInputType: TextInputType.text,
                          iswhite: false,
                          filled: true,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return null;
                            }
                            if (e[0] == " ") {
                              return "First character should not be a space";
                            }
                            if (e.trim().isEmpty) {
                              return "Please enter Banner Title";
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
                          controller: _addressController,
                          label: 'Select Banner Location',
                          readOnly: true,
                          isinfo: true,
                          enabled: widget.banner != null ? false : true,
                          infotitle: AppConstants.bannerlocInfo,
                          infotext: AppConstants.bannerinfotext,
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
                                      //logger.d"The Location is $l");
                                    });
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                                initialLocation: LatLng(
                                    location.latitude, location.longitude),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text("Select Your Suitable Banner Package",
                            style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: Get.width,
                          child: GestureDetector(
                            onTap: () async {
                              if (widget.banner != null) {
                                errorSnackBar(
                                    "You are not able to edit banner package");
                              } else {
                                final result = await Get.to(() =>
                                    PackageScreen(package: selectedPackage));
                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  setState(() {
                                    selectedPackage =
                                        result.containsKey('package')
                                            ? (result['package'] is Map
                                                ? result
                                                : null)
                                            : null;
                                    //logger.d
                                    // "Selected Package Id:${selectedPackage!['package']['_id']}");
                                    if (from != null &&
                                        selectedPackage != null) {
                                      to = calculateEndDate(
                                          from!, selectedPackage!['package']);
                                    }
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                selectedPackage == null ||
                                        selectedPackage!.isEmpty
                                    ? 'Tap here to select a package'
                                    : '${selectedPackage!['package']['name']} for ₹${selectedPackage!['package']['price']}',
                                style: const TextStyle(color: Colors.black54),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        selectedPackage != null
                            ? TopCard(
                                from: from,
                                key: const Key('date_picker'),
                                to: to,
                                controller: _DateController,
                                onFromChanged: (e) {
                                  setState(() {
                                    if (selectedPackage != null) {
                                      from = e;
                                      to = calculateEndDate(
                                          from!, selectedPackage!['package']);
                                    }
                                  });
                                },
                                onToChanged: (e) {},
                                isAds: true,
                                isenable: widget.banner != null ? false : true,
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        PrimaryButton(
                            title:
                                widget.banner != null ? 'Update ' : 'Pay Now',
                            isDisabled:
                                !connectionController.isConnected.value ||
                                        widget.banner != null
                                    ? now.isAfter(widget.banner!.endDate)
                                    : false,
                            onTap: () async {
                              try {
                                final controller =
                                    Get.find<PromotionController>();
                                if (widget.banner == null) {
                                  if (_image == null) {
                                    errorSnackBar('Please select an image');
                                    return;
                                  }
                                }
                                if (bannerTitleController.text.isEmpty) {
                                  errorSnackBar("Please enter banner title");
                                  return;
                                }
                                if (selectedPackage == null) {
                                  errorSnackBar("Please select a package");
                                  return;
                                }
                                if (from == null) {
                                  errorSnackBar(
                                      "Please select date for promotion");
                                  return;
                                }
                                String? base64Image;
                                if (_image != null) {
                                  base64Image =
                                      await convertImageToBase64(_image!);
                                }

                                Map<String, dynamic> bannerdata = {
                                  "banner_title": bannerTitleController.text,
                                  "banner_image": _image?.path,
                                  "startDate": from?.toIso8601String(),
                                  "endDate": to?.toIso8601String(),
                                  "bannerlocationaddress":
                                      _addressController.text,
                                  "longitude": location.longitude,
                                  "latitude": location.latitude,
                                  "packageId": selectedPackage!['package']
                                      ['_id'],
                                };
                                if (widget.banner != null) {
                                  await _addBannerInIsolate(context);

                                  bool isOk = await controller
                                      .editBanner(widget.banner!.id, {
                                    'banner_title': bannerTitleController.text,
                                    'banner_image': base64Image ??
                                        widget.banner!.bannerImage,
                                  });
                                  if (isOk) {
                                    Navigator.of(context).pop();
                                    successSnackBar(
                                            'Banner Updated Successfully')
                                        .then((value) => Get.back());
                                    Get.forceAppUpdate();
                                  }
                                } else {
                                  controller.banner.value = bannerdata;
                                  Get.to(() => BannerPaymentPage(
                                        banner: controller.banner.value,
                                        base64: base64Image ?? '',
                                        SelectedPakcage: selectedPackage ?? {},
                                      ));
                                }
                              } catch (e) {
                                errorSnackBar(e.toString());
                                rethrow;
                              }
                            }),
                        const SizedBox(height: 10),
                        widget.banner != null
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      now.isAfter(widget.banner!.endDate)
                                          ? "Your Banner Promotion has expired"
                                          : "Only Banner Title and Image Can Be Edited",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _addBannerInIsolate(BuildContext context) async {
    final receivePort = ReceivePort();
    final progressPort = ReceivePort();
    final progressController = StreamController<double>();
    final completer = Completer<dynamic>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Text(
                  "Uploading Your Banner...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please wait while we upload Your Banner.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    receivePort.listen((message) {
      if (message is String && message == "done" && !completer.isCompleted) {
        completer.complete("done");
      }
    });

    progressPort.listen((message) {
      if (message is double) {
        progressController.add(message);
      }
    });

    compute(_processbannerInIsolate, {
      'sendPort': receivePort.sendPort,
      'progressPort': progressPort.sendPort,
      'image': _image?.path
    });

    final result = await completer.future;

    return result;
  }

  DateTime calculateEndDate(DateTime startDate, Map<String, dynamic> package) {
    if (package['duration'] == null) return startDate;
    final durationString = package['duration'].toString().toLowerCase();
    final durationParts = durationString.split(' ');
    if (durationParts.length != 2) return startDate;
    final number = int.tryParse(durationParts[0]);
    if (number == null) return startDate;
    final unit = durationParts[1].replaceAll(RegExp(r's$'), '');
    switch (unit) {
      case 'day':
        return startDate.add(Duration(days: number));
      case 'week':
        return startDate.add(Duration(days: number * 7));
      case 'month':
        var newMonth = startDate.month + number;
        var newYear = startDate.year;
        while (newMonth > 12) {
          newMonth -= 12;
          newYear++;
        }
        return DateTime(newYear, newMonth, startDate.day);
      case 'year':
        return DateTime(
            startDate.year + number, startDate.month, startDate.day);
      default:
        return startDate;
    }
  }

// Widget _buildSummary() {
//   var duration = (to?.difference(from ?? DateTime.now()).inDays ?? 0) + 1;
//   if (from == null && to == null) {
//     duration = (to?.difference(from ?? DateTime.now()).inDays ?? 0);
//   }
//   double totalAmount = 0;
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Advertisement Summary',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (_image != null) const SizedBox(width: 16),
//         if (advertisementModel!.adPlacement.isNotEmpty)
//           ...advertisementModel!.adPlacement.map((adType) {
//             final screenData =
//                 _screens.firstWhere((s) => s['name'] == adType);
//             final price = screenData['price'] as int;
//             final amount = price * duration;
//             totalAmount += amount;
//             return AdvertisementSummary(
//               label: adType,
//               value: '₹${amount.toStringAsFixed(2)}',
//             );
//           }).toList()
//         else
//           const AdvertisementSummary(
//               label: 'No ad type selected', value: '₹0.00'),
//         const Divider(height: 32),
//         AdvertisementSummary(label: 'Duration', value: '$duration days'),
//         AdvertisementSummary(
//             label: 'Total Amount',
//             value: '₹${totalAmount.toStringAsFixed(2)}'),
//         const SizedBox(height: 8),
//         AdvertisementSummary(
//             label: 'GST (18%)',
//             value: '₹${(totalAmount * 0.18).toStringAsFixed(2)}'),
//         const Divider(height: 32),
//         AdvertisementSummary(
//             label: 'Grand Total',
//             value: '₹${(totalAmount * 1.18).toStringAsFixed(2)}',
//             isBold: true),
//         const SizedBox(height: 24),
//         AdvertisementSummary(
//           label: 'Payment date',
//           value: DateTime.now().toString().substring(0, 11),
//         ),
//         AdvertisementSummary(
//             label: 'Advertisement Start on',
//             value: advertisementModel!.startDate.toString().substring(0, 11)),
//         AdvertisementSummary(
//             label: 'Advertisement End on',
//             value: advertisementModel!.endDate.toString().substring(0, 11)),
//         const AdvertisementSummary(
//             label: 'Payment method', value: 'RazorPay'),
//         const SizedBox(height: 24),
//         PrimaryButton(
//             title: 'Pay Now',
//             onTap: () async {
//               try {
//                 final PromotionController banner =
//                     Get.find<PromotionController>();
//                 if (_image == null) {
//                   errorSnackBar('Please select an image');
//                   return;
//                 }
//                 if (from == null || to == null) {
//                   errorSnackBar("Please select date for promotion");
//                   return;
//                 }
//                 String? base64;
//                 if (_image != null) {
//                   base64 = await convertImageToBase64(_image!);
//                 }
//                 Map<String, dynamic> locationData = {
//                   "point": {
//                     "type": "Point",
//                     "coordinates": [location.longitude, location.latitude]
//                   }
//                 };
//                 Map<String, dynamic> bannerdata = {
//                   "image": base64,
//                   "startDate": from?.toIso8601String(),
//                   "endDate": to?.toIso8601String(),
//                   "locationHistory": locationData,
//                   // "promotionFor": selectedTournament!.id
//                   "promotionFor": "shop"
//                 };
//                 //logger.d
//                     "The tournament is selected :${selectedTournament!.id}");
//                 banner.createBanner(bannerdata);
//                 if (advertisementModel != null) {
//                   advertisementModel = advertisementModel!.copyWith(
//                     startDate: from!,
//                     endDate: to!,
//                     totalAmount: totalAmount * 1.18,
//                   );
//                 }
//                 Get.to(() => BannerPaymentPage(
//                       ads: advertisementModel!,
//                       screens: _screens,
//                     ));
//               } catch (e) {
//                 errorSnackBar(e.toString());
//                 rethrow;
//               }
//             })
//       ],
//     ),
//   );
// }
}

Future<void> _processbannerInIsolate(Map<String, dynamic> args) async {
  final SendPort sendPort = args['sendPort'];
  final SendPort progressPort = args['progressPort'];
  final String image = args['image'];

  int progress = 0;
  sendPort.send("done");
}
