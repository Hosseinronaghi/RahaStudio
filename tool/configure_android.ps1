$ErrorActionPreference = "Stop"

$appGradle = "android/app/build.gradle.kts"
$gradleProperties = "android/gradle.properties"

if (-not (Test-Path $appGradle)) {
  throw "Missing $appGradle. Run flutter create first."
}

$content = Get-Content $appGradle -Raw
$content = $content.Replace(
  "compileSdk = flutter.compileSdkVersion",
  "compileSdk = 36"
)
$content = $content.Replace(
  "targetSdk = flutter.targetSdkVersion",
  "targetSdk = 36"
)
$content = $content.Replace(
  "minSdk = flutter.minSdkVersion",
  "minSdk = 24"
)
Set-Content $appGradle $content -Encoding UTF8

if (-not (Test-Path $gradleProperties)) {
  New-Item $gradleProperties -ItemType File | Out-Null
}

$props = Get-Content $gradleProperties -Raw
$lines = @(
  "org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError",
  "android.useAndroidX=true",
  "android.enableJetifier=true",
  "org.gradle.vfs.watch=false"
)

foreach ($line in $lines) {
  $key = $line.Split("=")[0]
  if ($props -notmatch "(?m)^$([regex]::Escape($key))=") {
    Add-Content $gradleProperties $line
  }
}

Write-Host "Android project configured: compileSdk=36, targetSdk=36, minSdk=24"
