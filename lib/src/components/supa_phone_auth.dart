import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// UI component to create a phone + password signin/ signup form
class SupaPhoneAuth extends StatefulWidget {
  /// Whether the user is sining in or signin up
  final SupaAuthAction authAction;

  /// Method to be called when the auth action is success
  final void Function(AuthResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Localization for the form
  final SupaPhoneAuthLocalization? localization;

  const SupaPhoneAuth({
    super.key,
    required this.authAction,
    required this.onSuccess,
    this.onError,
    this.localization,
  });

  @override
  State<SupaPhoneAuth> createState() => _SupaPhoneAuthState();
}

class _SupaPhoneAuthState extends State<SupaPhoneAuth> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _passwordHasText = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      final hasText = _password.text.isNotEmpty;
      if (hasText != _passwordHasText) setState(() => _passwordHasText = hasText);
    });
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = widget.localization ??
        SupaPhoneAuthLocalization.fromLocale(
            Localizations.maybeLocaleOf(context) ?? const Locale('en'));
    final isSigningIn = widget.authAction == SupaAuthAction.signIn;
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.telephoneNumber],
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.validPhoneNumberError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                label: Text(localization.enterPhoneNumber),
              ),
              controller: _phone,
            ),
            spacer(16),
            TextFormField(
              autofillHints: isSigningIn
                  ? [AutofillHints.password]
                  : [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return localization.passwordLengthError;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                label: Text(localization.enterPassword),
                suffixIcon: _passwordHasText
                    ? Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: IconButton(
                          iconSize: 20,
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      )
                    : null,
              ),
              obscureText: !_isPasswordVisible,
              controller: _password,
            ),
            spacer(16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      setState(() => _isLoading = true);
                      try {
                  if (isSigningIn) {
                    final response = await supabase.auth.signInWithPassword(
                      phone: _phone.text,
                      password: _password.text,
                    );
                    widget.onSuccess(response);
                  } else {
                    late final AuthResponse response;
                    final user = supabase.auth.currentUser;
                    if (user?.isAnonymous == true) {
                      await supabase.auth.updateUser(
                        UserAttributes(
                          phone: _phone.text,
                          password: _password.text,
                        ),
                      );
                    } else {
                      response = await supabase.auth.signUp(
                        phone: _phone.text,
                        password: _password.text,
                      );
                    }
                    if (!mounted) return;
                    widget.onSuccess(response);
                  }
                } on AuthException catch (error) {
                  if (widget.onError == null && context.mounted) {
                    context.showErrorSnackBar(error.message);
                  } else {
                    widget.onError?.call(error);
                  }
                      } catch (error) {
                        if (widget.onError == null && context.mounted) {
                          context.showErrorSnackBar(
                              '${localization.unexpectedError}: $error');
                        } else {
                          widget.onError?.call(error);
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _phone.text = '';
                            _password.text = '';
                          });
                        }
                      }
                    },
              child: _isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 1.5,
                      ),
                    )
                  : Text(
                      isSigningIn ? localization.signIn : localization.signUp,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
            spacer(10),
          ],
        ),
      ),
    );
  }
}
