import 'dart:async';

import 'package:flutter/foundation.dart';

/// Converts a [Stream] into a [Listenable] for use with GoRouter's
/// `refreshListenable` parameter.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream] that notifies listeners whenever
  /// [stream] emits a value.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription =
        stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
