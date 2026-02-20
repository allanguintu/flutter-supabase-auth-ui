import 'package:flutter/material.dart';

class SupaMagicAuthLocalization {
  final String enterEmail;
  final String validEmailError;
  final String continueWithMagicLink;
  final String checkYourEmail;
  final String unexpectedError;

  const SupaMagicAuthLocalization({
    this.enterEmail = 'Enter your email',
    this.validEmailError = 'Please enter a valid email address',
    this.continueWithMagicLink = 'Continue with magic link',
    this.checkYourEmail = 'Check your email inbox!',
    this.unexpectedError = 'An unexpected error occurred',
  });

  const SupaMagicAuthLocalization.fr()
      : enterEmail = 'Votre email',
        validEmailError = 'Email invalide',
        continueWithMagicLink = 'Continuer avec le lien magique',
        checkYourEmail = 'Vérifiez votre boîte mail !',
        unexpectedError = 'Erreur inattendue';

  const SupaMagicAuthLocalization.de()
      : enterEmail = 'E-Mail eingeben',
        validEmailError = 'Ungültige E-Mail',
        continueWithMagicLink = 'Mit Magic-Link fortfahren',
        checkYourEmail = 'Posteingang prüfen!',
        unexpectedError = 'Unerwarteter Fehler';

  const SupaMagicAuthLocalization.es()
      : enterEmail = 'Tu correo',
        validEmailError = 'Correo inválido',
        continueWithMagicLink = 'Continuar con magic link',
        checkYourEmail = '¡Revisa tu bandeja!',
        unexpectedError = 'Error inesperado';

  const SupaMagicAuthLocalization.it()
      : enterEmail = 'La tua email',
        validEmailError = 'Email non valida',
        continueWithMagicLink = 'Continua con magic link',
        checkYourEmail = 'Controlla la tua casella!',
        unexpectedError = 'Errore imprevisto';

  const SupaMagicAuthLocalization.nl()
      : enterEmail = 'Jouw e-mail',
        validEmailError = 'Ongeldig e-mailadres',
        continueWithMagicLink = 'Doorgaan met magic link',
        checkYourEmail = 'Controleer je inbox!',
        unexpectedError = 'Onverwachte fout';

  factory SupaMagicAuthLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaMagicAuthLocalization.fr();
      case 'de':
        return const SupaMagicAuthLocalization.de();
      case 'es':
        return const SupaMagicAuthLocalization.es();
      case 'it':
        return const SupaMagicAuthLocalization.it();
      case 'nl':
        return const SupaMagicAuthLocalization.nl();
      default:
        return const SupaMagicAuthLocalization();
    }
  }
}
