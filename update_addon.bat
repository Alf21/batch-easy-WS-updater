@echo off & setlocal
set path=%1

rem check for problem
if [%path%] == [] echo "There is a problem with the path..." & pause & exit

rem get name
for %%a in (%path:\= %) do set name=%%a

rem check for problem
if [%name%] == [] echo "There is a problem with the name..." & pause & exit

rem create addon.json
call createAddonJson.bat %path%\addon.json %name%

rem getting id from addon_data.cmd file
call addon_data.bat
call set id=%%%name%%%

rem check for problem
if [%id%] == [] echo Please insert an ID into "addon_data.bat" for %name% (set %name%=...) & pause & exit

rem send some information
echo "updating %name% (%path%) with id %id%..."

set gma=%path%\%name%.gma
cd /d G:\Steam\steamapps\common\GarrysMod\bin

rem ask for changes input
SET/P changes=Please enter the changes: 

rem create .gma file
gmad.exe create -folder %path% -out %gma%

rem upload .gma file
gmpublish.exe update -addon %gma% -id %id% -changes "%changes%"

pause