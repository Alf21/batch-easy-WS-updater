@ECHO off & setlocal
SET path=%1

rem check for problem
IF [%path%] == [] ECHO "There is a problem with the path..." & PAUSE & GOTO End

rem get name
FOR %%a IN (%path:\= %) DO SET name=%%a

rem check for problem
IF [%name%] == [] ECHO "There is a problem with the name..." & PAUSE & GOTO End

rem getting id from addon_data.cmd file
CALL addon_data.bat
CALL SET id=%%%name%%%

rem check for problem
IF [%id%] == [] ECHO "Please insert an ID into 'addon_data.bat' for %name% (SET %name%=...)" & PAUSE & GOTO End

SET type="ServerContent"

SET typeTmp=%%type_%name%%%
IF NOT [%typeTmp%] == [] SET type=typeTmp & ECHO "Set type to '%type%'"

rem create addon.json
CALL createAddonJson.bat %path%\addon.json %name% %type%

SET oldDir=%CD%

rem send some information
ECHO "updating %name% (%path%) with id %id%..."

SET gma=%path%\%name%.gma
cd /d D:\Programme\steamapps\common\GarrysMod\bin

rem ask for changes input
SET/P changes=Please enter the changes: 

IF EXIST %gma% DEL %gma%

IF EXIST %gma% ECHO "There is a problem with the deletion of the gma '%gma%'..." & PAUSE & GOTO End

rem create .gma file
gmad.exe create -folder %path% -out %gma%

SET icon=%oldDir%\ws_icons\%name%.jpg

rem upload .gma file
IF EXIST %icon% (
gmpublish.exe update -addon "%gma%" -id "%id%" -changes "%changes%" -icon "%icon%"
) ELSE (
gmpublish.exe update -addon "%gma%" -id "%id%" -changes "%changes%"
)

:End

PAUSE
