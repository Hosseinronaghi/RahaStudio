# Raha Studio Android v1.2

Android-first Flutter audio-cleaning reference application.

## Build baseline

- Flutter 3.44.8
- Java 17
- Android compileSdk 36
- Android targetSdk 36
- Android minSdk 24
- FFmpeg Kit Flutter New 4.5.3

## Important stability change

The `file_picker` plugin has been removed completely. File selection now uses
Android's native `ACTION_OPEN_DOCUMENT` through a small MethodChannel in
`MainActivity.kt`. The selected content is copied into the app cache and a real
local path is returned to FFmpeg.

This removes both previous failure classes:

- missing `FilePickerPlugin` during Java compilation
- `file_picker` module compiled against an older Android API

## GitHub build

Open **Actions → Build Raha Studio Android v1.2 → Run workflow**.

Successful runs upload universal APK, split APKs, AAB, and checksums.
Failed runs upload Android configuration diagnostics.
