import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: signInProviders,
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'khai@sunshine.com');
  final _password = TextEditingController(text: 'password');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<SignInViewModel>().signIn.execute((
      email: _email.text.trim(),
      password: _password.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Sun Shine',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v ?? '').contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      (v ?? '').isEmpty ? 'Password is required' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: viewModel.signIn,
                  builder: (context, _) {
                    if (viewModel.signIn.running) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        if (viewModel.signIn.error)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Sign in failed',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        FilledButton(
                          onPressed: _submit,
                          child: const Text('Sign in'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
