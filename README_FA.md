# Raha Studio Android v1.2

در این نسخه پکیج `file_picker` به‌طور کامل حذف شده است.

انتخاب فایل با File Picker بومی Android و `ACTION_OPEN_DOCUMENT` انجام می‌شود.
فایل انتخاب‌شده داخل Cache برنامه کپی می‌شود و مسیر محلی واقعی به موتور FFmpeg
داده می‌شود.

این تغییر دو خطای قبلی را حذف می‌کند:

- نبودن کلاس `FilePickerPlugin`
- کامپایل‌شدن ماژول `file_picker` با Android API قدیمی‌تر

## اجرای Build

1. همه فایل‌های ZIP را روی مخزن قبلی Replace کنید.
2. Commit بزنید.
3. وارد Actions شوید.
4. Workflow با نام `Build Raha Studio Android v1.2` را اجرا کنید.

در صورت شکست Build، Workflow یک Artifact تشخیصی نیز ایجاد می‌کند.
