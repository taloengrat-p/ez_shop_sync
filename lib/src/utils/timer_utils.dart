import 'dart:async';

class TimerUtils {
  Timer? _debounceTimer;
  Completer? _completer;

  Future<T?> debounceTime<T>(Duration duration, Future<T> Function() function) {
    // Cancel existing debounce and its completer

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
      _completer?.completeError('Cancelled');
      _completer = Completer<T>();
    }

    _debounceTimer = Timer(duration, () async {
      try {
        final result = await function();
        if (!_completer!.isCompleted) {
          _completer!.complete(result);
          _completer = null;
          _debounceTimer = null;
        }
      } catch (e, stack) {
        if (!(_completer?.isCompleted ?? false)) {
          _completer!.completeError(e, stack);
          _completer = null;
          _debounceTimer = null;
        }
      }
    });

    return _completer?.future as Future<T>;
  }
}
