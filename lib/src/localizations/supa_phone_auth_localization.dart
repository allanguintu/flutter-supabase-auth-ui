import 'package:flutter/material.dart';

class SupaPhoneAuthLocalization {
  final String enterPhoneNumber;
  final String validPhoneNumberError;
  final String enterPassword;
  final String passwordLengthError;
  final String signIn;
  final String signUp;
  final String unexpectedError;

  const SupaPhoneAuthLocalization({
    this.enterPhoneNumber = 'Enter your phone number',
    this.validPhoneNumberError = 'Please enter a valid phone number',
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.signIn = 'Sign In',
    this.signUp = 'Sign Up',
    this.unexpectedError = 'An unexpected error occurred',
  });

  const SupaPhoneAuthLocalization.fr()
      : enterPhoneNumber = 'Votre numéro de téléphone',
        validPhoneNumberError = 'Numéro invalide',
        enterPassword = 'Votre mot de passe',
        passwordLengthError = '6 caractères min.',
        signIn = 'Se connecter',
        signUp = 'S\'inscrire',
        unexpectedError = 'Erreur inattendue';

  const SupaPhoneAuthLocalization.de()
      : enterPhoneNumber = 'Telefonnummer eingeben',
        validPhoneNumberError = 'Ungültige Nummer',
        enterPassword = 'Passwort eingeben',
        passwordLengthError = 'Min. 6 Zeichen',
        signIn = 'Anmelden',
        signUp = 'Registrieren',
        unexpectedError = 'Unerwarteter Fehler';

  const SupaPhoneAuthLocalization.es()
      : enterPhoneNumber = 'Tu número de teléfono',
        validPhoneNumberError = 'Número inválido',
        enterPassword = 'Tu contraseña',
        passwordLengthError = 'Mín. 6 caracteres',
        signIn = 'Iniciar sesión',
        signUp = 'Registrarse',
        unexpectedError = 'Error inesperado';

  const SupaPhoneAuthLocalization.it()
      : enterPhoneNumber = 'Il tuo numero di telefono',
        validPhoneNumberError = 'Numero non valido',
        enterPassword = 'La tua password',
        passwordLengthError = 'Min. 6 caratteri',
        signIn = 'Accedi',
        signUp = 'Registrati',
        unexpectedError = 'Errore imprevisto';

  const SupaPhoneAuthLocalization.nl()
      : enterPhoneNumber = 'Jouw telefoonnummer',
        validPhoneNumberError = 'Ongeldig nummer',
        enterPassword = 'Jouw wachtwoord',
        passwordLengthError = 'Min. 6 tekens',
        signIn = 'Inloggen',
        signUp = 'Registreren',
        unexpectedError = 'Onverwachte fout';

  factory SupaPhoneAuthLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaPhoneAuthLocalization.fr();
      case 'de':
        return const SupaPhoneAuthLocalization.de();
      case 'es':
        return const SupaPhoneAuthLocalization.es();
      case 'it':
        return const SupaPhoneAuthLocalization.it();
      case 'nl':
        return const SupaPhoneAuthLocalization.nl();
      default:
        return const SupaPhoneAuthLocalization();
    }
  }
}
