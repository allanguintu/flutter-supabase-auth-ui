import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum NativeGoogleSignInMode { lightweight, interactive }

class NativeGoogleSignInRequest {
  final NativeGoogleSignInMode mode;
  final String hashedNonce;
  final List<String> scopes;

  const NativeGoogleSignInRequest({
    required this.mode,
    required this.hashedNonce,
    required this.scopes,
  });
}

class NativeGoogleCredential {
  final String idToken;
  final String? accessToken;

  const NativeGoogleCredential({
    required this.idToken,
    this.accessToken,
  });
}

abstract interface class NativeGoogleAuthGateway {
  Future<NativeGoogleCredential?> signIn(NativeGoogleSignInRequest request);

  Future<void> signOut();
}

abstract interface class NativeGoogleSupabaseAuth {
  String generateRawNonce();

  Future<void> signInWithGoogleIdToken({
    required String idToken,
    required String rawNonce,
    String? accessToken,
  });
}

class NativeGoogleAuthController {
  final NativeGoogleAuthGateway googleGateway;
  final NativeGoogleSupabaseAuth supabaseAuth;
  final List<String> scopes;

  const NativeGoogleAuthController({
    required this.googleGateway,
    required this.supabaseAuth,
    required this.scopes,
  });

  Future<bool> attemptLightweightSignIn() async {
    final result = await _requestGoogleCredential(
      NativeGoogleSignInMode.lightweight,
    );
    if (result == null) return false;

    await _signInToSupabase(result);
    return true;
  }

  Future<void> signInInteractively() async {
    final result = await _requestGoogleCredential(
      NativeGoogleSignInMode.interactive,
    );
    if (result == null) return;

    await _signInToSupabase(result);
  }

  Future<void> signOut() => googleGateway.signOut();

  Future<_NativeGoogleSignInResult?> _requestGoogleCredential(
    NativeGoogleSignInMode mode,
  ) async {
    final rawNonce = supabaseAuth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await googleGateway.signIn(
      NativeGoogleSignInRequest(
        mode: mode,
        hashedNonce: hashedNonce,
        scopes: scopes,
      ),
    );
    if (credential == null) return null;

    return _NativeGoogleSignInResult(
      credential: credential,
      rawNonce: rawNonce,
    );
  }

  Future<void> _signInToSupabase(_NativeGoogleSignInResult result) {
    return supabaseAuth.signInWithGoogleIdToken(
      idToken: result.credential.idToken,
      accessToken: result.credential.accessToken,
      rawNonce: result.rawNonce,
    );
  }
}

class _NativeGoogleSignInResult {
  final NativeGoogleCredential credential;
  final String rawNonce;

  const _NativeGoogleSignInResult({
    required this.credential,
    required this.rawNonce,
  });
}

class GoogleSignInNativeGoogleAuthGateway implements NativeGoogleAuthGateway {
  GoogleSignInNativeGoogleAuthGateway({
    GoogleSignIn? googleSignIn,
    required this.webClientId,
    required this.iosClientId,
  }) : googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn googleSignIn;
  final String? webClientId;
  final String? iosClientId;

  @override
  Future<NativeGoogleCredential?> signIn(
    NativeGoogleSignInRequest request,
  ) async {
    await googleSignIn.initialize(
      clientId: iosClientId,
      serverClientId: webClientId,
      nonce: request.hashedNonce,
    );

    final googleUser = switch (request.mode) {
      NativeGoogleSignInMode.lightweight =>
        await googleSignIn.attemptLightweightAuthentication(),
      NativeGoogleSignInMode.interactive => await googleSignIn.authenticate(),
    };
    if (googleUser == null) return null;

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw const AuthException(
        'No ID Token found from Google sign in result.',
      );
    }

    final authorization = await googleUser.authorizationClient
        .authorizationForScopes(request.scopes);

    return NativeGoogleCredential(
      idToken: idToken,
      accessToken: authorization?.accessToken,
    );
  }

  @override
  Future<void> signOut() => googleSignIn.signOut();
}

class SupabaseNativeGoogleAuth implements NativeGoogleSupabaseAuth {
  @override
  String generateRawNonce() => Supabase.instance.client.auth.generateRawNonce();

  @override
  Future<void> signInWithGoogleIdToken({
    required String idToken,
    required String rawNonce,
    String? accessToken,
  }) {
    return Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
      nonce: rawNonce,
    );
  }
}
