import 'package:flutter/material.dart';

class SupaResetPasswordLocalization {
  final String enterPassword;
  final String passwordLengthError;
  final String updatePassword;
  final String unexpectedError;
  final String passwordResetSent;
  final String showPassword;
  final String hidePassword;

  const SupaResetPasswordLocalization({
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.updatePassword = 'Update Password',
    this.unexpectedError = 'An unexpected error occurred',
    this.passwordResetSent = 'Password reset email has been sent',
    this.showPassword = 'Show password',
    this.hidePassword = 'Hide password',
  });

  const SupaResetPasswordLocalization.fr()
      : enterPassword = 'Nouveau mot de passe',
        passwordLengthError = '6 caractères min.',
        updatePassword = 'Mettre à jour',
        unexpectedError = 'Erreur inattendue',
        passwordResetSent = 'Email envoyé',
        showPassword = 'Afficher le mot de passe',
        hidePassword = 'Masquer le mot de passe';

  const SupaResetPasswordLocalization.de()
      : enterPassword = 'Neues Passwort',
        passwordLengthError = 'Min. 6 Zeichen',
        updatePassword = 'Aktualisieren',
        unexpectedError = 'Unerwarteter Fehler',
        passwordResetSent = 'E-Mail gesendet',
        showPassword = 'Passwort anzeigen',
        hidePassword = 'Passwort verbergen';

  const SupaResetPasswordLocalization.es()
      : enterPassword = 'Nueva contraseña',
        passwordLengthError = 'Mín. 6 caracteres',
        updatePassword = 'Actualizar',
        unexpectedError = 'Error inesperado',
        passwordResetSent = 'Correo enviado',
        showPassword = 'Mostrar contraseña',
        hidePassword = 'Ocultar contraseña';

  const SupaResetPasswordLocalization.it()
      : enterPassword = 'Nuova password',
        passwordLengthError = 'Min. 6 caratteri',
        updatePassword = 'Aggiorna',
        unexpectedError = 'Errore imprevisto',
        passwordResetSent = 'Email inviata',
        showPassword = 'Mostra password',
        hidePassword = 'Nascondi password';

  const SupaResetPasswordLocalization.nl()
      : enterPassword = 'Nieuw wachtwoord',
        passwordLengthError = 'Min. 6 tekens',
        updatePassword = 'Bijwerken',
        unexpectedError = 'Onverwachte fout',
        passwordResetSent = 'E-mail verzonden',
        showPassword = 'Wachtwoord tonen',
        hidePassword = 'Wachtwoord verbergen';

  factory SupaResetPasswordLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaResetPasswordLocalization.fr();
      case 'de':
        return const SupaResetPasswordLocalization.de();
      case 'es':
        return const SupaResetPasswordLocalization.es();
      case 'it':
        return const SupaResetPasswordLocalization.it();
      case 'nl':
        return const SupaResetPasswordLocalization.nl();
      default:
        return const SupaResetPasswordLocalization();
    }
  }
}
