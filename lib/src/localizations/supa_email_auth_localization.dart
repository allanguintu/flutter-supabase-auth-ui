import 'package:flutter/material.dart';

class SupaEmailAuthLocalization {
  final String enterEmail;
  final String validEmailError;
  final String enterPassword;
  final String passwordLengthError;
  final String signIn;
  final String signUp;
  final String forgotPassword;
  final String dontHaveAccount;
  final String haveAccount;
  final String sendPasswordReset;
  final String passwordResetSent;
  final String backToSignIn;
  final String unexpectedError;
  final String requiredFieldError;
  final String confirmPasswordError;
  final String confirmPassword;

  const SupaEmailAuthLocalization({
    this.enterEmail = 'Enter your email',
    this.validEmailError = 'Please enter a valid email address',
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.signIn = 'Sign In',
    this.signUp = 'Sign Up',
    this.forgotPassword = 'Forgot your password?',
    this.dontHaveAccount = 'Don\'t have an account? Sign up',
    this.haveAccount = 'Already have an account? Sign in',
    this.sendPasswordReset = 'Send password reset email',
    this.passwordResetSent = 'Password reset email has been sent',
    this.backToSignIn = 'Back to sign in',
    this.unexpectedError = 'An unexpected error occurred',
    this.requiredFieldError = 'This field is required',
    this.confirmPasswordError = 'Passwords do not match',
    this.confirmPassword = 'Confirm Password',
  });

  const SupaEmailAuthLocalization.fr()
      : enterEmail = 'Votre email',
        validEmailError = 'Email invalide',
        enterPassword = 'Votre mot de passe',
        passwordLengthError = '6 caractères min.',
        signIn = 'Se connecter',
        signUp = 'S\'inscrire',
        forgotPassword = 'Mot de passe oublié ?',
        dontHaveAccount = 'Pas de compte ? S\'inscrire',
        haveAccount = 'Déjà un compte ? Se connecter',
        sendPasswordReset = 'Envoyer le lien',
        passwordResetSent = 'Email envoyé',
        backToSignIn = 'Retour à la connexion',
        unexpectedError = 'Erreur inattendue',
        requiredFieldError = 'Champ requis',
        confirmPasswordError = 'Mots de passe différents',
        confirmPassword = 'Confirmer le mot de passe';

  const SupaEmailAuthLocalization.de()
      : enterEmail = 'E-Mail eingeben',
        validEmailError = 'Ungültige E-Mail',
        enterPassword = 'Passwort eingeben',
        passwordLengthError = 'Min. 6 Zeichen',
        signIn = 'Anmelden',
        signUp = 'Registrieren',
        forgotPassword = 'Passwort vergessen?',
        dontHaveAccount = 'Kein Konto? Registrieren',
        haveAccount = 'Konto vorhanden? Anmelden',
        sendPasswordReset = 'Reset-E-Mail senden',
        passwordResetSent = 'E-Mail gesendet',
        backToSignIn = 'Zurück zur Anmeldung',
        unexpectedError = 'Unerwarteter Fehler',
        requiredFieldError = 'Pflichtfeld',
        confirmPasswordError = 'Passwörter stimmen nicht überein',
        confirmPassword = 'Passwort bestätigen';

  const SupaEmailAuthLocalization.es()
      : enterEmail = 'Tu correo',
        validEmailError = 'Correo inválido',
        enterPassword = 'Tu contraseña',
        passwordLengthError = 'Mín. 6 caracteres',
        signIn = 'Iniciar sesión',
        signUp = 'Registrarse',
        forgotPassword = '¿Olvidaste tu contraseña?',
        dontHaveAccount = '¿Sin cuenta? Regístrate',
        haveAccount = '¿Tienes cuenta? Inicia sesión',
        sendPasswordReset = 'Enviar enlace',
        passwordResetSent = 'Correo enviado',
        backToSignIn = 'Volver al inicio de sesión',
        unexpectedError = 'Error inesperado',
        requiredFieldError = 'Campo requerido',
        confirmPasswordError = 'Las contraseñas no coinciden',
        confirmPassword = 'Confirmar contraseña';

  const SupaEmailAuthLocalization.it()
      : enterEmail = 'La tua email',
        validEmailError = 'Email non valida',
        enterPassword = 'La tua password',
        passwordLengthError = 'Min. 6 caratteri',
        signIn = 'Accedi',
        signUp = 'Registrati',
        forgotPassword = 'Password dimenticata?',
        dontHaveAccount = 'Nessun account? Registrati',
        haveAccount = 'Hai un account? Accedi',
        sendPasswordReset = 'Invia link',
        passwordResetSent = 'Email inviata',
        backToSignIn = 'Torna al login',
        unexpectedError = 'Errore imprevisto',
        requiredFieldError = 'Campo obbligatorio',
        confirmPasswordError = 'Le password non coincidono',
        confirmPassword = 'Conferma password';

  const SupaEmailAuthLocalization.nl()
      : enterEmail = 'Jouw e-mail',
        validEmailError = 'Ongeldig e-mailadres',
        enterPassword = 'Jouw wachtwoord',
        passwordLengthError = 'Min. 6 tekens',
        signIn = 'Inloggen',
        signUp = 'Registreren',
        forgotPassword = 'Wachtwoord vergeten?',
        dontHaveAccount = 'Geen account? Registreren',
        haveAccount = 'Al een account? Inloggen',
        sendPasswordReset = 'Stuur reset-e-mail',
        passwordResetSent = 'E-mail verzonden',
        backToSignIn = 'Terug naar inloggen',
        unexpectedError = 'Onverwachte fout',
        requiredFieldError = 'Verplicht veld',
        confirmPasswordError = 'Wachtwoorden komen niet overeen',
        confirmPassword = 'Bevestig wachtwoord';

  factory SupaEmailAuthLocalization.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return const SupaEmailAuthLocalization.fr();
      case 'de':
        return const SupaEmailAuthLocalization.de();
      case 'es':
        return const SupaEmailAuthLocalization.es();
      case 'it':
        return const SupaEmailAuthLocalization.it();
      case 'nl':
        return const SupaEmailAuthLocalization.nl();
      default:
        return const SupaEmailAuthLocalization();
    }
  }
}
