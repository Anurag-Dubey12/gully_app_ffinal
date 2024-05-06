import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:gully_app/utils/utils.dart';

class SearchPlacesScreen extends StatefulWidget {
  final Function(Prediction)? onSelected;

  final bool? showSelectCurrentLocation;
  const SearchPlacesScreen(
      {Key? key,
      this.title,
      this.onSelected,
      this.showSelectCurrentLocation = false})
      : super(key: key);

  final String? title;

  @override
  SearchPlacesScreenState createState() => SearchPlacesScreenState();
}

class SearchPlacesScreenState extends State<SearchPlacesScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Search Stadium",
            style: Get.textTheme.headlineSmall),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            (widget.showSelectCurrentLocation ?? false)
                ? CupertinoListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: const Text('Use current location',
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    onTap: () async {
                      final postion = await determinePosition();
                      final address = await getAddressFromLatLng(
                          postion.latitude, postion.longitude);
                      widget.onSelected?.call(Prediction(
                          description: address,
                          lat: postion.latitude.toString(),
                          lng: postion.longitude.toString()));
                      Get.back();
                    },
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            placesAutoCompleteTextField(),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,

        googleAPIKey: "AIzaSyCUv3LmufUU86Lp_Wk34-3AZ3bnCQ3XmJg",
        inputDecoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        textStyle: const TextStyle(color: Colors.black, fontSize: 16),
        debounceTime: 400,
        countries: const [
          "in",
        ],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          logger.d("Selected Place: ${prediction.toJson()}");
          widget.onSelected?.call(prediction);
        },

        itemClick: (Prediction prediction) {
          logger.d("Selected Place: ${prediction.toJson()}");
          controller.text = prediction.description ?? "";
          widget.onSelected?.call(prediction);
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          if (widget.showSelectCurrentLocation ?? false) Get.back();
        },
        seperatedBuilder: const Divider(),
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          //  controller.text = prediction.description ?? "";
          //   Get.back();
          //   controller.selection = TextSelection.fromPosition(
          //       TextPosition(offset: prediction.description?.length ?? 0));
          //   widget.onSelected?.call(prediction);
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text(prediction.description ?? ""))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}
