import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a stream to `GoRouter.refreshListenable`.
///
/// `go_router` re-runs `redirect` whenever this notifies, which is how a sign
/// in, a sign out, or picking a workspace moves the user without anyone
/// calling `context.go`.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
