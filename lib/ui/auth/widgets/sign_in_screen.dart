import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => SignInUseCase(
            authManager: context.read(),
            authRepository: context.read<AuthManager>().authRepository,
          ),
        ),
        Provider(
          create: (context) => FinalizeSessionUseCase(
            authManager: context.read(),
            sessionRepository: context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SignInViewModel(
            signInUseCase: context.read(),
            signInFlowUseCase: context.read(),
            finalizeSessionUseCase: context.read(),
          ),
        ),
      ],
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
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _email.addListener(_onFormChanged);
    _password.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onFormChanged() => setState(() {});

  bool get _isFormValid =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_isFormValid) return;
    await context.read<SignInViewModel>().signIn.execute((
      email: _email.text,
      password: _password.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewModel = context.read<SignInViewModel>();
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) viewModel.cancel();
      },
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainerLowest,
        child: GridTileBackground(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Adding an account replaces the route instead of pushing
                    // one, so this is the only way back to the signed-in app.
                    if (viewModel.isAddingAccount)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: l10n.cancel,
                          onPressed: viewModel.cancel,
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (!viewModel.isAddingAccount) ...[
                              SvgPicture.asset(
                                AppAsset.imgAppTextLogo,
                                colorFilter: ColorFilter.mode(
                                  theme.colorScheme.onSurface,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            const GlassIcon(svgAsset: AppAsset.icAppIcon),
                            const SizedBox(height: 24),
                            _Title(isAddingAccount: viewModel.isAddingAccount),
                            const SizedBox(height: 24),
                            _buildForm(context, l10n),
                          ],
                        ),
                      ),
                    ),
                    if (!isKeyboardOpen) const _LegalLinks(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AppLocalizations l10n) {
    final viewModel = context.watch<SignInViewModel>();

    return AuthCardWidget(
      child: Column(
        children: [
          WidgetWithLabel(
            label: l10n.email,
            child: TextFieldInput(
              inputController: _email,
              hintText: l10n.emailInputHint,
              keyboardType: TextInputType.emailAddress,
              maxLength: 100,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              inputFormatters: [_LowerCaseFormatter()],
            ),
          ),
          const SizedBox(height: 12),
          WidgetWithLabel(
            label: l10n.password,
            child: TextFieldInput(
              inputController: _password,
              hintText: l10n.passwordInputHint,
              obscureText: true,
              focusNode: _passwordFocus,
              onFieldSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: viewModel.signIn,
            builder: (context, _) {
              final running = viewModel.signIn.running;
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isFormValid && !running ? _submit : null,
                      child: running
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.signIn),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.key),
                      label: Text(l10n.continueWithPasskey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(l10n.scanQrCodeAction),
                    ),
                  ),
                  if (viewModel.signIn.error) ...[
                    const SizedBox(height: 12),
                    Text(
                      switch (viewModel.signIn.result) {
                        Error(error: final ApiException e) =>
                          e.localizedMessage(l10n),
                        _ => l10n.incorrectEmailOrPassword,
                      },
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.isAddingAccount});

  final bool isAddingAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          isAddingAccount ? l10n.addNewAccount : l10n.signIn,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.signInSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        'By signing in you agree to our Terms and Privacy Policy.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LowerCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}
