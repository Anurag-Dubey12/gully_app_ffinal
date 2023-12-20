import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/api_client.dart';
import '/config/app_constants.dart';
import '/config/preferences.dart';
import '/data/api/auth_api.dart';
import '/data/api/tournament_api.dart';
import '/data/controller/auth_controller.dart';
import '/data/controller/tournament_controller.dart';
import '/ui/screens/splash_screen.dart';
import '/ui/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder: (c) => GetMaterialApp(
        binds: [
          Bind.put<Preferences>(Preferences()),
          Bind.lazyPut<GetConnectClient>(() => GetConnectClient()),
          Bind.put<Preferences>(Preferences()),
          Bind.lazyPut<AuthApi>(() => AuthApi(Get.find())),
          Bind.lazyPut<TournamentApi>(() => TournamentApi(repo: Get.find())),
          Bind.lazyPut<AuthController>(() => AuthController(repo: Get.find())),
          Bind.lazyPut<TournamentController>(
              () => TournamentController(Get.find())),
        ],
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
