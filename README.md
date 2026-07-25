# Raha Studio Android v1.0

A GitHub-ready Flutter Android project with a real FFmpeg audio-processing pipeline.

## Android build baseline

- Flutter: `3.44.8`
- Java: `17`
- Android compileSdk: `36`
- Android targetSdk: `36`
- Android minSdk: `24`
- file_picker: `11.0.2`
- ffmpeg_kit_flutter_new: `4.5.3`

## Audio features already implemented

- Decode audio and audio tracks from video
- Encode MP3, WAV, M4A and FLAC
- FFT noise reduction
- Speech EQ
- Compressor
- 50/100/150 Hz hum reduction
- EBU R128 loudness normalization
- Leading/trailing silence trimming
- Progress and cancellation

## Build on GitHub

Upload the repository contents, then open:

**Actions → Build Raha Studio Android v1 → Run workflow**

The workflow produces:

- Universal release APK
- Per-ABI release APKs
- Release AAB
- SHA-256 checksums

See `GITHUB_BUILD_FA.md` for Persian instructions.
