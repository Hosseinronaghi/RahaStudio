# اصلاح نسخه 1.0.2

خطای Android مربوط به نبودن کلاس زیر برطرف شد:

```text
com.mr.flutter.plugin.filepicker.FilePickerPlugin
```

تغییرات ضروری:

1. `file_picker` از نسخه `11.0.2` به نسخه پایدار `10.3.11` پین شد.
2. API انتخاب فایل به فرم سازگار با نسخه 10 بازگردانده شد:
   `FilePicker.platform.pickFiles(...)`
3. Workflow پیش از `flutter pub get`، فایل‌های قفل و metadata قدیمی را پاک می‌کند.
