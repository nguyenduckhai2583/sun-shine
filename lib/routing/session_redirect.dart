import 'package:sun_shine/core.dart';

/// Where a given session belongs, or null to stay put.
///
/// Pulled out of `createRouter` so it can be reasoned about — and tested —
/// without mounting a router. Employer made this decision inside
/// `SessionManager` with `Get.offAllNamed`; here it is a pure function of the
/// session and the current location.
String? sessionRedirect({required Session? session, required String location}) {
  if (session == null) {
    return location == Routes.signIn ? null : Routes.signIn;
  }
  if (session.needsWorkspace) {
    return location == Routes.workspace ? null : Routes.workspace;
  }
  if (location == Routes.signIn || location == Routes.workspace) {
    return Routes.home;
  }
  return null;
}
