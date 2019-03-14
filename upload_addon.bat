@ECHO off

SETLOCAL ENABLEDELAYEDEXPANSION

SET curPath=%1
SET mypath=%~dp0
SET scriptPath=%mypath:~0,-1%

rem check for problem
IF [%curPath%] == [] ECHO "There is a problem with the path..." & GOTO End

rem get name
FOR %%a IN (%curPath:\= %) DO SET name=%%a

rem check for problem
IF [%name%] == [] ECHO "There is a problem with the name..." & GOTO End

rem getting id from addon_data.cmd file
CALL %scriptPath%\addon_data.bat
CALL SET wsid=%%%name%%%

rem check for problem
IF NOT [%wsid%] == [] ECHO "Already uploaded '%name%'!" & GOTO End

CALL SET typeTmp=%%type_%name%%%

IF [%typeTmp%] == [] (
	SET type="ServerContent"
) else (
	SET type=%typeTmp% & ECHO "Set type to '%type%'"
)

SET addonJson=%curPath%\addon.json

IF EXIST %addonJson% DEL %addonJson%

IF EXIST %addonJson% ECHO "There is a problem with the deletion of the addonJson '%addonJson%'..." & GOTO End

rem create addon.json
CALL %scriptPath%\createAddonJson.bat %addonJson% %name% %type%

SET oldDir=%CD%

rem send some information
ECHO "uploading %name% (%curPath%)"

SET gma=%curPath%\%name%.gma

CD /d D:\Programme\steamapps\common\GarrysMod\bin

IF EXIST %gma% ECHO "Found gma '%gma%'... Maybe this addon is uploaded already?" & GOTO End

rem create .gma file
gmad.exe create -folder %curPath% -out %gma%

SET icon=%oldDir%\ws_icons\%name%.jpg

rem upload .gma file
IF NOT EXIST %icon% ECHO "Couldn't upload addon '%name%' because of missing ws-icon!" & GOTO End

SET tmpFile=%scriptPath%\temp.txt

gmpublish.exe create -addon "%gma%" -icon "%icon%" > %tmpFile%

IF NOT EXIST %tmpFile% ECHO "Couldn't create file '%tmpFile%'!" & GOTO End

rem fetch / parse ws-UID
FOR /f "tokens=*" %%A IN (%tmpFile%) DO (
	SET strTmp=%%A

	ECHO "%%A"| findstr /b /r ".UID" > NUL && (
		SET str="%%A"
		SET mUID=!str:~6,-1!
		
		ECHO set %name%=!mUID! >> %scriptPath%\addon_data.bat
		
		DEL %tmpFile%
	)
)

:End

PAUSE
