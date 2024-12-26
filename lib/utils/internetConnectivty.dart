import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class Internetconnectivty {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // Callback to handle connection changes
  void listenToConnectionChanges(Function(bool) onConnectionChanged) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = results.any((result) => result != ConnectivityResult.none);
      onConnectionChanged(isConnected);
    });
  }

  // Cancel the subscription when it's no longer needed
  void dispose() {
    _subscription?.cancel();
  }
}
