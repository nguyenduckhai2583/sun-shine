import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionManager>().initSession();
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
