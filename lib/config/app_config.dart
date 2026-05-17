import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppConfig {
  AppConfig._(); // prevent instantiation
  static String _get(String key) {
    final value = dotenv.env[key];
    assert(value != null && value.isNotEmpty,
        'AppConfig: missing required env key "$key". Check your .env file.');
    return value ?? '';
  }
  static String get firebaseProjectId => _get('FIREBASE_PROJECT_ID');
  static String get firebaseAuthDomain => _get('FIREBASE_AUTH_DOMAIN');
  static String get firebaseMessagingSenderId =>
      _get('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseStorageBucket => _get('FIREBASE_STORAGE_BUCKET');
  static String get firebaseWebApiKey => _get('FIREBASE_WEB_API_KEY');
  static String get firebaseWebAppId => _get('FIREBASE_WEB_APP_ID');
  static String get firebaseWebMeasurementId =>
      _get('FIREBASE_WEB_MEASUREMENT_ID');
  static String get firebaseAndroidApiKey => _get('FIREBASE_ANDROID_API_KEY');
  static String get firebaseAndroidAppId => _get('FIREBASE_ANDROID_APP_ID');
  static String get firebaseIosApiKey => _get('FIREBASE_IOS_API_KEY');
  static String get firebaseIosAppId => _get('FIREBASE_IOS_APP_ID');
  static String get firebaseIosBundleId => _get('FIREBASE_IOS_BUNDLE_ID');
  static String get firebaseWindowsAppId => _get('FIREBASE_WINDOWS_APP_ID');
  static String get firebaseWindowsMeasurementId =>
      _get('FIREBASE_WINDOWS_MEASUREMENT_ID');
  static String get googleLogoUrl => _get('GOOGLE_LOGO_URL');
}

