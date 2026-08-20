import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_auth_ui/src/components/native_google_auth.dart';

void main() {
  test('lightweight sign-in exchanges Google ID token with Supabase', () async {
    final gateway = _FakeGoogleGateway(
      credential: const NativeGoogleCredential(
        idToken: 'google-id-token',
        accessToken: 'google-access-token',
      ),
    );
    final supabase = _FakeSupabaseGoogleAuth(rawNonce: 'raw-nonce');
    final controller = NativeGoogleAuthController(
      googleGateway: gateway,
      supabaseAuth: supabase,
      scopes: const ['email'],
    );

    final didSignIn = await controller.attemptLightweightSignIn();

    expect(didSignIn, isTrue);
    expect(gateway.requests, hasLength(1));
    expect(gateway.requests.single.mode, NativeGoogleSignInMode.lightweight);
    expect(gateway.requests.single.scopes, const ['email']);
    expect(
      gateway.requests.single.hashedNonce,
      '2c5d107938053a2275f022c153c9a71f65ee07754b8bca543ee97a0c3cc66990',
    );
    expect(supabase.nonceCalls, 1);
    expect(
      supabase.signIns.single,
      const _SupabaseSignIn(
        idToken: 'google-id-token',
        accessToken: 'google-access-token',
        nonce: 'raw-nonce',
      ),
    );
  });

  test('lightweight sign-in skips Supabase when no account is available',
      () async {
    final gateway = _FakeGoogleGateway();
    final supabase = _FakeSupabaseGoogleAuth(rawNonce: 'raw-nonce');
    final controller = NativeGoogleAuthController(
      googleGateway: gateway,
      supabaseAuth: supabase,
      scopes: const ['email'],
    );

    final didSignIn = await controller.attemptLightweightSignIn();

    expect(didSignIn, isFalse);
    expect(gateway.requests.single.mode, NativeGoogleSignInMode.lightweight);
    expect(supabase.signIns, isEmpty);
  });

  test('interactive sign-in exchanges selected Google account', () async {
    final gateway = _FakeGoogleGateway(
      credential: const NativeGoogleCredential(idToken: 'selected-id-token'),
    );
    final supabase = _FakeSupabaseGoogleAuth(rawNonce: 'raw-nonce');
    final controller = NativeGoogleAuthController(
      googleGateway: gateway,
      supabaseAuth: supabase,
      scopes: const ['email'],
    );

    await controller.signInInteractively();

    expect(gateway.requests.single.mode, NativeGoogleSignInMode.interactive);
    expect(
      supabase.signIns.single,
      const _SupabaseSignIn(
        idToken: 'selected-id-token',
        accessToken: null,
        nonce: 'raw-nonce',
      ),
    );
  });
}

class _FakeGoogleGateway implements NativeGoogleAuthGateway {
  _FakeGoogleGateway({this.credential});

  final NativeGoogleCredential? credential;
  final List<NativeGoogleSignInRequest> requests =
      <NativeGoogleSignInRequest>[];

  @override
  Future<NativeGoogleCredential?> signIn(
    NativeGoogleSignInRequest request,
  ) async {
    requests.add(request);
    return credential;
  }

  @override
  Future<void> signOut() async {}
}

class _FakeSupabaseGoogleAuth implements NativeGoogleSupabaseAuth {
  _FakeSupabaseGoogleAuth({required this.rawNonce});

  final String rawNonce;
  int nonceCalls = 0;
  final List<_SupabaseSignIn> signIns = <_SupabaseSignIn>[];

  @override
  String generateRawNonce() {
    nonceCalls += 1;
    return rawNonce;
  }

  @override
  Future<void> signInWithGoogleIdToken({
    required String idToken,
    required String rawNonce,
    String? accessToken,
  }) async {
    signIns.add(
      _SupabaseSignIn(
        idToken: idToken,
        accessToken: accessToken,
        nonce: rawNonce,
      ),
    );
  }
}

class _SupabaseSignIn {
  final String idToken;
  final String? accessToken;
  final String nonce;

  const _SupabaseSignIn({
    required this.idToken,
    required this.accessToken,
    required this.nonce,
  });

  @override
  bool operator ==(Object other) =>
      other is _SupabaseSignIn &&
      other.idToken == idToken &&
      other.accessToken == accessToken &&
      other.nonce == nonce;

  @override
  int get hashCode => Object.hash(idToken, accessToken, nonce);

  @override
  String toString() =>
      '_SupabaseSignIn(idToken: $idToken, accessToken: $accessToken, nonce: $nonce)';
}
