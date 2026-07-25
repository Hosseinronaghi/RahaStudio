# اصلاح نسخه 1.2.1

خطای `PlatformException` برطرف شد.

در فایل زیر:

`lib/features/import_media/import_media_page.dart`

این import اضافه شد:

```dart
import 'package:flutter/services.dart';
```

همچنین نسخه برنامه به `1.2.1+31` افزایش یافت.
