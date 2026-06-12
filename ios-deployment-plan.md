# iOS Deployment Plan for Weekplanner

## Context

The weekplanner Flutter frontend currently only has `web/` and `linux/` platform directories. The backends are already running on Strato (`130.225.39.225` — core on `:8000`, weekplanner-api on `:5171`). We need to get the app running natively on iPads for real user testing at Egebakken/Birken. The development machine is Linux, so a Mac is needed for iOS builds.

## Prerequisites

- **Mac** with Xcode 15+ (16 recommended) and Flutter 3.41+
- **iPad** connected via USB for initial testing
- **Apple ID** (free tier is enough to start; $99/yr Developer Program for TestFlight later)

## Step 1: Generate iOS platform directory (on Mac)

```bash
cd weekplanner/frontend
flutter create --platforms=ios .
```

## Step 2: Configure iOS project

All changes in the generated `ios/` directory:

### 2a. `ios/Podfile` — set minimum target
```ruby
platform :ios, '16.0'
```

### 2b. Xcode project settings (via Xcode GUI or `project.pbxproj`)
- Bundle ID: `dk.aau.giraf.weekplanner`
- Deployment target: iOS 16.0
- Device family: iPad only (`TARGETED_DEVICE_FAMILY = 2`)

### 2c. `ios/Runner/Info.plist` — orientation, permissions, ATS

**Landscape-only + fullscreen:**
```xml
<key>UISupportedInterfaceOrientations~ipad</key>
<array>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
<key>UIRequiresFullScreen</key>
<true/>
```

**Privacy descriptions** (Danish, matching target users):
```xml
<key>NSCameraUsageDescription</key>
<string>Weekplanner bruger kameraet til at tage billeder til aktiviteter.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Weekplanner bruger fotoarkivet til at vælge billeder til aktiviteter.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Weekplanner bruger mikrofonen til lydoptagelse.</string>
```

**ATS exception for plain HTTP to Strato:**
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>130.225.39.225</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Step 3: Install native dependencies

```bash
flutter pub get
cd ios && pod install
```

## Step 4: Run on iPad

```bash
flutter run -d <ipad-device-id> \
  --dart-define=CORE_BASE_URL=http://130.225.39.225:8000 \
  --dart-define=WEEKPLANNER_BASE_URL=http://130.225.39.225:5171
```

Signing: use Personal Team (free Apple ID) in Xcode > Runner > Signing & Capabilities. App expires after 7 days but sufficient for dev testing.

## Step 5: Add iOS build to CI

Extend `.github/workflows/frontend-ci.yml` with:

```yaml
build-ios:
  runs-on: macos-latest
  defaults:
    run:
      working-directory: frontend
  steps:
    - uses: actions/checkout@v5
    - uses: subosito/flutter-action@v2
      with:
        channel: stable
    - run: flutter pub get
    - run: flutter build ios --no-codesign \
        --dart-define=CORE_BASE_URL=http://130.225.39.225:8000 \
        --dart-define=WEEKPLANNER_BASE_URL=http://130.225.39.225:5171
```

`--no-codesign` lets CI verify the build compiles without needing Apple signing certs.

## Step 6: Commit `ios/` directory

Add to version control with these `.gitignore` entries:
- `ios/Pods/`
- `ios/Flutter/Generated.xcconfig`
- `ios/.symlinks/`

## Step 7 (when ready for user testing): TestFlight

Requires Apple Developer Program ($99/yr). Check if AAU already has one (contact its@aau.dk).

```bash
flutter build ipa \
  --dart-define=CORE_BASE_URL=http://130.225.39.225:8000 \
  --dart-define=WEEKPLANNER_BASE_URL=http://130.225.39.225:5171
```

Upload via Transporter app or `xcrun altool`. Testers install via TestFlight app — no USB needed, builds valid for 90 days.

## Notes

- **Network check:** Before anything else, verify iPad can reach `http://130.225.39.225:8000/api/v1/health` from Safari. University WiFi may have firewall restrictions.
- **VTA reference:** `visual-tangible-artefacts/Frontend/vta_app/ios/` is a working iOS setup in the same project — use as reference for Info.plist and Podfile.
- **`image_picker` may be unused** — it's in `pubspec.yaml` but grep found zero imports in `lib/`. The app uses `file_picker` instead. Consider removing to reduce native dependency surface.
- **Long-term:** Put HTTPS on Strato to remove the ATS exception.

## Verification

1. App launches on iPad in landscape, no rotation to portrait
2. Login works (JWT from core-api via HTTP to Strato)
3. File picker opens for image/audio selection
4. Audio playback works
5. Secure storage persists tokens across app restarts
6. CI iOS build job passes with `--no-codesign`

## Key Files
- `weekplanner/frontend/pubspec.yaml`
- `weekplanner/frontend/lib/config/api_config.dart` — `--dart-define` handling
- `weekplanner/.github/workflows/frontend-ci.yml` — CI to extend
- `visual-tangible-artefacts/Frontend/vta_app/ios/` — reference iOS setup
