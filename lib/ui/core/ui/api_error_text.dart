import 'package:sun_shine/core.dart';

extension ApiErrorText on ApiException {
  String localizedMessage(AppLocalizations l10n) => switch (error) {
    ApiErrorEnum.noInternet => l10n.noInternetConnection,
    ApiErrorEnum.timeout => l10n.requestTimeOut,
    ApiErrorEnum.cancelled => l10n.requestCancelled,
    ApiErrorEnum.badCertificate => l10n.incorrectCertificate,
    ApiErrorEnum.badFormat => l10n.badResponseFormat,
    ApiErrorEnum.server => serverMessage ?? l10n.somethingWentWrong,
    ApiErrorEnum.unknown => l10n.somethingWentWrong,
  };
}
