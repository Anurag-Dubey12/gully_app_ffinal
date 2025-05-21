// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:gully_app/config/app_constants.dart';
// import 'package:gully_app/utils/app_logger.dart';
// import 'package:gully_app/utils/geo_locator_helper.dart';
// import 'package:gully_app/utils/utils.dart';

// class SearchPlacesScreen extends StatefulWidget {
//   final Function(Prediction)? onSelected;

//   final bool? showSelectCurrentLocation;
//   const SearchPlacesScreen(
//       {Key? key,
//       this.title,
//       this.onSelected,
//       this.showSelectCurrentLocation = false})
//       : super(key: key);

//   final String? title;

//   @override
//   SearchPlacesScreenState createState() => SearchPlacesScreenState();
// }

// class SearchPlacesScreenState extends State<SearchPlacesScreen> {
//   final TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? "Search Location",
//             style: Get.textTheme.headlineSmall),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             (widget.showSelectCurrentLocation ?? false)
//                 ? CupertinoListTile(
//                     leading: const Icon(Icons.location_on, color: Colors.blue),
//                     title: const Text('Use current location',
//                         style: TextStyle(color: Colors.blue, fontSize: 16)),
//                     onTap: () async {
//                       //logger.d'Use current location');
//                       final postion = await determinePosition(
//                           accuracy: LocationAccuracy.medium,
//                           forceAndroidLocationManager: true);
//                       // await successSnackBar(
//                       //     ' ${postion.latitude} ${postion.longitude}');
//                       final address = await getAddressFromLatLng(
//                           postion.latitude, postion.longitude);

//                       widget.onSelected?.call(Prediction(
//                           description: address,
//                           lat: postion.latitude.toString(),
//                           lng: postion.longitude.toString()));
//                       Get.back();
//                       // Get.close();
//                     },
//                   )
//                 : const SizedBox(),
//             const SizedBox(height: 20),
//             placesAutoCompleteTextField(),
//           ],
//         ),
//       ),
//     );
//   }

//   placesAutoCompleteTextField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey: AppConstants.googleApiKey,
//         inputDecoration: const InputDecoration(
//           contentPadding: EdgeInsets.all(8),
//           hintText: "Search your location",
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//         ),
//         textStyle: const TextStyle(color: Colors.black, fontSize: 16),
//         debounceTime: 400,
//         countries: const [
//           "in",
//         ],
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (Prediction prediction) {
//           //logger.d"Selected Place: ${prediction.toJson()}");
//           widget.onSelected?.call(prediction);
//         },

//         itemClick: (Prediction prediction) {
//           //logger.d"Selected Place: ${prediction.toJson()}");
//           controller.text = prediction.description ?? "";
//           widget.onSelected?.call(prediction);
//           controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description?.length ?? 0));
//           if (widget.showSelectCurrentLocation ?? false) Get.back(result: true);
//         },
//         seperatedBuilder: const Divider(),
//         // OPTIONAL// If you want to customize list view item builder
//         itemBuilder: (context, index, Prediction prediction) {
//           //  controller.text = prediction.description ?? "";
//           //   Get.back();
//           //   controller.selection = TextSelection.fromPosition(
//           //       TextPosition(offset: prediction.description?.length ?? 0));
//           //   widget.onSelected?.call(prediction);
//           return Container(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 Expanded(child: Text(prediction.description ?? ""))
//               ],
//             ),
//           );
//         },
//         isCrossBtnShown: true,
//         // default 600 ms ,
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchPlacesScreen extends StatefulWidget {
  final Function(Prediction)? onSelected;
  final bool? showSelectCurrentLocation;
  final String? title;

  const SearchPlacesScreen({
    Key? key,
    this.title,
    this.onSelected,
    this.showSelectCurrentLocation = false,
  }) : super(key: key);

  @override
  SearchPlacesScreenState createState() => SearchPlacesScreenState();
}

class SearchPlacesScreenState extends State<SearchPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Search Location",
            style: Get.textTheme.headlineSmall),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (widget.showSelectCurrentLocation ?? false)
            CupertinoListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text('Use current location',
                  style: TextStyle(color: Colors.blue, fontSize: 16)),
              onTap: () async {
                final position = await determinePosition(
                  accuracy: LocationAccuracy.medium,
                  forceAndroidLocationManager: true,
                );
                final address = await getAddressFromLatLng(
                    position.latitude, position.longitude);

                widget.onSelected?.call(Prediction(
                  description: address,
                  lat: position.latitude.toString(),
                  lng: position.longitude.toString(),
                ));

                Get.back();
              },
            ),
          const SizedBox(height: 10),
          Expanded(
            child: GoogleMapSearchPlacesApi(
              onPlaceSelected: (description, lat, lng) {
                widget.onSelected?.call(Prediction(
                  description: description,
                  lat: lat,
                  lng: lng,
                ));
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleMapSearchPlacesApi extends StatefulWidget {
  final Function(String description, String lat, String lng) onPlaceSelected;

  const GoogleMapSearchPlacesApi({Key? key, required this.onPlaceSelected})
      : super(key: key);

  @override
  _GoogleMapSearchPlacesApiState createState() =>
      _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  _onChanged() {
    if (_sessionToken.isEmpty) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String PLACES_API_KEY = AppConstants.googleApiKey;

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPlaceDetails(String placeId, String description) async {
    const String PLACES_API_KEY = AppConstants.googleApiKey;

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?placeid=$placeId&key=$PLACES_API_KEY';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'OK') {
          var result = data['result'];
          double lat = result['geometry']['location']['lat'];
          double lng = result['geometry']['location']['lng'];

          widget.onPlaceSelected(description, lat.toString(), lng.toString());
        } else {
          throw Exception('Failed to load place details');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search your location here",
              prefixIcon: const Icon(Icons.map),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _controller.clear();
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(_placeList[index]["description"]),
                onTap: () async {
                  String placeId = _placeList[index]["place_id"];
                  String description = _placeList[index]["description"];
                  await getPlaceDetails(placeId, description);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
