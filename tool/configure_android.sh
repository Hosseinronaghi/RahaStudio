#!/usr/bin/env bash
set -euo pipefail

APP_GRADLE="android/app/build.gradle.kts"
GRADLE_PROPERTIES="android/gradle.properties"

if [[ ! -f "$APP_GRADLE" ]]; then
  echo "Missing $APP_GRADLE. Run flutter create first."
  exit 1
fi

python3 - <<'PY'
from pathlib import Path
p = Path("android/app/build.gradle.kts")
s = p.read_text()

s = s.replace(
    "compileSdk = flutter.compileSdkVersion",
    "compileSdk = 36",
)
s = s.replace(
    "targetSdk = flutter.targetSdkVersion",
    "targetSdk = 36",
)
s = s.replace(
    "minSdk = flutter.minSdkVersion",
    "minSdk = 24",
)

# FFmpegKit supports min Android API 24.
if "ndkVersion = flutter.ndkVersion" not in s and "android {" in s:
    pass

p.write_text(s)
PY

touch "$GRADLE_PROPERTIES"

grep -q '^org.gradle.jvmargs=' "$GRADLE_PROPERTIES" || \
  echo 'org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError' >> "$GRADLE_PROPERTIES"

grep -q '^android.useAndroidX=' "$GRADLE_PROPERTIES" || \
  echo 'android.useAndroidX=true' >> "$GRADLE_PROPERTIES"

grep -q '^android.enableJetifier=' "$GRADLE_PROPERTIES" || \
  echo 'android.enableJetifier=true' >> "$GRADLE_PROPERTIES"

# Avoid the "Already watching path" failure seen on some hosted Gradle runners.
grep -q '^org.gradle.vfs.watch=' "$GRADLE_PROPERTIES" || \
  echo 'org.gradle.vfs.watch=false' >> "$GRADLE_PROPERTIES"

echo "Android project configured: compileSdk=36, targetSdk=36, minSdk=24"
