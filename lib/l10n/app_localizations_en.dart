// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSubtitle => 'Start a new conversation with the team';

  @override
  String get addNewAccount => 'Add new account';

  @override
  String get email => 'Email';

  @override
  String get emailInputHint => 'Your email address here';

  @override
  String get password => 'Password';

  @override
  String get passwordInputHint => 'Enter the password';

  @override
  String get incorrectEmailOrPassword =>
      'Your email address and/or password are incorrect.';

  @override
  String get continueWithPasskey => 'Continue with Passkey';

  @override
  String get scanQrCodeAction => 'Scan QR code';

  @override
  String get processing => 'Processing';

  @override
  String get cancel => 'Cancel';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get requestTimeOut =>
      'Request timed out. Please check your connection.';

  @override
  String get requestCancelled => 'The request was cancelled';

  @override
  String get badResponseFormat => 'Bad response format';

  @override
  String get incorrectCertificate => 'Incorrect certificate as configured';
}
