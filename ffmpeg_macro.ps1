$inputDir = ".\"
$outputDir = ".\"

# 出力フォルダが存在しない場合に作成
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir
}

# .tsファイルを取得
$tsFiles = Get-ChildItem -Path $inputDir -Filter "*.ts"

foreach ($file in $tsFiles) {
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $outputFile = Join-Path $outputDir "$filename.mp4"
    Write-Host "Converting: $file to $outputFile"
    ffmpeg -i $file.FullName -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 192k -map 0 -f mp4 $outputFile
}

Write-Host "Conversion completed!"
pause