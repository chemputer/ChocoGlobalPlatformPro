[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$repo = "martinpaljak/GlobalPlatformPro"
$file = "gp.exe"

$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Determining latest release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
echo $PSScriptRoot
$download = "https://github.com/$repo/releases/download/$tag/$file"
echo $download
echo $tag
$version = $tag.substring(1)


Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $PSScriptRoot\tools\$file
ls $PSScriptRoot\tools\
choco pack --version $version configuration=release --outputdirectory build
