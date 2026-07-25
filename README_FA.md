# Raha Studio Android v0.2 — موتور صوت واقعی

این نسخه، موتور صوت را از حالت Mock خارج می‌کند و از FFmpeg واقعی روی Android استفاده می‌کند.

## قابلیت‌های پیاده‌سازی‌شده

- Decode فایل صوتی یا Track صوتی ویدئو
- Encode و ساخت خروجی MP3، WAV، M4A و FLAC
- حذف نویز با فیلتر FFT (`afftdn`)
- EQ مخصوص گفتار
- High-pass و Low-pass متناسب با Preset
- Compressor
- حذف Hum در 50/100/150 هرتز
- Loudness Normalization روی -16 LUFS
- حذف محافظه‌کارانه سکوت ابتدا و انتها
- پنج Preset
- نمایش Progress و امکان Cancel
- ذخیره خروجی در Documents خصوصی اپ

## نکته فنی و مجوز

پروژه از `ffmpeg_kit_flutter_new` استفاده می‌کند. بسته Full شامل اجزای GPL است؛ پیش از انتشار تجاری، الزامات GPL و مجوزهای FFmpeg را بررسی کنید. برای اپ فقط صوتی می‌توان در ادامه بسته Audio با مجوز مناسب‌تر را جایگزین کرد.

## اجرای پروژه

ابتدا Flutter SDK و Android Studio را نصب کنید. سپس در ریشه پروژه:

```bash
flutter create . --platforms=android --org com.rahastudio
flutter pub get
flutter run
```

دستور `flutter create .` فقط Scaffold استاندارد Android را می‌سازد و فایل‌های `lib` و `pubspec.yaml` این پروژه را نگه می‌دارد.

## ساخت APK

```bash
flutter build apk --release
```

خروجی معمولاً در مسیر زیر است:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## محدودیت‌های این فاز

- فیلتر نویز فعلی DSP/FFT است، نه مدل DeepFilterNet.
- Mouth Click، Breath، Filler Words، Stutter، De-Reverb و Voice Isolation هنوز مدل AI واقعی ندارند.
- Progress بر اساس Statistics پردازش تخمین زده می‌شود؛ برای درصد کاملاً دقیق، در فاز بعد مدت فایل با FFprobe خوانده می‌شود.
- این محیط فاقد Flutter/Android SDK بود؛ بنابراین سورس آماده شده اما APK در همین محیط Build و روی دستگاه واقعی تست نشده است.
