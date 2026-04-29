# Maestro E2E Smoke Coverage

These flows provide launch-smoke coverage for LunaLighthouse on local Android and iOS targets.

## App IDs

- Android debug: `app.lunalighthouse.lunalighthouse.debug`
- iOS simulator: `app.lunalighthouse.lunalighthouse`

## Syntax check

From `luna_lighthouse/`:

```bash
maestro check-syntax .maestro/flows/android/launch_smoke.yaml
maestro check-syntax .maestro/flows/ios/launch_smoke.yaml
```

## Android local run

Start an Android emulator, install the debug build, then run the Android-tagged workspace flows:

```bash
export PATH="$HOME/.sdk/flutter/bin:$PATH"
flutter install -d <android-device-id> --debug
maestro --platform android --device <android-device-id> test --include-tags android .maestro
```

## iOS simulator local run

Boot an iOS simulator, install the simulator build, then run the iOS-tagged workspace flows:

```bash
export PATH="$HOME/.sdk/flutter/bin:$PATH"
flutter build ios --simulator --debug
xcrun simctl install <simulator-udid> build/ios/iphonesimulator/Runner.app
maestro --platform ios --device <simulator-udid> test --include-tags ios .maestro
```

The smoke flows intentionally avoid `clearState` so a local developer does not accidentally wipe simulator/emulator app data while checking launch behavior.
