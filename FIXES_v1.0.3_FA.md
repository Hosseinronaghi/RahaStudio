# اصلاح نسخه 1.0.3

نسخه `10.3.11` برای پکیج `file_picker` منتشر نشده بود و باعث شکست dependency resolution می‌شد.

تغییرات:

- `file_picker: 9.2.3`
- استفاده از `FilePicker.platform.pickFiles(...)`
- افزودن `--no-pub` به دستور `flutter create` تا ساخت Scaffold پیش از اجرای `flutter pub get` انجام شود.
