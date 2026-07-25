$ErrorActionPreference = "Stop"

$appGradle = "android/app/build.gradle.kts"
$mainActivityDir = "android/app/src/main/kotlin/com/rahastudio/app"
$template = "tool/android_template/MainActivity.kt"
$gradleProperties = "android/gradle.properties"

if (-not (Test-Path $appGradle)) {
  throw "Missing $appGradle. Run flutter create first."
}
if (-not (Test-Path $template)) {
  throw "Missing $template."
}

$content = Get-Content $appGradle -Raw
$required = @{
  "compileSdk = flutter.compileSdkVersion" = "compileSdk = 36"
  "targetSdk = flutter.targetSdkVersion" = "targetSdk = 36"
  "minSdk = flutter.minSdkVersion" = "minSdk = 24"
}

foreach ($entry in $required.GetEnumerator()) {
  if (-not $content.Contains($entry.Key)) {
    throw "Expected Gradle line not found: $($entry.Key)"
  }
  $content = $content.Replace($entry.Key, $entry.Value)
}
Set-Content $appGradle $content -Encoding UTF8

New-Item -ItemType Directory -Force -Path $mainActivityDir | Out-Null
Copy-Item $template "$mainActivityDir/MainActivity.kt" -Force

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

Write-Host "Android configuration verified."
