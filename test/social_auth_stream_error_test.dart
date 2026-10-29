import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-key',
    );
  });
  tearDownAll(() => Supabase.instance.dispose());
  testWidgets('social OAuth errors reach UI without uncaught errors', (
    tester,
  ) async {
    final errors = <Object>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SupaSocialsAuth(
            socialProviders: const [OAuthProvider.google],
            onSuccess: (_) => fail('A failed callback must not sign in'),
            onError: errors.add,
          ),
        ),
      ),
    );
    const failure = AuthException(
      'Error getting user email from external provider',
      statusCode: 'unexpected_failure',
      code: 'server_error',
    );
    // Reproduce SupabaseAuth._handleDeeplink's error broadcast.
    // ignore: invalid_use_of_internal_member
    Supabase.instance.client.auth.notifyException(failure, StackTrace.current);
    await tester.pump();
    expect(errors, [failure]);
    expect(tester.takeException(), isNull);
    // ignore: invalid_use_of_internal_member
    Supabase.instance.client.auth.notifyException(failure, StackTrace.current);
    await tester.pump();
    expect(errors, [failure, failure]);
    await tester.pumpWidget(const SizedBox());
    // ignore: invalid_use_of_internal_member
    Supabase.instance.client.auth.notifyException(failure, StackTrace.current);
    await tester.pump();
    expect(errors, hasLength(2));
    expect(tester.takeException(), isNull);
  });
}
