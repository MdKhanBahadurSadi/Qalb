import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class PrayerDataSource {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getPrayerTimes(Position position) async {
    try {
      final response = await _dio.get(
        'https://api.aladhan.com/v1/timings',
        queryParameters: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'method': 1, // University of Islamic Sciences, Karachi (Standard for Bangladesh)
        },
      );

      if (response.statusCode == 200) {
        return response.data['data']['timings'];
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }
}
