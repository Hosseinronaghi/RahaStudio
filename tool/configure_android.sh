#!/usr/bin/env bash
set -euo pipefail
APP_GRADLE="android/app/build.gradle.kts"
ROOT_GRADLE="android/build.gradle.kts"
GRADLE_PROPERTIES="android/gradle.properties"
[[ -f "$APP_GRADLE" && -f "$ROOT_GRADLE" ]] || { echo "Android scaffold is missing"; exit 1; }
python3 - <<'PYCODE'
from pathlib import Path
app=Path('android/app/build.gradle.kts')
s=app.read_text().replace('compileSdk = flutter.compileSdkVersion','compileSdk = 36').replace('targetSdk = flutter.targetSdkVersion','targetSdk = 36').replace('minSdk = flutter.minSdkVersion','minSdk = 24')
app.write_text(s)
root=Path('android/build.gradle.kts')
s=root.read_text()
marker='// RAHA_FORCE_ANDROID_API_36'
block='''
// RAHA_FORCE_ANDROID_API_36
subprojects {
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.api.dsl.ApplicationExtension> {
            compileSdk = 36
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.api.dsl.LibraryExtension> {
            compileSdk = 36
        }
    }
}
'''
if marker not in s:
    s=s.rstrip()+'\n'+block
root.write_text(s)
PYCODE

touch "$GRADLE_PROPERTIES"
grep -q '^android.useAndroidX=' "$GRADLE_PROPERTIES" || echo 'android.useAndroidX=true' >> "$GRADLE_PROPERTIES"
grep -q '^android.enableJetifier=' "$GRADLE_PROPERTIES" || echo 'android.enableJetifier=true' >> "$GRADLE_PROPERTIES"
grep -q '^org.gradle.vfs.watch=' "$GRADLE_PROPERTIES" || echo 'org.gradle.vfs.watch=false' >> "$GRADLE_PROPERTIES"
echo "Configured all Android modules for compileSdk 36."
