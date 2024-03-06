import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';

class LocationStreamHandler extends StatefulWidget {
  final Widget child;
  const LocationStreamHandler({super.key, required this.child});

  @override
  LocationStreamHandlerState createState() => LocationStreamHandlerState();
}

class LocationStreamHandlerState extends State<LocationStreamHandler> {
  Geolocator location = Geolocator();
  final StreamController<bool> _locationPermissionController =
      StreamController<bool>();

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    Geolocator.getServiceStatusStream().listen((event) {
      logger.i(event);
      checkLocationPermission();
    }, onDone: () {
      logger.i('Done');
    }, onError: (e) {
      logger.e('Error $e');
    });
  }

  void checkLocationPermission() async {
    LocationPermission serviceEnabled = await Geolocator.checkPermission();
    logger.i(serviceEnabled);
    if (serviceEnabled == LocationPermission.denied) {
      serviceEnabled = await Geolocator.requestPermission();
      if (serviceEnabled == LocationPermission.denied ||
          serviceEnabled == LocationPermission.deniedForever) {
        // Service still not enabled, handle accordingly
        _locationPermissionController.add(false);
        return;
      }
    }

    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.deniedForever ||
        permissionStatus == LocationPermission.denied) {
      _locationPermissionController.add(false);
    } else {
      _locationPermissionController.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _locationPermissionController.stream,
      initialData: true, // Assuming permission is granted initially
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          // Location permission denied, navigate to a different page
          return PermissionDeniedPage(
            onGrantPermission: () {
              checkLocationPermission();
            },
          );
        } else {
          // Location permission granted, continue with your main content
          return widget.child;
        }
      },
    );
  }

  @override
  void dispose() {
    _locationPermissionController.close();
    super.dispose();
  }
}

class PermissionDeniedPage extends StatefulWidget {
  final Function onGrantPermission;
  const PermissionDeniedPage({super.key, required this.onGrantPermission});

  @override
  State<PermissionDeniedPage> createState() => _PermissionDeniedPageState();
}

class _PermissionDeniedPageState extends State<PermissionDeniedPage> {
  Geolocator location = Geolocator();
  final StreamController<bool> _locationPermissionController =
      StreamController<bool>();

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    Geolocator.getServiceStatusStream().listen((event) {
      logger.i(event);
      print('$event');
      checkLocationPermission();
    }, onDone: () {
      print('DONE 107');
      logger.i('Done');
    }, onError: (e) {
      logger.e('Error $e');
    });
  }

  void checkLocationPermission() async {
    LocationPermission serviceEnabled = await Geolocator.checkPermission();
    logger.i(serviceEnabled);
    if (serviceEnabled == LocationPermission.denied) {
      serviceEnabled = await Geolocator.requestPermission();
      if (serviceEnabled == LocationPermission.denied ||
          serviceEnabled == LocationPermission.deniedForever) {
        // Service still not enabled, handle accordingly
        _locationPermissionController.add(false);
        return;
      }
    }

    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.deniedForever ||
        permissionStatus == LocationPermission.denied) {
      _locationPermissionController.add(false);
    } else {
      widget.onGrantPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Denied'),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/map.png'),
              height: 200,
            ),
            const Spacer(),
            Text(
              'We need your location to continue.',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text('Please grant location permission to continue.'),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: PrimaryButton(
                onTap: () async {
                  LocationPermission permissionStatus =
                      await Geolocator.checkPermission();
                  if (permissionStatus == LocationPermission.deniedForever) {
                    // Location permission denied, handle accordingly
                    logger.d(' 119 Opening location settings');
                    Geolocator.openLocationSettings();

                    return;
                  } else {
                    final serviceEnabled = await Geolocator.requestPermission();
                    if (serviceEnabled == LocationPermission.deniedForever ||
                        serviceEnabled == LocationPermission.denied) {
                      logger.d('Opening location settings');
                      bool res = await Geolocator.openLocationSettings();
                      logger.d('res $res');
                      // Service still not enabled, handle accordingly

                      return;
                    }

                    if (serviceEnabled == LocationPermission.always ||
                        serviceEnabled == LocationPermission.whileInUse) {
                      widget.onGrantPermission();
                      // Service still not enabled, handle accordingly
                    }

                    // Location permission granted, handle accordingly
                  }
                },
                title: 'Grant Permission',
              ),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
