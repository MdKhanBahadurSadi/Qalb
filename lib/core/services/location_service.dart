import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      throw 'লোকেশন সার্ভিস বন্ধ আছে। দয়া করে সেটিংস থেকে অন করুন।';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'লোকেশন পারমিশন রিজেক্ট করা হয়েছে।';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'লোকেশন পারমিশন পার্মানেন্টলি ব্লক করা। দয়া করে সেটিংস থেকে অন করুন।';
    }

    // Try last known position first (Fast)
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      debugPrint('Using last known position: ${lastPosition.latitude}, ${lastPosition.longitude}');
      return lastPosition;
    }

    // If last known is null, get current position (Slower)
    debugPrint('Last known position null, fetching current position...');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
