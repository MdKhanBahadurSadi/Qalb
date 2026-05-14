import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/ocr_service.dart';

// ── State ──────────────────────────────────────────────────────────────────

enum OcrStatus { idle, picking, processing, done, error }

class OcrState {
  final OcrStatus status;
  final OcrParsedResult? result;
  final String? errorMessage;

  const OcrState({
    this.status = OcrStatus.idle,
    this.result,
    this.errorMessage,
  });

  OcrState copyWith({
    OcrStatus? status,
    OcrParsedResult? result,
    String? errorMessage,
  }) {
    return OcrState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading =>
      status == OcrStatus.picking || status == OcrStatus.processing;
}

// ── Notifier ───────────────────────────────────────────────────────────────

class OcrNotifier extends StateNotifier<OcrState> {
  OcrNotifier() : super(const OcrState());

  final _service = OcrService();
  final _picker = ImagePicker();

  /// Pick image from camera or gallery and run OCR
  Future<OcrParsedResult?> scanReport({
    required ImageSource source,
  }) async {
    state = state.copyWith(status: OcrStatus.picking);

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 2048,
        maxHeight: 2048,
      );

      if (picked == null) {
        state = state.copyWith(status: OcrStatus.idle);
        return null;
      }

      state = state.copyWith(status: OcrStatus.processing);
      final result = await _service.processImage(File(picked.path));
      state = state.copyWith(status: OcrStatus.done, result: result);
      return result;
    } catch (e) {
      state = state.copyWith(
        status: OcrStatus.error,
        errorMessage: 'OCR ব্যর্থ হয়েছে: ${e.toString()}',
      );
      return null;
    }
  }

  void reset() {
    state = const OcrState();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final ocrProvider = StateNotifierProvider.autoDispose<OcrNotifier, OcrState>(
  (ref) => OcrNotifier(),
);
