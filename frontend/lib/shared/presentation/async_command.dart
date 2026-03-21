import 'package:flutter/foundation.dart';

/// Small command object for running one async action with loading state.
class AsyncCommand extends ChangeNotifier {
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  Future<T?> run<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    if (_isRunning) {
      return null;
    }

    _isRunning = true;
    notifyListeners();

    try {
      return await action();
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      return null;
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}
