# اصلاح نسخه 1.3.1

خطای `const_with_non_const` در فایل زیر برطرف شد:

`lib/services/native_media_store.dart`

تغییر:

```dart
throw const PlatformException(
```

به:

```dart
throw PlatformException(
```

همچنین نسخه برنامه به `1.3.1+41` افزایش یافت.
