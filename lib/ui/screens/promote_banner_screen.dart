import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/ui/screens/banner_payment_page.dart';
import 'package:gully_app/ui/screens/select_location.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/AdvertisementModel.dart';
import '../../utils/app_logger.dart';
import '../../utils/geo_locator_helper.dart';
import '../../utils/utils.dart';
import '../widgets/advertisement/advertisement_summary.dart';
import '../widgets/create_tournament/form_input.dart';
import '../widgets/create_tournament/top_card.dart';
import '../widgets/custom_drop_down_field.dart';
import '../widgets/gradient_builder.dart';
import '../widgets/home_screen/top_header.dart';
import '../widgets/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromoteBannerScreen extends StatefulWidget {
  const PromoteBannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => AdsScreen();
}

class AdsScreen extends State<PromoteBannerScreen> {
  AdvertisementModel? advertisementModel;
  List<String> selectedAdsTypes = [];
  DateTime? from;
  DateTime? to;
  XFile? _image;
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late LatLng location;

  final List<Map<String, dynamic>> _screens = [
    {'name': 'Home Screen', 'price': 100},
    {'name': 'Score Summary', 'price': 50},
    {'name': 'Search Screen', 'price': 50},
  ];



  Future<void> pickImage() async {
  final ImagePicker picker = ImagePicker();
  try{
    final XFile? image=await picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      final File file=File(image.path);
      final decodedImage=await decodeImageFromList(file.readAsBytesSync());
      if(decodedImage.width>=100 && decodedImage.height>=560){
        final String extension=image.path.split('.').last.toLowerCase();
        if(decodedImage.width==decodedImage.height){
          _showErrorDialog('Invalid file ', 'Image Width And the Height Cannot be the same.');
        }
        if(extension=='png' || extension=='jpg'|| extension=='jpeg'){
          setState(() {
            _image=image;
            advertisementModel = advertisementModel!.copyWith(imageUrl: image.path);
          });
        } else {
          _showErrorDialog('Invalid file format', 'Please select a PNG or JPG image.');
        }
      } else {
        _showErrorDialog('Invalid image dimensions', 'Please select an image with dimensions where \nWidth=1000 \nHeight=560.');
      }
    }
  } catch (e) {
    logger.d('Error picking image: $e');
    _showErrorDialog('Error', 'An error occurred while picking the image.');
  }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    title: 'Ok',
                    onTap: (){
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        );
      },
    );
  }
  fetchLocation() async {
    final postion = await determinePosition();
    location = LatLng(postion.latitude, postion.longitude);
    setState(() {});
  }
// String? base64;
  // if (_image != null) {
  // base64 =
  // await convertImageToBase64(_image!);
  // }
  @override
  void initState() {
    advertisementModel = AdvertisementModel(
      id: '',
      userId: '',
      imageUrl: '',
      adPlacement: [],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
      totalAmount: 0,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    fetchLocation();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Promote Your Banner',
              style: TextStyle(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo),
                                  Text('Add Banner Photo',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropDownWidget(
                    title: "Promote Your Banner On",
                    onSelect: (dynamic selectedItems) {
                      setState(() {
                        if (selectedItems is List<String>) {
                          selectedAdsTypes = selectedItems;
                          advertisementModel = advertisementModel!.copyWith(adPlacement: selectedItems);

                        } else if (selectedItems is String) {
                          selectedAdsTypes = [selectedItems];
                          advertisementModel = advertisementModel!.copyWith(adPlacement: [selectedItems]);

                        }
                      });
                    },
                    selectedValue: selectedAdsTypes,
                    items: const [
                      'Home Screen',
                      'Score Summary',
                      'Search Screen',
                    ],
                    isAds: true,
                  ),
                  const SizedBox(height: 10),
                  TopCard(
                    from: from,
                    key: const Key('date_picker'),
                    to: to,
                    controller: _DateController,
                    onFromChanged: (e) {
                      setState(() {
                        if (to != null && e.isAfter(to)) {
                          errorSnackBar(AppLocalizations.of(context)!
                              .tournamentStartDateShouldBeLessThanEndDate);
                          // return;
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
                    }, isAds: true,
                  ),
                  FormInput(
                    controller: _addressController,
                    label: 'Select ',
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
                          initialLocation: LatLng(
                              location.latitude, location.longitude),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                    _buildSummary(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    var duration = (to?.difference(from ?? DateTime.now()).inDays ?? 0) + 1;
   if(from ==null &&to==null ) {
     duration=(to?.difference(from ?? DateTime.now()).inDays ?? 0) ;
   }
    double totalAmount = 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advertisement Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (_image != null) const SizedBox(width: 16),
          if (advertisementModel!.adPlacement.isNotEmpty)
            ...advertisementModel!.adPlacement.map((adType) {
              final screenData = _screens.firstWhere((s) => s['name'] == adType);
              final price = screenData['price'] as int;
              final amount = price * duration;
              totalAmount += amount;
              return AdvertisementSummary(
                label: adType,
                value: '₹${amount.toStringAsFixed(2)}',
              );
            }).toList()
          else
            const AdvertisementSummary(label: 'No ad type selected', value: '₹0.00'),
          const Divider(height: 32),
          AdvertisementSummary(label: 'Duration', value: '$duration days'),
          AdvertisementSummary(label: 'Total Amount', value: '₹${totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          AdvertisementSummary(label: 'GST (18%)', value: '₹${(totalAmount * 0.18).toStringAsFixed(2)}'),
          const Divider(height: 32),
          AdvertisementSummary(
              label: 'Grand Total',
              value: '₹${(totalAmount * 1.18).toStringAsFixed(2)}',
              isBold: true
          ),
          const SizedBox(height: 24),
          AdvertisementSummary(
              label: 'Payment date',
            value: DateTime.now().toString().substring(0, 11),
          ),
          AdvertisementSummary(
              label: 'Advertisement Start on',
              value:advertisementModel!.startDate.toString().substring(0, 11)
          ),
          AdvertisementSummary(
              label: 'Advertisement End on',
              value:advertisementModel!.endDate.toString().substring(0, 11)),
          const AdvertisementSummary(
              label: 'Payment method',value:  'RazorPay'),
          const SizedBox(height: 24),
          PrimaryButton(
              title: 'Pay Now',
              onTap:   () {
                if (advertisementModel != null) {
                  advertisementModel = advertisementModel!.copyWith(
                    startDate: from!,
                    endDate: to!,
                    totalAmount: totalAmount* 1.18,
                  );
                  Get.to(() => BannerPaymentPage(
                    ads: advertisementModel!,
                    screens: _screens,

                  ));
                }
              }
          )
        ],
      ),
    );
  }

}
