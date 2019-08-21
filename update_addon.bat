@ECHO off

SETLOCAL ENABLEDELAYEDEXPANSION

SET "curPath=%1"
SET "mypath=%~dp0"
SET "scriptPath=%mypath:~0,-1%"

rem check for problem
IF "%curPath%" == "" ECHO "There is a problem with the path..." & GOTO End

rem get name
FOR %%a IN (%curPath:\= %) DO SET "name=%%a"

rem check for problem
IF "%name%" == "" ECHO "There is a problem with the name..." & GOTO End

rem getting id from addon_data.cmd file
CALL "%scriptPath%\addon_data.bat"
CALL SET "wsid=%%%name%%%"

rem check for problem
IF "%wsid%" == "" ECHO "Please insert an ID into 'addon_data.bat' for %name% (SET %name%=...)" & GOTO End

CALL SET "typeTmp=%%type_%name%%%"

IF "%typeTmp%" == "" (
	SET "type="ServerContent""
) else (
	SET "type=%typeTmp%" & ECHO "Set type to '%type%'"
)

SET addonJson=%curPath%\addon.json

IF NOT EXIST %addonJson% (
	rem create addon.json
	CALL "%scriptPath%\createAddonJson.bat %addonJson% %name% %type%"
)

IF NOT EXIST %addonJson% ECHO "There is a problem with the creation of the addonJson '%addonJson%'..." & GOTO End

SET "oldDir=%CD%"

rem send some information
ECHO "updating %name% (%curPath%) with id %wsid%..."

SET "gma=%curPath%\%name%.gma"
CD /d "D:\Programme\steamapps\common\GarrysMod\bin"

rem ask for changes input
SET /P changes=Please enter the changes: 

IF EXIST %gma% DEL %gma%

IF EXIST %gma% ECHO "There is a problem with the deletion of the gma '%gma%'..." & GOTO End

rem create .gma file
gmad.exe create -folder %curPath% -out %gma%

SET "icon=%curPath%\%name%.jpg"

rem maybe this isn't allowed, but idc
IF NOT EXIST %icon% SET "icon=%curPath%\%name%.png"

rem upload .gma file
IF EXIST %icon% (
	gmpublish.exe update -addon "%gma%" -id "%wsid%" -changes "!changes!" -icon "%icon%"
) ELSE (
	gmpublish.exe update -addon "%gma%" -id "%wsid%" -changes "!changes!"
)

:End

PAUSE
