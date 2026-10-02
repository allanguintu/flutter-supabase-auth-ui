import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class _Google extends GoogleSignInPlatform {
  Completer<AuthenticationResults?> attempt =
      Completer<AuthenticationResults?>();
  @override
  Future<void> init(InitParameters params) async {}
  @override
  Future<AuthenticationResults?> attemptLightweightAuthentication(
    AttemptLightweightAuthenticationParameters params,
  ) =>
      attempt.future;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
        url: 'https://example.supabase.co', anonKey: 'test');
  });
  tearDownAll(() => Supabase.instance.dispose());

  testWidgets('silent native cancellation completes and allows another attempt',
      (tester) async {
    final original = GoogleSignInPlatform.instance;
    final google = _Google();
    GoogleSignInPlatform.instance = google;
    addTearDown(() => GoogleSignInPlatform.instance = original);
    final events = <String>[];
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SupaSocialsAuth(
      socialProviders: const [OAuthProvider.google],
      nativeGoogleAuthConfig: const NativeGoogleAuthConfig(webClientId: 'test'),
      useNativeGoogleLightweightButtonAuth: true,
      onNativeAuthStarted: (_) => events.add('started'),
      onNativeAuthFinished: (_) => events.add('finished'),
      onSuccess: (_) => events.add('success'),
      onError: (_) => events.add('error'),
    ))));
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 2; attempt++) {
      google.attempt = Completer<AuthenticationResults?>();
      await tester.tap(find.text('Continue with Google'));
      await tester.pump();
      expect(events.last, 'started');
      google.attempt.complete(null);
      await tester.pumpAndSettle();
      expect(events.last, 'finished');
      expect(
          tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
          isNotNull);
    }
    expect(events, ['started', 'finished', 'started', 'finished']);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
