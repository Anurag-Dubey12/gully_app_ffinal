import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

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
      checkLocationPermission();
    }, onDone: () {
      // logger.i('Done');
    }, onError: (e) {
      //logger.e('Error $e');
    });
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      _locationPermissionController.add(false);
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        _locationPermissionController.add(false);
        return;
      }
    }

    LocationPermission permissionStatus = await Geolocator.checkPermission();
    bool granted = permissionStatus != LocationPermission.deniedForever &&
        permissionStatus != LocationPermission.denied;
    _locationPermissionController.add(granted);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _locationPermissionController.stream,
      initialData: true,
      builder: (context, snapshot) {
        if (snapshot.data == false) {
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
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      widget.onGrantPermission();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permission Denied',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
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
            const Text(
              'Please grant location permission to continue.',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: PrimaryButton(
                onTap: () async {
                  LocationPermission permissionStatus =
                      await Geolocator.checkPermission();
                  if (permissionStatus == LocationPermission.deniedForever) {
                    // Location permission denied, handle accordingly
                    //logger.d' 119 Opening location settings');
                    Geolocator.openLocationSettings();
                    return;
                  } else {
                    final serviceEnabled = await Geolocator.requestPermission();
                    if (serviceEnabled == LocationPermission.deniedForever ||
                        serviceEnabled == LocationPermission.denied) {
                      //logger.d'Opening location settings');
                      bool res = await Geolocator.openLocationSettings();
                      //logger.d'res $res');

                      return;
                    }

                    if (serviceEnabled == LocationPermission.always ||
                        serviceEnabled == LocationPermission.whileInUse) {
                      widget.onGrantPermission();
                    }
                    widget.onGrantPermission();

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
