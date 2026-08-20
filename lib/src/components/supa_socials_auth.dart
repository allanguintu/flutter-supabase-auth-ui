import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_auth_ui/src/components/native_google_auth.dart';
import 'package:supabase_auth_ui/src/localizations/supa_socials_auth_localization.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension on OAuthProvider {
  IconData get iconData => switch (this) {
        OAuthProvider.apple => FontAwesomeIcons.apple.data,
        OAuthProvider.azure => FontAwesomeIcons.microsoft.data,
        OAuthProvider.bitbucket => FontAwesomeIcons.bitbucket.data,
        OAuthProvider.discord => FontAwesomeIcons.discord.data,
        OAuthProvider.facebook => FontAwesomeIcons.facebook.data,
        OAuthProvider.figma => FontAwesomeIcons.figma.data,
        OAuthProvider.github => FontAwesomeIcons.github.data,
        OAuthProvider.gitlab => FontAwesomeIcons.gitlab.data,
        OAuthProvider.google => FontAwesomeIcons.google.data,
        OAuthProvider.linkedin => FontAwesomeIcons.linkedin.data,
        OAuthProvider.slack => FontAwesomeIcons.slack.data,
        OAuthProvider.spotify => FontAwesomeIcons.spotify.data,
        OAuthProvider.twitch => FontAwesomeIcons.twitch.data,
        OAuthProvider.twitter => FontAwesomeIcons.xTwitter.data,
        _ => Icons.close,
      };

  Color get btnBgColor => switch (this) {
        OAuthProvider.apple => Colors.black,
        OAuthProvider.azure => Colors.blueAccent,
        OAuthProvider.bitbucket => Colors.blue,
        OAuthProvider.discord => Colors.purple,
        OAuthProvider.facebook => const Color(0xFF3b5998),
        OAuthProvider.figma => const Color.fromRGBO(241, 77, 27, 1),
        OAuthProvider.github => Colors.black,
        OAuthProvider.gitlab => Colors.deepOrange,
        OAuthProvider.google => Colors.white,
        OAuthProvider.kakao => const Color(0xFFFFE812),
        OAuthProvider.keycloak => const Color.fromRGBO(0, 138, 170, 1),
        OAuthProvider.linkedin => const Color.fromRGBO(0, 136, 209, 1),
        OAuthProvider.notion => const Color.fromRGBO(69, 75, 78, 1),
        OAuthProvider.slack => const Color.fromRGBO(74, 21, 75, 1),
        OAuthProvider.spotify => Colors.green,
        OAuthProvider.twitch => Colors.purpleAccent,
        OAuthProvider.twitter => Colors.black,
        OAuthProvider.workos => const Color.fromRGBO(99, 99, 241, 1),
        // ignore: unreachable_switch_case
        _ => Colors.black,
      };

  String get labelText =>
      'Continue with ${name[0].toUpperCase()}${name.substring(1)}';
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

class NativeGoogleAuthConfig {
  /// Web Client ID that you registered with Google Cloud.
  ///
  /// Required to perform native Google Sign In on Android
  final String? webClientId;

  /// iOS Client ID that you registered with Google Cloud.
  ///
  /// Required to perform native Google Sign In on iOS
  final String? iosClientId;

  const NativeGoogleAuthConfig({
    this.webClientId,
    this.iosClientId,
  });
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// Defines native google provider to show in the form
  final NativeGoogleAuthConfig? nativeGoogleAuthConfig;

  /// Whether to attempt Android Credential Manager lightweight Google auth
  /// when this widget appears.
  ///
  /// This is opt-in because Android may show system UI before the user taps the
  /// Google button.
  final bool enableNativeGoogleLightweightAuth;

  /// Whether the native Google button should use Android Credential Manager's
  /// lightweight bottom sheet instead of the interactive Google flow.
  final bool useNativeGoogleLightweightButtonAuth;

  /// Called just before a provider auth UI is opened.
  final FutureOr<void> Function(OAuthProvider provider)? onNativeAuthStarted;

  /// Whether to use native Apple sign in on iOS and macOS
  final bool enableNativeAppleAuth;

  /// List of social providers to show in the form
  final List<OAuthProvider> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// Whether or not to show the icon only or icon and text
  final SocialButtonVariant socialButtonVariant;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  /// OpenID scope(s) for provider authorization request (ex. '.default')
  final Map<OAuthProvider, String>? scopes;

  /// Parameters to include in provider authorization request (ex. {'prompt': 'consent'})
  final Map<OAuthProvider, Map<String, String>>? queryParams;

  /// Localization for the form
  final SupaSocialsAuthLocalization? localization;

  /// Custom LaunchMode support
  final LaunchMode authScreenLaunchMode;

  /// Optional widget builder to render above the buttons
  final Widget Function(BuildContext)? headerBuilder;

  /// Optional widget builder to render below the buttons
  final Widget Function(BuildContext)? footerBuilder;

