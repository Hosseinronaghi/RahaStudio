# راهنمای ساخت Raha Studio Android v1 روی GitHub

## جایگزینی نسخه قبلی

ZIP را Extract کنید و تمام فایل‌های داخل آن را در ریشه Repository قبلی آپلود و Replace کنید.

در ریشه مخزن باید این موارد دیده شوند:

```text
.github/
lib/
test/
tool/
docs/
pubspec.yaml
README.md
```

Commit پیشنهادی:

```text
Upgrade Raha Studio to Android v1 SDK 36
```

## اجرای Build

1. وارد تب **Actions** شوید.
2. Workflow با نام **Build Raha Studio Android v1** را باز کنید.
3. روی **Run workflow** بزنید.
4. پس از سبز شدن Workflow، پایین صفحه بخش **Artifacts** را باز کنید.
5. فایل `Raha-Studio-Android-v1-...` را دانلود کنید.

داخل Artifact این فایل‌ها قرار می‌گیرند:

- APK عمومی
- APK برای ARM64
- APK برای ARMv7
- APK برای x86_64
- AAB برای Google Play
- فایل SHA256SUMS

## اصلاحات سازگاری

این نسخه:

- Flutter را روی 3.44.8 قفل می‌کند.
- Android SDK 36 را نصب می‌کند.
- `compileSdk` و `targetSdk` را روی 36 می‌گذارد.
- `minSdk` را روی 24 قرار می‌دهد.
- `file_picker` را به 11.0.2 ارتقا می‌دهد.
- `ffmpeg_kit_flutter_new` را روی 4.5.3 نگه می‌دارد.
- Gradle file watching را در Runner خاموش می‌کند تا خطای `Already watching path` رخ ندهد.

## امضای انتشار

خروجی فعلی برای تست و توزیع داخلی ساخته می‌شود. برای انتشار رسمی Google Play باید Upload Keystore اختصاصی و GitHub Secrets اضافه شوند.
