# Mobile Build and Signing

## Android

Android build configuration lives in `luna_lighthouse/android/app/build.gradle`.

Current mobile identifiers and SDK levels:

- `namespace`: `app.lunalighthouse.lunalighthouse`
- `applicationId`: `app.lunalighthouse.lunalighthouse`
- `compileSdkVersion`: `35`
- `minSdkVersion`: `24`
- `targetSdkVersion`: `35`

Release signing reads `key.properties` from the Android project root and uses `keyAlias`, `keyPassword`, `storeFile`, and `storePassword`. Debug builds append `applicationIdSuffix ".debug"` and `versionNameSuffix "-dev"`.

## iOS

iOS signing is configured in `luna_lighthouse/ios/Runner.xcodeproj/project.pbxproj`.

Current values include:

- `PRODUCT_BUNDLE_IDENTIFIER = app.lunalighthouse.lunalighthouse`
- `DEVELOPMENT_TEAM = VPH33JQH4R`
- Manual signing
- Release provisioning profile `match AppStore app.lunalighthouse.lunalighthouse`
- Debug/Profile provisioning profile `match Development app.lunalighthouse.lunalighthouse`

## Build Commands

`luna_lighthouse/package.json` defines `build:android` as `flutter clean && flutter build apk --release` and `build:ios` as `flutter clean && flutter build ipa --release`.

