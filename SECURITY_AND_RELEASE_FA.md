# امنیت، هشدار آنتی‌ویروس و انتشار

هشدار Norton به‌تنهایی اثبات بدافزار بودن برنامه نیست. APKهای تازه، سایدلودشده و
دارای امضای Debug معمولاً اعتبار ناشر و سابقه نصب ندارند.

نسخه 1.3 این موارد را اصلاح می‌کند:

- شناسه ثابت برنامه: `com.rahastudio.app`
- نام رسمی: `Raha Studio`
- حذف کامل مجوز اینترنت
- حذف مجوزهای عمومی حافظه
- غیرفعال‌کردن Cleartext HTTP
- غیرفعال‌کردن Backup
- استفاده از Storage Access Framework برای ورودی
- استفاده از MediaStore برای خروجی
- بررسی امضای APK و تولید گزارش SHA-256

## چهار Secret لازم برای امضای انتشار

در GitHub Repository > Settings > Secrets and variables > Actions:

- `RAHA_KEYSTORE_BASE64`
- `RAHA_STORE_PASSWORD`
- `RAHA_KEY_ALIAS`
- `RAHA_KEY_PASSWORD`

بدون این Secretها، Workflow برای تست همچنان APK می‌سازد، اما آن APK با کلید Debug
امضا می‌شود و احتمال هشدار reputation-based بیشتر است.

هیچ کدی نمی‌تواند تضمین کند تمام محصولات امنیتی هرگز هشدار ندهند. راه استاندارد کاهش
هشدار، امضای ثابت، انتشار از فروشگاه معتبر، حفظ شناسه بسته و ایجاد سابقه سالم است.
