import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SupaSocialsAuth exposes opt-in native Google lightweight auth', () {
    final source = File(
      'lib/src/components/supa_socials_auth.dart',
    ).readAsStringSync();

    expect(source, contains('enableNativeGoogleLightweightAuth'));
    expect(source, contains('useNativeGoogleLightweightButtonAuth'));
    expect(source, contains('onNativeAuthStarted'));
    expect(source, contains('_notifyAuthStarted(socialProvider)'));
    expect(source, contains('static Future<bool> attemptNativeGoogleLightweightAuth'));
    expect(source, contains('NativeGoogleAuthController'));
    expect(source, contains('attemptLightweightSignIn'));
    expect(source, contains('signInInteractively'));
  });
}
