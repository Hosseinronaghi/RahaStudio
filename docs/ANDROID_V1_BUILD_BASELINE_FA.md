# مبنای Build نسخه 1

| بخش | مقدار |
|---|---|
| Flutter | 3.44.8 |
| Java | 17 |
| compileSdk | 36 |
| targetSdk | 36 |
| minSdk | 24 |
| file_picker | 11.0.2 |
| FFmpegKit | 4.5.3 |
| Android Build | APK + split APK + AAB |

Scaffold اندروید در GitHub Actions با نسخه قفل‌شده Flutter تولید می‌شود و سپس اسکریپت `tool/configure_android.sh` تنظیمات API را اعمال می‌کند.
