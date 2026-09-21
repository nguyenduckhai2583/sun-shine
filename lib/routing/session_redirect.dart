import 'package:sun_shine/core.dart';

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
