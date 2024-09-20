import 'dart:async';

class TimerUtils {
  Timer? _debounceTimer;
  debounceTime(Duration duration, Function() function) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(duration, function);
  }
}
