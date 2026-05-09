import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { isConnected, isDisconnected }

class ConnectivityService extends StateNotifier<ConnectivityStatus> {
  ConnectivityService() : super(ConnectivityStatus.isConnected) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Handle the new list-based API in connectivity_plus 6.0.0+
      if (results.contains(ConnectivityResult.none)) {
        state = ConnectivityStatus.isDisconnected;
      } else {
        state = ConnectivityStatus.isConnected;
      }
    });
  }
}

final connectivityServiceProvider = StateNotifierProvider<ConnectivityService, ConnectivityStatus>((ref) {
  return ConnectivityService();
});
