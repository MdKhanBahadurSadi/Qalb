import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Parsed result from a medical report OCR scan
class OcrParsedResult {
  final String rawText;
  final int? systolicBP;
  final int? diastolicBP;
  final int? cholesterol;
  final int? heartRate;
  final int? age;
  final double? weight;
  final double? bloodSugar; // for diabetes detection hint
  final List<String> detectedKeywords; // smoking, diabetes, family history

  const OcrParsedResult({
    required this.rawText,
    this.systolicBP,
    this.diastolicBP,
    this.cholesterol,
    this.heartRate,
    this.age,
    this.weight,
    this.bloodSugar,
    this.detectedKeywords = const [],
  });

  bool get hasSmoking => detectedKeywords.any(
      (k) => k.contains('smok') || k.contains('tobacco') || k.contains('ধূমপান'));
  bool get hasDiabetes => detectedKeywords.any(
      (k) => k.contains('diabet') || k.contains('ডায়াবেটিস') || k.contains('dm'));
  bool get hasFamilyHistory => detectedKeywords.any(
      (k) => k.contains('family') || k.contains('পারিবারিক') || k.contains('hereditary'));

  bool get hasAnyData =>
      systolicBP != null ||
      diastolicBP != null ||
      cholesterol != null ||
      heartRate != null ||
      age != null ||
      weight != null ||
      bloodSugar != null ||
      detectedKeywords.isNotEmpty;
}

class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// Runs OCR on the given image file and parses medical values
  Future<OcrParsedResult> processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _recognizer.processImage(inputImage);

    final rawText = recognizedText.text;
    return _parseText(rawText);
  }

  OcrParsedResult _parseText(String text) {
    final lower = text.toLowerCase();

    return OcrParsedResult(
      rawText: text,
      systolicBP: _extractSystolicBP(text, lower),
      diastolicBP: _extractDiastolicBP(text, lower),
      cholesterol: _extractCholesterol(text, lower),
      heartRate: _extractHeartRate(text, lower),
      age: _extractAge(text, lower),
      weight: _extractWeight(text, lower),
      bloodSugar: _extractBloodSugar(text, lower),
      detectedKeywords: _extractKeywords(lower),
    );
  }

  // ── Systolic BP ────────────────────────────────────────────────────────────
  // Matches: "120/80", "BP: 120", "Systolic: 120", "SBP 118"
  int? _extractSystolicBP(String text, String lower) {
    // BP format: 120/80
    final bpSlash = RegExp(r'\b(\d{2,3})\s*/\s*\d{2,3}\b');
    final m1 = bpSlash.firstMatch(text);
    if (m1 != null) {
      final val = int.tryParse(m1.group(1)!);
      if (val != null && val >= 70 && val <= 250) return val;
    }

    // Labelled
    final labelled = RegExp(
        r'(?:systolic|sbp|sys(?:tolic)?|blood\s*pressure)[^\d]*(\d{2,3})',
        caseSensitive: false);
    final m2 = labelled.firstMatch(text);
    if (m2 != null) {
      final val = int.tryParse(m2.group(1)!);
      if (val != null && val >= 70 && val <= 250) return val;
    }

    return null;
  }

  // ── Diastolic BP ───────────────────────────────────────────────────────────
  int? _extractDiastolicBP(String text, String lower) {
    // BP format: 120/80
    final bpSlash = RegExp(r'\b\d{2,3}\s*/\s*(\d{2,3})\b');
    final m1 = bpSlash.firstMatch(text);
    if (m1 != null) {
      final val = int.tryParse(m1.group(1)!);
      if (val != null && val >= 40 && val <= 150) return val;
    }

    // Labelled
    final labelled = RegExp(
        r'(?:diastolic|dbp|dia(?:stolic)?)[^\d]*(\d{2,3})',
        caseSensitive: false);
    final m2 = labelled.firstMatch(text);
    if (m2 != null) {
      final val = int.tryParse(m2.group(1)!);
      if (val != null && val >= 40 && val <= 150) return val;
    }

    return null;
  }

  // ── Cholesterol ────────────────────────────────────────────────────────────
  // Matches: "Total Cholesterol: 210", "TC 195", "Chol. 220 mg/dL"
  int? _extractCholesterol(String text, String lower) {
    final patterns = [
      RegExp(r'(?:total\s*)?(?:cholesterol|chol|tc)[^\d]*(\d{2,3})',
          caseSensitive: false),
      RegExp(r'(\d{2,3})\s*mg/dl', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final val = int.tryParse(m.group(1)!);
        if (val != null && val >= 100 && val <= 500) return val;
      }
    }
    return null;
  }

  // ── Heart Rate ─────────────────────────────────────────────────────────────
  // Matches: "HR: 72", "Heart Rate 85 bpm", "Pulse: 78"
  int? _extractHeartRate(String text, String lower) {
    final patterns = [
      RegExp(r'(?:heart\s*rate|hr|pulse|bpm)[^\d]*(\d{2,3})',
          caseSensitive: false),
      RegExp(r'(\d{2,3})\s*bpm', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final val = int.tryParse(m.group(1)!);
        if (val != null && val >= 30 && val <= 250) return val;
      }
    }
    return null;
  }

  // ── Age ────────────────────────────────────────────────────────────────────
  int? _extractAge(String text, String lower) {
    final patterns = [
      RegExp(r'(?:age|বয়স)[^\d]*(\d{1,3})', caseSensitive: false),
      RegExp(r'(\d{1,3})\s*(?:years?\s*old|yrs?\s*old|yr)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final val = int.tryParse(m.group(1)!);
        if (val != null && val >= 1 && val <= 120) return val;
      }
    }
    return null;
  }

  // ── Weight ─────────────────────────────────────────────────────────────────
  double? _extractWeight(String text, String lower) {
    final patterns = [
      RegExp(r'(?:weight|wt|ওজন)[^\d]*(\d{2,3}(?:\.\d+)?)', caseSensitive: false),
      RegExp(r'(\d{2,3}(?:\.\d+)?)\s*kg', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final val = double.tryParse(m.group(1)!);
        if (val != null && val >= 20 && val <= 300) return val;
      }
    }
    return null;
  }

  // ── Blood Sugar ────────────────────────────────────────────────────────────
  double? _extractBloodSugar(String text, String lower) {
    final patterns = [
      RegExp(r'(?:fasting\s*)?(?:blood\s*sugar|glucose|fbs|rbs|hba1c)[^\d]*(\d{1,3}(?:\.\d+)?)',
          caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final m = pattern.firstMatch(text);
      if (m != null) {
        final val = double.tryParse(m.group(1)!);
        if (val != null && val >= 50 && val <= 600) return val;
      }
    }
    return null;
  }

  // ── Keywords ───────────────────────────────────────────────────────────────
  List<String> _extractKeywords(String lower) {
    final keywords = <String>[];
    const targets = [
      'smoking', 'smoker', 'tobacco', 'ধূমপান',
      'diabetes', 'diabetic', 'ডায়াবেটিস', 'dm type',
      'family history', 'hereditary', 'পারিবারিক',
    ];

    for (final target in targets) {
      if (lower.contains(target)) keywords.add(target);
    }
    return keywords;
  }

  void dispose() => _recognizer.close();
}
