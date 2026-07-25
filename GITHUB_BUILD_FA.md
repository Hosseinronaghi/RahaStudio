# ساخت نسخه Android با GitHub

1. در GitHub یک Repository جدید بسازید.
2. ZIP را Extract کنید.
3. محتویات داخل پوشه را در ریشه Repository آپلود کنید.
4. در GitHub وارد تب **Actions** شوید.
5. Workflow با نام **Build Raha Studio Android** را باز کنید.
6. در صورت نیاز **Run workflow** را بزنید.
7. بعد از موفق‌شدن Build، فایل خروجی را از بخش **Artifacts** دانلود کنید.

خروجی‌ها:
- APK عمومی
- APK جداگانه برای معماری‌های Android
- AAB برای Google Play

در ریشه Repository باید این مسیرها دیده شوند:

```text
.github/
lib/
test/
docs/
pubspec.yaml
```

برای انتشار در Google Play باید بعداً Keystore اختصاصی اضافه شود. Keystore را داخل Repository عمومی قرار ندهید.