  const SupaSocialsAuth({
    super.key,
    this.nativeGoogleAuthConfig,
    this.enableNativeGoogleLightweightAuth = false,
    this.useNativeGoogleLightweightButtonAuth = false,
    this.onNativeAuthStarted,
    this.enableNativeAppleAuth = true,
    required this.socialProviders,
    this.colored = true,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
    this.socialButtonVariant = SocialButtonVariant.iconAndText,
    this.showSuccessSnackBar = true,
    this.scopes,
    this.queryParams,
    this.localization,
    this.authScreenLaunchMode = LaunchMode.platformDefault,
    this.headerBuilder,
    this.footerBuilder,
  });

  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  static Future<bool> attemptNativeGoogleLightweightAuth({
    required NativeGoogleAuthConfig nativeGoogleAuthConfig,
    Map<OAuthProvider, String>? scopes,
  }) async {
    final webClientId = nativeGoogleAuthConfig.webClientId;
    if (webClientId == null || kIsWeb || !Platform.isAndroid) return false;
    if (Supabase.instance.client.auth.currentSession != null) return false;

    return NativeGoogleAuthController(
      googleGateway: GoogleSignInNativeGoogleAuthGateway(
        webClientId: webClientId,
        iosClientId: nativeGoogleAuthConfig.iosClientId,
      ),
      supabaseAuth: SupabaseNativeGoogleAuth(),
      scopes: _nativeGoogleScopes(scopes),
    ).attemptLightweightSignIn();
  }

  static List<String> _nativeGoogleScopes(Map<OAuthProvider, String>? scopes) {
    final scopeString = scopes?[OAuthProvider.google];
    return scopeString != null && scopeString.isNotEmpty
        ? scopeString.split(' ')
        : ['email'];
  }

  @override
  State<SupaSocialsAuth> createState() => _SupaSocialsAuthState();
}

class _SupaSocialsAuthState extends State<SupaSocialsAuth> {
  late final StreamSubscription<AuthState> _gotrueSubscription;
  late SupaSocialsAuthLocalization localization;
  bool _isLoading = false;
  bool _nativeGoogleLightweightStarted = false;

  Future<void> _notifyAuthStarted(OAuthProvider provider) async {
    await widget.onNativeAuthStarted?.call(provider);
  }

  /// Performs Google sign in on Android and iOS
  Future<void> _nativeGoogleSignIn({
    required String? webClientId,
    required String? iosClientId,
  }) async {
    await _notifyAuthStarted(OAuthProvider.google);

    final controller = _nativeGoogleAuthController(
      webClientId: webClientId,
      iosClientId: iosClientId,
    );

    if (widget.useNativeGoogleLightweightButtonAuth &&
        webClientId != null &&
        !kIsWeb &&
        Platform.isAndroid) {
      await controller.attemptLightweightSignIn();
      return;
    }

    await controller.signInInteractively();
  }

  NativeGoogleAuthController _nativeGoogleAuthController({
    required String? webClientId,
    required String? iosClientId,
  }) {
    return NativeGoogleAuthController(
      googleGateway: GoogleSignInNativeGoogleAuthGateway(
        webClientId: webClientId,
        iosClientId: iosClientId,
      ),
      supabaseAuth: SupabaseNativeGoogleAuth(),
      scopes: SupaSocialsAuth._nativeGoogleScopes(widget.scopes),
    );
  }

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> _nativeAppleSignIn() async {
    await _notifyAuthStarted(OAuthProvider.apple);

    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated Apple sign in credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localization = widget.localization ??
        SupaSocialsAuthLocalization.fromLocale(
            Localizations.maybeLocaleOf(context) ?? const Locale('en'));
  }

