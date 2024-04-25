import 'package:geolocator/geolocator.dart';
import 'package:gully_app/utils/app_logger.dart';

Future<Position> determinePosition(
    {LocationAccuracy accuracy = LocationAccuracy.high}) async {
  try {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy, forceAndroidLocationManager: true);
  } catch (e) {
    logger.e(e.toString());
    return Future.error(e.toString());
  }
}
