import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sessionManager = context.read<SessionManager>();

    return StreamBuilder<Session?>(
      stream: sessionManager.activeSession,
      initialData: sessionManager.currentSession,
      builder: (context, snapshot) {
        final userId = snapshot.data?.userId ?? '_anonymous';
        return MultiProvider(
          key: ValueKey(userId),
          providers: [
            Provider(create: (context) => ChannelApiClient()),
            Provider(
              create: (context) => ChannelLocalService(),
              dispose: (context, service) => service.dispose(),
            ),
            Provider<ChannelRepository>(
              create: (context) => ChannelRepositoryImpl(
                apiClient: context.read(),
                localService: context.read(),
              ),
            ),
          ],
          child: child,
        );
      },
    );
  }
}
