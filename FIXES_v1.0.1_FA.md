# اصلاح نسخه 1.0.1

خطای `flutter analyze --fatal-infos` برطرف شد.

در `file_picker 11.x` متد انتخاب فایل به‌صورت مستقیم روی کلاس `FilePicker` فراخوانی می‌شود:

```dart
final result = await FilePicker.pickFiles(...);
```

فراخوانی قدیمی زیر حذف شد:

```dart
FilePicker.platform.pickFiles(...)
```
