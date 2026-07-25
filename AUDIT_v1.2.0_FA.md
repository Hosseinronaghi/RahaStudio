# گزارش بازبینی نسخه 1.2.0

## ایراد قطعی رفع‌شده

پکیج `file_picker` از کل پروژه حذف شد. بنابراین Flutter دیگر نباید این کلاس را
در `GeneratedPluginRegistrant.java` ثبت کند:

```text
com.mr.flutter.plugin.filepicker.FilePickerPlugin
```

## جایگزین

- Dart: `lib/services/native_media_picker.dart`
- Android: `tool/android_template/MainActivity.kt`
- ارتباط: `MethodChannel`
- Picker: `Intent.ACTION_OPEN_DOCUMENT`
- خروجی: فایل کپی‌شده در `cacheDir/raha_imports`

## بازبینی CI

- Scaffold با `--no-pub` ساخته می‌شود.
- SDK 36 پیش از Build نصب می‌شود.
- compileSdk/targetSdk/minSdk به شکل fail-fast بررسی می‌شوند.
- وابستگی‌ها دقیقاً pin شده‌اند.
- Analyze و Test قبل از Build اجرا می‌شوند.
- در صورت شکست، فایل‌های تشخیصی به‌صورت Artifact ذخیره می‌شوند.

## محدودیت صداقت

این بسته در محیط حاضر با Flutter/Android SDK محلی Build نشده است. بنابراین
نمی‌توان Build موفق را پیش از نتیجه GitHub Actions تضمین کرد. با این حال،
علت خطای تکرارشونده `file_picker` به‌صورت ساختاری حذف شده، نه اینکه با تغییر
نسخه دور زده شود.
