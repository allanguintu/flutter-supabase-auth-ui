import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SupaSocialsAuthLocalization {
  final String successSignInMessage;
  final String unexpectedError;

  /// Overrides the name of the OAuth provider shown on the sign-in button.
  ///
  /// Defaults to `Continue with [ProviderName]`
  ///
  /// ```dart
  /// SupaSocialsAuth(
  ///   socialProviders: const [OAuthProvider.azure],
  ///   localization: const SupaSocialsAuthLocalization(
  ///     oAuthButtonLabels: {
  ///       OAuthProvider.azure: 'Microsoft (Azure)'
  ///     },
  ///   ),
  ///   onSuccess: (session) {
  ///     // sHandle success
  ///   },
  /// ),
  /// ```
  final Map<OAuthProvider, String> oAuthButtonLabels;

  const SupaSocialsAuthLocalization({
    this.successSignInMessage = 'Successfully signed in!',
    this.unexpectedError = 'An unexpected error occurred',
    this.oAuthButtonLabels = const {},
  });

  const SupaSocialsAuthLocalization.fr()
      : successSignInMessage = 'Connecté !',
        unexpectedError = 'Erreur inattendue',
        oAuthButtonLabels = const {};

  const SupaSocialsAuthLocalization.de()
      : successSignInMessage = 'Angemeldet!',
        unexpectedError = 'Unerwarteter Fehler',
        oAuthButtonLabels = const {};

  const SupaSocialsAuthLocalization.es()
      : successSignInMessage = '¡Sesión iniciada!',
        unexpectedError = 'Error inesperado',
        oAuthButtonLabels = const {};

  const SupaSocialsAuthLocalization.it()
      : successSignInMessage = 'Accesso effettuato!',
        unexpectedError = 'Errore imprevisto',
        oAuthButtonLabels = const {};

  const SupaSocialsAuthLocalization.nl()
      : successSignInMessage = 'Ingelogd!',
        unexpectedError = 'Onverwachte fout',
        oAuthButtonLabels = const {};

  factory SupaSocialsAuthLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaSocialsAuthLocalization.fr();
      case 'de':
        return const SupaSocialsAuthLocalization.de();
      case 'es':
        return const SupaSocialsAuthLocalization.es();
      case 'it':
        return const SupaSocialsAuthLocalization.it();
      case 'nl':
        return const SupaSocialsAuthLocalization.nl();
      default:
        return const SupaSocialsAuthLocalization();
    }
  }
}
