import 'package:geolocator/geolocator.dart';
import 'package:gully_app/utils/app_logger.dart';

Future<Position> determinePosition(
    {LocationAccuracy accuracy = LocationAccuracy.high,
    forceAndroidLocationManager = false}) async {
  try {
    // return await Geolocator.getCurrentPosition(
    //     desiredAccuracy: accuracy, forceAndroidLocationManager: true);
    final position1 = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: forceAndroidLocationManager);
    if (position1 != null) {
      return position1;
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy, forceAndroidLocationManager: true);
    return position;
  } catch (e) {
    logger.e(e.toString());
    // errorSnackBar(e.toString());
    // return Future.error(e.toString());
    rethrow;
  }
}
