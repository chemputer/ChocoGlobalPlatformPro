#changes the default security protocal to TLS1.2, due to issues with pwsh
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#repo and filename to be targeted
$repo = "martinpaljak/GlobalPlatformPro"
$file = "gp.exe"

$releases = "https://api.github.com/repos/$repo/releases"
#root directory is the directory this script is in
$root = $PSScriptRoot
$build = $root + '\build'
echo $build
del $build\* 
#version is the 18th character (i.e. filename.substring(18) to the 27nd character in the filename of the nupkg. 
#TODO get version from the last built nupkg file, compare against the current version on github, if there is a newer version available, 
#TODO then pack and push a new nupkg to the community feed
Write-Host Determining latest release
# get the tag (version) from the most recent release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
#DEBUG print the location the pwsh script is in
echo $PSScriptRoot
# the download link
$download = "https://github.com/$repo/releases/download/$tag/$file"
#DEBUG print the download link and the version tag
echo $download
echo $tag

#the version in $tag has a v at the beginning, to get just a number, get rid of the first char
$version = $tag.substring(1)


Write-Host Dowloading latest release
# download the gp.exe from the tools directory with the filename gp.exe
Invoke-WebRequest $download -Out $PSScriptRoot\tools\$file
#show files in the tools directory, which is what will be added to the nupkg
ls $PSScriptRoot\tools\
#pack it with the version number, and output the nupkg to the build directory
choco pack --version $version configuration=release --outputdirectory build
#must cd to build directory to push the newly packed nupkg
cd build
#push the nupkg, using the api and location in the global settings
choco push
#choco push --noop 
#return to root directory, useful for debugging in the ISE
cd ..
