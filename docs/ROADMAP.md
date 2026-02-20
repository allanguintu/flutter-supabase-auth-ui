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

- Review open issues and pull requests on
  [supabase-community/flutter-auth-ui](https://github.com/supabase-community/flutter-auth-ui)
  and integrate relevant fixes/features not yet covered.
  - Issues: https://github.com/supabase-community/flutter-auth-ui/issues
  - Pull Requests: https://github.com/supabase-community/flutter-auth-ui/pulls
