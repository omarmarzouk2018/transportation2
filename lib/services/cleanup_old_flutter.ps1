# Navigate to project root before running
Write-Host "🚀 Cleaning old Flutter Android V1 embedding files..."

$patterns = @(
    "android\app\src\main\java\**\MainActivity.java",
    "android\app\src\main\java\**\FlutterApplication.java",
    "android\app\src\main\java\**\GeneratedPluginRegistrant.java",
    "android\app\src\main\java\io\flutter\plugins\*",
    "*.iml"
)

foreach ($pattern in $patterns) {
    Get-ChildItem -Path $pattern -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "🗑 Deleting $($_.FullName)"
        Remove-Item $_.FullName -Force -Recurse
    }
}

Write-Host "✅ Cleanup finished. Now run:"
Write-Host "   flutter clean"
Write-Host "   flutter pub get"
Write-Host "   flutter run -d <device-id>"
