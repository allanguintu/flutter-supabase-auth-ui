import 'package:flutter/material.dart';

class SupaVerifyPhoneLocalization {
  final String enterOneTimeCode;
  final String enterCodeSent;
  final String verifyPhone;
  final String unexpectedErrorOccurred;

  const SupaVerifyPhoneLocalization({
    this.enterOneTimeCode = 'Please enter the one time code sent',
    this.enterCodeSent = 'Enter the code sent',
    this.verifyPhone = 'Verify Phone',
    this.unexpectedErrorOccurred = 'Unexpected error has occurred',
  });

  const SupaVerifyPhoneLocalization.fr()
      : enterOneTimeCode = 'Entrez le code reçu',
        enterCodeSent = 'Entrez le code reçu',
        verifyPhone = 'Vérifier le téléphone',
        unexpectedErrorOccurred = 'Erreur inattendue';

  const SupaVerifyPhoneLocalization.de()
      : enterOneTimeCode = 'Code eingeben',
        enterCodeSent = 'Code eingeben',
        verifyPhone = 'Telefon bestätigen',
        unexpectedErrorOccurred = 'Unerwarteter Fehler';

  const SupaVerifyPhoneLocalization.es()
      : enterOneTimeCode = 'Ingresa el código',
        enterCodeSent = 'Ingresa el código',
        verifyPhone = 'Verificar teléfono',
        unexpectedErrorOccurred = 'Error inesperado';

  const SupaVerifyPhoneLocalization.it()
      : enterOneTimeCode = 'Inserisci il codice',
        enterCodeSent = 'Inserisci il codice',
        verifyPhone = 'Verifica telefono',
        unexpectedErrorOccurred = 'Errore imprevisto';

  const SupaVerifyPhoneLocalization.nl()
      : enterOneTimeCode = 'Voer de code in',
        enterCodeSent = 'Voer de code in',
        verifyPhone = 'Telefoon verifiëren',
        unexpectedErrorOccurred = 'Onverwachte fout';

  factory SupaVerifyPhoneLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaVerifyPhoneLocalization.fr();
      case 'de':
        return const SupaVerifyPhoneLocalization.de();
      case 'es':
        return const SupaVerifyPhoneLocalization.es();
      case 'it':
        return const SupaVerifyPhoneLocalization.it();
      case 'nl':
        return const SupaVerifyPhoneLocalization.nl();
      default:
        return const SupaVerifyPhoneLocalization();
    }
  }
}
