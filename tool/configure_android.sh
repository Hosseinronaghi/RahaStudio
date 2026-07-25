#!/usr/bin/env bash
set -euo pipefail

APP_GRADLE="android/app/build.gradle.kts"
GRADLE_PROPERTIES="android/gradle.properties"
MAIN_ACTIVITY_DIR="android/app/src/main/kotlin/com/rahastudio/raha_studio"
MAIN_ACTIVITY_TEMPLATE="tool/android_template/MainActivity.kt"

if [[ ! -f "$APP_GRADLE" ]]; then
  echo "Missing $APP_GRADLE. Run flutter create first."
  exit 1
fi

if [[ ! -f "$MAIN_ACTIVITY_TEMPLATE" ]]; then
  echo "Missing $MAIN_ACTIVITY_TEMPLATE."
  exit 1
fi

python3 - <<'PY'
from pathlib import Path

path = Path("android/app/build.gradle.kts")
text = path.read_text()

replacements = {
    "compileSdk = flutter.compileSdkVersion": "compileSdk = 36",
    "targetSdk = flutter.targetSdkVersion": "targetSdk = 36",
    "minSdk = flutter.minSdkVersion": "minSdk = 24",
}

for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"Expected Gradle line not found: {old}")
    text = text.replace(old, new)

path.write_text(text)
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

set_prop org.gradle.jvmargs "-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError"
set_prop android.useAndroidX "true"
set_prop android.enableJetifier "true"
set_prop org.gradle.vfs.watch "false"

grep -q "compileSdk = 36" "$APP_GRADLE"
grep -q "targetSdk = 36" "$APP_GRADLE"
grep -q "minSdk = 24" "$APP_GRADLE"
grep -q "native_media_picker" "$MAIN_ACTIVITY_DIR/MainActivity.kt"

echo "Android configuration verified."
