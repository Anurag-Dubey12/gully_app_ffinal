import 'package:geolocator/geolocator.dart';
import 'package:gully_app/utils/app_logger.dart';

Future<Position> determinePosition() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;
    logger.d('determinePosition');

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    logger.d('serviceEnabled: $serviceEnabled');
    if (!serviceEnabled) {
      logger.d('Location services are disabled.');
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      logger.d('Location permissions are denied');
      logger.d('Requesting location permissions');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        logger.d('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.d(
          'Location permissions are permanently denied, we cannot request permissions.');
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  } catch (e) {
    logger.e(e.toString());
    return Future.error(e.toString());
  }
}
