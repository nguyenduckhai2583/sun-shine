import 'package:sun_shine/core.dart';

/// The view-side half of [ApiException].
///
/// The data layer reports an [ApiErrorEnum] and never a sentence, because it
/// has no `BuildContext` and so no locale. Turning that into words is a view
/// concern, and it happens here.
extension ApiErrorText on ApiException {
  /// The message to show a user, in their language.
  ///
  /// A server rejection keeps the backend's own wording — only the backend
  /// knows what a given rejection means. Everything else is translated.
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
