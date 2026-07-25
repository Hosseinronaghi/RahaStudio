import 'package:flutter/material.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get isPersian => locale.languageCode == 'fa';

  static const supportedLocales = <Locale>[
    Locale('fa'),
    Locale('en'),
  ];

  static AppStrings of(BuildContext context) {
    return AppStrings(Localizations.localeOf(context));
  }

  String _value(String fa, String en) => isPersian ? fa : en;

  String get appName => 'Raha Studio';
  String get privateAudioStudio =>
      _value('استودیوی خصوصی صدا', 'Your private audio studio');
  String get homeHeadline =>
      _value('صدای تمیز، خروجی حرفه‌ای', 'Clean audio. Professional output.');
  String get homeSubtitle => _value(
        'فایل را وارد کن، پردازش را تنظیم کن و خروجی را مستقیم در موسیقی یا دانلود ذخیره کن.',
        'Import a file, tune processing, and save directly to Music or Downloads.',
      );
  String get newProject => _value('پروژه جدید', 'New project');
  String get cleanAudio => _value('پاک‌سازی صدا', 'Clean audio');
  String get cleanAudioSubtitle =>
      _value('نویز، هوم، سکوت و بلندی صدا', 'Noise, hum, silence, and loudness');
  String get projects => _value('پروژه‌ها', 'Projects');
  String get projectsSubtitle =>
      _value('فایل‌ها و خروجی‌های اخیر', 'Recent files and exports');
  String get export => _value('خروجی', 'Export');
  String get exportSubtitle =>
      _value('MP3، WAV، M4A و FLAC', 'MP3, WAV, M4A, and FLAC');
  String get settings => _value('تنظیمات', 'Settings');
  String get settingsSubtitle =>
      _value('زبان، ظاهر، کیفیت و محل ذخیره', 'Language, appearance, quality, and storage');
  String get importFile => _value('وارد کردن فایل', 'Import file');
  String get chooseMedia =>
      _value('فایل صوتی یا ویدئویی را انتخاب کنید', 'Choose an audio or video file');
  String get chooseMediaHint => _value(
        'فایل فقط برای پردازش در حافظه موقت برنامه کپی می‌شود.',
        'The file is copied only to the app cache for processing.',
      );
  String get continueLabel => _value('ادامه', 'Continue');
  String get noFile => _value('فایلی انتخاب نشده', 'No file selected');
  String get audioEngine => _value('استودیوی پردازش', 'Processing studio');
  String get preset => _value('پیش‌تنظیم', 'Preset');
  String get outputFormat => _value('فرمت خروجی', 'Output format');
  String get backgroundNoise =>
      _value('حذف نویز پس‌زمینه', 'Background noise reduction');
  String get backgroundNoiseSubtitle => _value(
        'کاهش هیس، فن و نویز یکنواخت محیط',
        'Reduce hiss, fan noise, and steady ambience',
      );
  String get intensity => _value('شدت', 'Strength');
  String get studioSound => _value('صدای استودیویی', 'Studio sound');
  String get studioSoundSubtitle =>
      _value('EQ گفتار و کمپرس دینامیکی', 'Speech EQ and dynamic compression');
  String get removeHum => _value('حذف هوم برق', 'Remove electrical hum');
  String get removeHumSubtitle =>
      _value('فیلتر ۵۰، ۱۰۰ و ۱۵۰ هرتز', '50, 100, and 150 Hz filters');
  String get trimSilence =>
      _value('کاهش سکوت ابتدا و انتها', 'Trim leading and trailing silence');
  String get trimSilenceSubtitle =>
      _value('حذف محافظه‌کارانه سکوت‌های طولانی', 'Conservative trimming of long silence');
  String get loudness =>
      _value('یکسان‌سازی بلندی صدا', 'Loudness normalization');
  String get loudnessSubtitle =>
      _value('هدف استاندارد گفتار و پادکست', 'Speech and podcast loudness target');
  String get aiLater => _value('به‌زودی', 'Coming later');
  String get aiFeatures =>
      _value('تنفس، صدای دهان و کلمات پرکننده', 'Breaths, mouth sounds, and filler words');
  String get startProcessing =>
      _value('شروع پردازش و ذخیره خروجی', 'Process and save output');
  String get stopProcessing => _value('توقف پردازش', 'Stop processing');
  String get ready => _value('آماده', 'Ready');
  String get preparing => _value('در حال آماده‌سازی', 'Preparing');
  String get outputReady => _value('خروجی آماده شد', 'Output is ready');
  String get error => _value('خطا', 'Error');
  String get processingError =>
      _value('خطا در پردازش', 'Processing error');
  String get close => _value('بستن', 'Close');
  String get selectValidFile => _value(
        'ابتدا یک فایل معتبر وارد کنید.',
        'Import a valid file first.',
      );
  String get savedTo => _value('ذخیره شد در', 'Saved to');
  String get noProjects =>
      _value('هنوز پروژه‌ای ساخته نشده است.', 'No projects yet.');
  String get language => _value('زبان', 'Language');
  String get persian => _value('فارسی', 'Persian');
  String get english => _value('انگلیسی', 'English');
  String get appearance => _value('ظاهر', 'Appearance');
  String get systemTheme => _value('مطابق سیستم', 'System');
  String get lightTheme => _value('روشن', 'Light');
  String get darkTheme => _value('تیره', 'Dark');
  String get saveLocation => _value('محل ذخیره خروجی', 'Output location');
  String get musicFolder => _value('پوشه موسیقی', 'Music folder');
  String get downloadsFolder => _value('پوشه دانلود', 'Downloads folder');
  String get defaultQuality => _value('کیفیت پیش‌فرض', 'Default quality');
  String get standardQuality => _value('استاندارد', 'Standard');
  String get highQuality => _value('بالا', 'High');
  String get privacy => _value('حریم خصوصی و امنیت', 'Privacy and security');
  String get privacyDetails => _value(
        'بدون دسترسی اینترنت، بدون مجوز عمومی حافظه و بدون جمع‌آوری اطلاعات.',
        'No internet access, no broad storage permission, and no data collection.',
      );
  String get signingWarning => _value(
        'برای انتشار عمومی، APK باید با کلید انتشار ثابت امضا شود.',
        'Public releases must be signed with a stable release key.',
      );
  String get natural => _value('طبیعی', 'Natural');
  String get studio => _value('استودیو', 'Studio');
  String get voiceOnly => _value('فقط صدا', 'Voice only');
  String get broadcast => _value('پخش', 'Broadcast');
  String get archive => _value('آرشیو', 'Archive');
  String get decodeStage => _value('تحلیل و رمزگشایی', 'Decode and analysis');
  String get denoiseStage => _value('حذف نویز و تنظیم EQ', 'Denoise and EQ');
  String get dynamicsStage => _value('کمپرس و بلندی صدا', 'Compression and loudness');
  String get encodeStage => _value('ساخت و ذخیره خروجی', 'Encode and save');
}

extension AppStringsContext on BuildContext {
  AppStrings get l10n => AppStrings.of(this);
}
