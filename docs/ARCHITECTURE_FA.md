# معماری مرجع Raha Studio

## لایه‌ها
1. Flutter UI
2. Domain Models
3. Audio Engine Contract
4. Android Native Bridge
5. Speech Engine
6. Cloud AI

## موتور پیشنهادی Android
- Kotlin
- Foreground Service
- WorkManager
- MediaCodec
- FFmpeg Native
- ONNX Runtime Mobile
- Whisper.cpp
- VAD
- DSP برای EQ، Compressor، Hum و Loudness

## اصل معماری
رابط Flutter نباید مستقیم به FFmpeg یا مدل‌ها وابسته باشد. همه پردازش‌ها از طریق `AudioEngine` انجام می‌شوند.
