# اصلاح نسخه 1.1.0

این نسخه `compileSdk = 36` را برای تمام ماژول‌های Android، از جمله پلاگین‌های Flutter مانند `file_picker`، اجباری می‌کند.

فایل‌های ضروری تغییرکرده:

- `pubspec.yaml`
- `lib/features/import_media/import_media_page.dart`
- `tool/configure_android.sh`
- `.github/workflows/android-build.yml`

این بسته در محیط حاضر Build محلی نشده، چون Flutter SDK و Android SDK نصب نیستند. نتیجه باید در GitHub Actions تأیید شود.
