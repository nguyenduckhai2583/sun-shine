import 'package:sun_shine/core.dart';

class GatedAuthLocalService extends AuthLocalService {
  GatedAuthLocalService({required this.gate});

  final Future<void> gate;

  @override
  Future<void> save(Session session) async {
    await super.save(session);
    await gate;
  }

  @override
  Future<void> clear() async {
    await super.clear();
    await gate;
  }
}
