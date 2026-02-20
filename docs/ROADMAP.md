# Roadmap flutter-supabase-auth-ui

---

## 0.6.X — Local Improvements

### Fixes

#### 0.6.1
- **Fix** `Localizations.localeOf(context)` crash when there is no `MaterialApp` ancestor
  — Use `Localizations.maybeLocaleOf(context)` with an English fallback.

- **Fix** Debounce on the submit button of `SupaEmailAuth` and `SupaPhoneAuth`
  — Without debounce, a quick double-tap can send two simultaneous requests to Supabase
  (two signup attempts → "user already registered" error, or two parallel sign-ins).
  Disable the button on the first press and re-enable it after the response.

- **Fix** Disable social buttons (`SupaSocialsAuth`) during the OAuth flow
  — A double-tap on the Google button opens two parallel OAuth flows
  → unpredictable behaviour, token race condition.

---

### Features

#### 0.6.2 — `MetaDataField` enhancements
- **Feature** Configurable `keyboardType` on `MetaDataField`
  — Allows the correct keyboard to be shown depending on the field (numeric, email, URL, etc.)
- **Feature** `obscureText` on `MetaDataField`
  — For sensitive fields such as a referral code.
  Text is masked with dots like a password field.

#### 0.6.3 — Accessibility
- **Feature** `semanticsLabel` on social buttons (`SupaSocialsAuth`)
  — Screen readers (VoiceOver, TalkBack) read this label to visually impaired users.
  Without it, a button with only the Google icon is announced as "unlabelled button".
- **Feature** `tooltip` on the password visibility toggle button
  — Shows "Show password" / "Hide password" on long press.

#### 0.6.4 — Field customisation
- **Feature** Configurable `prefixIcon` / `suffixIcon` on the email and phone fields
  of `SupaEmailAuth` and `SupaPhoneAuth` (currently hardcoded to `Icons.email`, `Icons.phone`)
- **Feature** `headerBuilder` / `footerBuilder` on `SupaEmailAuth` and `SupaSocialsAuth`
  — Allows injecting a custom widget above or below the form
  (e.g. logo, title, terms link, promo banner).

#### 0.6.5 — UX
- **Feature** `clearOnError` (bool, default `false`) on `SupaEmailAuth` and `SupaPhoneAuth`
  — If `true`, clears the password fields after an authentication error.

---

## 0.7.X — Upstream issues & PRs review

Sources:
[Issues](https://github.com/supabase-community/flutter-auth-ui/issues) ·
[Pull Requests](https://github.com/supabase-community/flutter-auth-ui/pulls)

Already covered in our fork (no action): #147, #148, #149 (onToggleRecoverPassword), #135, #128 (onSuccess twice).

---

### Fixes

#### 0.7.0

- **Fix** `BooleanMetaDataField` with `value: true` + `isRequired: true` rejects the initial value — [Issue #145](https://github.com/supabase-community/flutter-auth-ui/issues/145)
  — Internal state `_value` is always initialised to `false` regardless of `widget.value`.
  Fix: seed `_value = widget.value` in `initState`.

- **Fix** `OAuthProvider.slackOidc` and `linkedInOidc` have no icon, colour or label — [PR #127](https://github.com/supabase-community/flutter-auth-ui/pull/127)
  — Add them as aliases of their non-OIDC counterparts in the `OAuthProvider` extension.

#### 0.7.2

- **Fix** Sign in with Apple missing full name — [Issue #133](https://github.com/supabase-community/flutter-auth-ui/issues/133)
  — Apple provides `givenName`/`familyName` outside the ID token (once only, at first sign-in).
  After `signInWithIdToken`, call `updateUser(data: {'full_name': ...})` if
  `AuthorizationCredentialAppleID` contains a name.

#### 0.7.5

- **Fix** Anonymous user → OAuth re-link fails with `Identity is already linked` — [Issue #103](https://github.com/supabase-community/flutter-auth-ui/issues/103)
  — After sign-out a new anonymous session is automatically created;
  re-signing with the same OAuth provider triggers a conflict.
  Needs detection of the anonymous session + use of `linkIdentity` instead of `signInWithOAuth`.

---

### Features

#### 0.7.1

- **Feature** `prefilledEmail` / `prefilledPassword` on `SupaEmailAuth` — [PR #143](https://github.com/supabase-community/flutter-auth-ui/pull/143)
  — Initialise the `TextEditingController` with the supplied values.
  Useful for deep-link flows (e.g. invite email pre-fills the address).

- **Feature** `onPasswordResetEmailSent(String email)` callback — [PR #146](https://github.com/supabase-community/flutter-auth-ui/pull/146)
  — Current callback has no parameter; passing the email lets the app chain
  an OTP verification screen without asking for the address again.

#### 0.7.3

- **Feature** OTP-based password recovery flow — [PR #130](https://github.com/supabase-community/flutter-auth-ui/pull/130)
  — Alternative to the magic-link reset: user enters their email + a 6-digit OTP.
  Calls `verifyOTP(type: OtpType.recovery)`.

#### 0.7.4

- **Feature** `SupaAvatarAuth` component — [PR #136](https://github.com/supabase-community/flutter-auth-ui/pull/136)
  — New widget for uploading a profile picture to Supabase Storage
  (camera / gallery picker). Can be used standalone on a profile screen.
