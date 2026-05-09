import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class for debouncing actions.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  /// Calls the [action] after the [delay].
  /// If called again before the timer expires, the previous timer is cancelled.
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any active timer.
  void dispose() => _timer?.cancel();
}
