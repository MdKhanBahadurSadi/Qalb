import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;
  static const String _modelPath = 'assets/ml/heart_attack_prediction.tflite';

  Future<void> initialize() async {
    if (_interpreter != null) return;
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      dev.log('✅ TFLite Model loaded successfully');
    } catch (e) {
      dev.log('❌ Error loading TFLite model: $e');
    }
  }

  double predict(List<double> input) {
    if (_interpreter == null) throw Exception('Interpreter not initialized');

    // ১. ইনপুট ডাটাকে Float32 ফরম্যাটে নিয়ে আসা [1, Features_Count]
    var inputBuffer = Float32List.fromList(input).reshape([1, input.length]);
    
    // ২. আউটপুট বাফার তৈরি করা (মডেল সাধারণত [1, 1] রিটার্ন করে)
    var outputBuffer = Float32List(1).reshape([1, 1]);

    try {
      _interpreter!.run(inputBuffer, outputBuffer);
      
      // ৩. রেজাল্ট বের করা
      double result = outputBuffer[0][0];
      
      // যদি রেজাল্ট ০ থেকে ১ এর বাইরে যায় (যেমন লিনিয়ার রিগ্রেশন), তবে সেটাকে ০-১ এ রাখা
      dev.log('🔮 Raw Prediction: $result');
      return result;
    } catch (e) {
      dev.log('❌ Inference Error: $e');
      return 0.0;
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
