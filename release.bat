@echo off
rem msbuild Tera.sln /t:rebuild /p:Configuration=Release /p:Platform="Any CPU" /fl /flp:logfile=ShinraMeter.log;verbosity=diagnostic
rem msbuild Tera.sln /p:Configuration=Release /p:Platform="Any CPU" /fl /flp:logfile=ShinraMeter.log;verbosity=normal
msbuild DamageMeter.UI/DamageMeter.UI.csproj /t:publish /p:Configuration=Release,TargetFramework=net5-windows,RuntimeIdentifer=win-x64 /p:PublishProfile=FolderProfile 
msbuild Publisher/Publisher.csproj /t:build /p:Configuration=Release,TargetFramework=net5-windows,RuntimeIdentifer=win-x64
msbuild DamageMeter.AutoUpdate/DamageMeter.AutoUpdate.csproj /t:build /p:Configuration=Release,TargetFramework=net471,RuntimeIdentifer=win-x64

set output=.\ShinraMeterV
set tb-output=.\toolbox-output
set source=.
set variant=Release\publish
rmdir /Q /S "%output%"
rmdir /Q /S "%tb-output%"
md "%output%
md "%tb-output%
md "%output%\resources"
md "%output%\resources\config"
md "%output%\lib"

xcopy "%source%\DamageMeter.UI\bin\%variant%" "%output%\" /E
copy "%source%\DamageMeter.AutoUpdate\bin\Release\net471\Autoupdate.exe" "%output%\Autoupdate.exe"
xcopy "%source%\lib" "%output%\lib\" /E
copy "%source%\ReadmeUser.txt" "%output%\readme.txt"
copy "%source%\add_firewall_exception.bat" "%output%\add_firewall_exception.bat"
xcopy "%source%\resources" "%output%\resources\" /E /EXCLUDE:.\exclude.txt
xcopy "%source%\DamageMeter.Sniffing\shinra-interface" "%output%\" /y /s
copy "%source%\.git\modules\resources\data\refs\heads\master" "%output%\resources\head"
del "%output%\*.xml"
del "%output%\error.log"
del "%output%\*.vshost*"
del "%output%\*.pdb"
del "%output%\resources\data\hotdot\glyph*.tsv"
del "%output%\resources\data\hotdot\abnormal.tsv"
node ".\manifest-generator.js" "%output%"
xcopy "%output%" "%tb-output%" /y /s
"%source%\Publisher\bin\release\net5-windows\Publisher.exe"
