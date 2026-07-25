@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK was not found in PATH.
  echo Install Flutter and Android Studio first.
  pause
  exit /b 1
)

if not exist android (
  flutter create . --platforms=android --org com.rahastudio
  if errorlevel 1 goto :error
)

flutter pub get
if errorlevel 1 goto :error

flutter run
exit /b 0

:error
echo Setup or run failed.
pause
exit /b 1
