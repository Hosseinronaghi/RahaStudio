#!/usr/bin/env bash
set -euo pipefail

APP_GRADLE="android/app/build.gradle.kts"
MANIFEST="android/app/src/main/AndroidManifest.xml"
GRADLE_PROPERTIES="android/gradle.properties"
MAIN_ACTIVITY_DIR="android/app/src/main/kotlin/com/rahastudio/app"
MAIN_ACTIVITY_TEMPLATE="tool/android_template/MainActivity.kt"

[[ -f "$APP_GRADLE" ]] || { echo "Missing $APP_GRADLE"; exit 1; }
[[ -f "$MANIFEST" ]] || { echo "Missing $MANIFEST"; exit 1; }
[[ -f "$MAIN_ACTIVITY_TEMPLATE" ]] || { echo "Missing $MAIN_ACTIVITY_TEMPLATE"; exit 1; }

python3 - <<'PY'
from pathlib import Path

gradle = Path("android/app/build.gradle.kts")
text = gradle.read_text()
replacements = {
    "namespace = \"com.rahastudio.raha_studio\"": "namespace = \"com.rahastudio.app\"",
    "applicationId = \"com.rahastudio.raha_studio\"": "applicationId = \"com.rahastudio.app\"",
    "compileSdk = flutter.compileSdkVersion": "compileSdk = 36",
    "targetSdk = flutter.targetSdkVersion": "targetSdk = 36",
    "minSdk = flutter.minSdkVersion": "minSdk = 29",
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"Expected Gradle line not found: {old}")
    text = text.replace(old, new)

signing_block = '''
    signingConfigs {
        if (project.hasProperty("RAHA_STORE_FILE")) {
            create("release") {
                storeFile = file(project.property("RAHA_STORE_FILE") as String)
                storePassword = project.property("RAHA_STORE_PASSWORD") as String
                keyAlias = project.property("RAHA_KEY_ALIAS") as String
                keyPassword = project.property("RAHA_KEY_PASSWORD") as String
                enableV1Signing = true
                enableV2Signing = true
                enableV3Signing = true
                enableV4Signing = true
            }
        }
    }
'''
if "signingConfigs {" not in text:
    text = text.replace("    defaultConfig {", signing_block + "\n    defaultConfig {")

text = text.replace(
    'signingConfig = signingConfigs.getByName("debug")',
    'signingConfig = if (project.hasProperty("RAHA_STORE_FILE")) '
    'signingConfigs.getByName("release") else signingConfigs.getByName("debug")'
)
gradle.write_text(text)

manifest = Path("android/app/src/main/AndroidManifest.xml")
m = manifest.read_text()
m = m.replace('android:label="raha_studio"', 'android:label="Raha Studio"')
m = m.replace(
    '<application',
    '<application android:allowBackup="false" '
    'android:fullBackupContent="false" '
    'android:usesCleartextTraffic="false"',
    1,
)
m = m.replace(
    'android:name=".MainActivity"',
    'android:name="com.rahastudio.app.MainActivity"',
)
manifest.write_text(m)
PY

mkdir -p "$MAIN_ACTIVITY_DIR"
cp "$MAIN_ACTIVITY_TEMPLATE" "$MAIN_ACTIVITY_DIR/MainActivity.kt"

touch "$GRADLE_PROPERTIES"
set_prop() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" "$GRADLE_PROPERTIES"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$GRADLE_PROPERTIES"
  else
    echo "${key}=${value}" >> "$GRADLE_PROPERTIES"
  fi
}
set_prop org.gradle.jvmargs "-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=512m"
set_prop android.useAndroidX "true"
set_prop android.enableJetifier "true"
set_prop org.gradle.vfs.watch "false"

grep -q 'applicationId = "com.rahastudio.app"' "$APP_GRADLE"
grep -q 'compileSdk = 36' "$APP_GRADLE"
grep -q 'targetSdk = 36' "$APP_GRADLE"
grep -q 'minSdk = 29' "$APP_GRADLE"
grep -q 'android:usesCleartextTraffic="false"' "$MANIFEST"

echo "Android hardening and configuration verified."