  @override
  void initState() {
    super.initState();
    _gotrueSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (data.event == AuthChangeEvent.signedIn &&
          session != null &&
          mounted) {
        widget.onSuccess.call(session);
        if (widget.showSuccessSnackBar) {
          context.showSnackBar(localization.successSignInMessage);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptNativeGoogleLightweightSignIn();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gotrueSubscription.cancel();
  }

  Future<void> _attemptNativeGoogleLightweightSignIn() async {
    if (!mounted || _nativeGoogleLightweightStarted) return;
    if (!widget.enableNativeGoogleLightweightAuth) return;
    if (!widget.socialProviders.contains(OAuthProvider.google)) return;
    if (Supabase.instance.client.auth.currentSession != null) return;

    final googleAuthConfig = widget.nativeGoogleAuthConfig;
    final webClientId = googleAuthConfig?.webClientId;
    if (webClientId == null || kIsWeb || !Platform.isAndroid) return;

    _nativeGoogleLightweightStarted = true;
    try {
      await SupaSocialsAuth.attemptNativeGoogleLightweightAuth(
        nativeGoogleAuthConfig: googleAuthConfig!,
        scopes: widget.scopes,
      );
    } on AuthException catch (error) {
      _handleAuthError(error, fallbackMessage: error.message);
    } catch (error) {
      _handleAuthError(error);
    }
  }

  void _handleAuthError(Object error, {String? fallbackMessage}) {
    if (widget.onError == null && context.mounted) {
      context.showErrorSnackBar(
        fallbackMessage ?? '${localization.unexpectedError}: $error',
      );
    } else {
      widget.onError?.call(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final googleAuthConfig = widget.nativeGoogleAuthConfig;
    final isNativeAppleAuthEnabled = widget.enableNativeAppleAuth;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    final authButtons = List.generate(
      providers.length,
      (index) {
        final socialProvider = providers[index];

        Color? foregroundColor = coloredBg ? Colors.white : null;
        Color? backgroundColor = coloredBg ? socialProvider.btnBgColor : null;
        Color? overlayColor = coloredBg ? Colors.white10 : null;

        Color? iconColor = coloredBg ? Colors.white : null;

        Widget iconWidget = SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            socialProvider.iconData,
            color: iconColor,
          ),
        );
        if (socialProvider == OAuthProvider.google && coloredBg) {
          iconWidget = Image.asset(
            'assets/logos/google_light.png',
            package: 'supabase_auth_ui',
            width: 48,
            height: 48,
          );
          foregroundColor = Colors.black;
          backgroundColor = Colors.white;
          overlayColor = Colors.white;
        }

        switch (socialProvider) {
          case OAuthProvider.notion:
            iconWidget = Image.asset(
              'assets/logos/notion.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.kakao:
            iconWidget = Image.asset(
              'assets/logos/kakao.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.keycloak:
            iconWidget = Image.asset(
              'assets/logos/keycloak.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.workos:
            iconWidget = Image.asset(
              'assets/logos/workOS.png',
              package: 'supabase_auth_ui',
              color: coloredBg ? Colors.white : null,
              width: 48,
              height: 48,
            );
            break;
          default:
            break;
        }

        onAuthButtonPressed() async {
          setState(() => _isLoading = true);
          try {
            // Check if native Google login should be performed
            if (socialProvider == OAuthProvider.google) {
              final webClientId = googleAuthConfig?.webClientId;
              final iosClientId = googleAuthConfig?.iosClientId;
              final shouldPerformNativeGoogleSignIn =
                  (webClientId != null && !kIsWeb && Platform.isAndroid) ||
                      (iosClientId != null && !kIsWeb && Platform.isIOS);
              if (shouldPerformNativeGoogleSignIn) {
                await _nativeGoogleSignIn(
                  webClientId: webClientId,
                  iosClientId: iosClientId,
                );
                return;
              }
            }

            // Check if native Apple login should be performed
            if (socialProvider == OAuthProvider.apple) {
              final shouldPerformNativeAppleSignIn =
                  (isNativeAppleAuthEnabled && !kIsWeb && Platform.isIOS) ||
                      (isNativeAppleAuthEnabled && !kIsWeb && Platform.isMacOS);
              if (shouldPerformNativeAppleSignIn) {
                await _nativeAppleSignIn();
                return;
              }
            }

            final user = supabase.auth.currentUser;
            if (user?.isAnonymous == true) {
              await _notifyAuthStarted(socialProvider);
              await supabase.auth.linkIdentity(
                socialProvider,
                redirectTo: widget.redirectUrl,
                scopes: widget.scopes?[socialProvider],
                queryParams: widget.queryParams?[socialProvider],
              );
              return;
            }

            await _notifyAuthStarted(socialProvider);
            await supabase.auth.signInWithOAuth(
              socialProvider,
              redirectTo: widget.redirectUrl,
              scopes: widget.scopes?[socialProvider],
              queryParams: widget.queryParams?[socialProvider],
              authScreenLaunchMode: widget.authScreenLaunchMode,
            );
          } on AuthException catch (error) {
            _handleAuthError(error, fallbackMessage: error.message);
          } catch (error) {
            _handleAuthError(error);
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        }

        final authButtonStyle = ButtonStyle(
          foregroundColor: WidgetStateProperty.all(foregroundColor),
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          overlayColor: WidgetStateProperty.all(overlayColor),
          iconColor: WidgetStateProperty.all(iconColor),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: widget.socialButtonVariant == SocialButtonVariant.icon
              ? Semantics(
                  label: localization.oAuthButtonLabels[socialProvider] ??
                      socialProvider.labelText,
                  button: true,
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 2,
                    color: backgroundColor,
                    child: InkResponse(
                      radius: 24,
                      onTap: _isLoading ? null : onAuthButtonPressed,
                      child: iconWidget,
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  icon: iconWidget,
                  style: authButtonStyle,
                  onPressed: _isLoading ? null : onAuthButtonPressed,
                  label: Text(
                    localization.oAuthButtonLabels[socialProvider] ??
                        socialProvider.labelText,
                  ),
                ),
        );
      },
    );

    final authContent = widget.socialButtonVariant == SocialButtonVariant.icon
        ? Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: authButtons,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: authButtons,
          );
    if (widget.headerBuilder == null && widget.footerBuilder == null) {
      return authContent;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.headerBuilder != null) widget.headerBuilder!(context),
        authContent,
        if (widget.footerBuilder != null) widget.footerBuilder!(context),
      ],
    );
  }
}
