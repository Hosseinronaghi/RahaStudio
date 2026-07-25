# اصلاح اجرای برنامه در نسخه 1.3.3

علت نصب‌شدن ولی اجرا نشدن، ناهماهنگی کلاس Launcher بود:

```text
applicationId / namespace: com.rahastudio.app
MainActivity package:      com.rahastudio.raha_studio
```

در نسخه جدید هر سه مقدار یکسان شده‌اند:

```text
applicationId: com.rahastudio.app
namespace:     com.rahastudio.app
MainActivity:  com.rahastudio.app.MainActivity
```

Workflow نیز قبل از Build این هماهنگی را بررسی می‌کند.
