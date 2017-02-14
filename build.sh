#!/bin/bash
repoFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $repoFolder

NUGET_VERSION=latest
CACHED_NUGET="./.nuget/Nuget.exe"
nugetExe="https://dist.nuget.org/win-x86-commandline/$NUGET_VERSION/nuget.exe"

if [ ! -e "$CACHED_NUGET" ]
then
    echo "Downloading latest version of NuGet.exe..."

    if [ ! -d "./.nuget" ]
    then
        mkdir ".nuget"
    fi

    wget -O $CACHED_NUGET $nugetExe
fi

sakeFolder="./packages"
if [ ! -d $sakeFolder ] 
then
    toolsProject="./project.json"
    dotnet restore "$toolsProject" --packages "$repoFolder/packages" -v Minimal
    # Rename the project after restore because we don't want it to be restore afterwards
    # mv "$toolsProject" "$toolsProject.norestore"
fi

mono "packages/Sake/0.2.2/tools/Sake.exe" -I "packages/Sake/0.2.2/tools/Shared" "$@"
