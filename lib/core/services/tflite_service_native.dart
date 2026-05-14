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
      
      // মডেলের ইনপুট এবং আউটপুট শেপ চেক করা (ডিবাগিং এর জন্য)
      var inputShape = _interpreter!.getInputTensors().first.shape;
      var outputShape = _interpreter!.getOutputTensors().first.shape;
      
      dev.log('✅ TFLite Model loaded successfully');
      dev.log('📊 Expected Input Shape: $inputShape');
      dev.log('📊 Expected Output Shape: $outputShape');
      
    } catch (e) {
      dev.log('❌ Error loading TFLite model: $e');
    }
  }

  double predict(List<double> input) {
    if (_interpreter == null) throw Exception('Interpreter not initialized');

    try {
      // ইনপুট টেন্সরের তথ্য নেয়া
      var inputTensor = _interpreter!.getInputTensors().first;
      int expectedFeatures = inputTensor.shape[1];

      // যদি ইনপুট ফিচার কম থাকে তবে বাকিগুলো ০ দিয়ে পূরণ করা (প্যাডিং)
      // অথবা যদি বেশি থাকে তবে কেটে নেয়া। 
      // আদর্শভাবে এটি অ্যাপ এবং মডেল ট্রেইনিং ডাটার সাথে মিল থাকা উচিত।
      List<double> finalInput = List.from(input);
      if (finalInput.length < expectedFeatures) {
        finalInput.addAll(List.filled(expectedFeatures - finalInput.length, 0.0));
      } else if (finalInput.length > expectedFeatures) {
        finalInput = finalInput.sublist(0, expectedFeatures);
      }

      // ইনপুট বাফার তৈরি [1, expectedFeatures]
      var inputBuffer = [finalInput];
      
      // আউটপুট বাফার তৈরি [1, 1]
      var outputBuffer = List.filled(1, List.filled(1, 0.0));

      _interpreter!.run(inputBuffer, outputBuffer);

      double result = outputBuffer[0][0];
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
