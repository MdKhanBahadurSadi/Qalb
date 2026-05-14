import 'dart:developer' as dev;

class TFLiteService {
  Future<void> initialize() async {
    dev.log('⚠️ TFLite not supported on Web. Using stub.');
  }

  double predict(List<double> input) {
    dev.log('⚠️ TFLite not supported on Web. Returning 0.0.');
    return 0.0;
  }

  void dispose() {}
}
