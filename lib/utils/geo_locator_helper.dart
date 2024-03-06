import 'package:geolocator/geolocator.dart';
import 'package:gully_app/utils/app_logger.dart';

Future<Position> determinePosition() async {
  try {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    logger.e(e.toString());
    return Future.error(e.toString());
  }
}
