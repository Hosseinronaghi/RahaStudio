# موتور صوت v0.2

## زنجیره پردازش

1. Decode ورودی توسط FFmpeg
2. High-pass / Low-pass
3. حذف Hum
4. FFT Denoise
5. EQ گفتار
6. Compressor
7. Silence Removal ابتدا و انتها
8. Loudness Normalization
9. Resample به 48 kHz
10. Encode به فرمت انتخابی

## فیلترها

- `afftdn`: حذف نویز طیفی
- `equalizer`: گرمی و Presence گفتار و حذف Hum
- `acompressor`: کنترل دامنه دینامیکی
- `silenceremove`: حذف سکوت لبه‌های فایل
- `loudnorm`: استانداردسازی EBU R128

## فرمت‌ها

- MP3: libmp3lame، 192 kbps
- WAV: PCM 24-bit
- M4A: AAC، 192 kbps
- FLAC: Lossless، compression level 8
