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

SET gma=%curPath%\%name%.gma

IF EXIST %gma% ECHO "Found gma '%gma%'... Maybe this addon is uploaded already?" & GOTO End

SET icon=%curPath%\%name%.jpg

rem maybe this isn't allowed, but idc
IF NOT EXIST %icon% SET icon=%curPath%\%name%.png

rem upload .gma file
IF NOT EXIST %icon% ECHO "Couldn't upload addon '%name%' because of missing ws-icon!" & GOTO End

SET addonJson=%curPath%\addon.json

rem addon json asking snippet by https://github.com/EstevanTH/GMod-Easy-Addon-Uploader/blob/master/Upload.cmd
IF NOT EXIST %addonJson% (
	SET /P title="Please enter the title of the addon (no accents). Default will be '%name%':"
	
	SET title=+!title!
	SET title=!title:"='!
	SET title=!title:~1!
	
	rem fallback
	IF [!title!] == [] SET title=%name%
	
	ECHO.
	ECHO List of allowed types:
	ECHO - effects
	ECHO - gamemode
	ECHO - map
	ECHO - model
	ECHO - npc
	ECHO - ServerContent
	ECHO - tool
	ECHO - vehicle
	ECHO - weapon
	
	SET /P type="Please enter the type of the addon (case-sensitive). Default will be 'ServerContent':"
	
	SET type=+!type!
	SET type=!type:"=!
	SET type=!type:~1!
	
	rem fallback
	IF [!type!] == [] SET type=ServerContent
	
	ECHO.
	ECHO List of allowed tags:
	ECHO - build
	ECHO - cartoon
	ECHO - comic
	ECHO - fun
	ECHO - movie
	ECHO - realism
	ECHO - roleplay
	ECHO - scenic
	ECHO - water
	
	SET /P tag1="Please enter the tag 1 of 2 of the addon (optional, case-sensitive):"
	
	SET tag1=+!tag1!
	SET tag1=!tag1:"=!
	SET tag1=!tag1:~1!
	SET tag2=
	
	IF NOT [!tag1!] == [] (
		SET /P tag2="Please enter the tag 2 of 2 of the addon (optional, case-sensitive):"
		
		SET tag2=+!tag2!
		SET tag2=!tag2:"=!
		SET tag2=!tag2:~1!
		
		IF [!tag2!] == [] (
			SET tags="!tag1!"
		) ELSE (
			SET tags="!tag1!","!tag2!"
		)
	) ELSE (
		SET tags=
	)

	rem create addon.json
	CALL %scriptPath%\createAddonJson.bat %addonJson% %name% "!title!" "!type!" "[!tags!]"
)

IF NOT EXIST %addonJson% ECHO "There is a problem with the creation of the addonJson '%addonJson%'..." & GOTO End

SET oldDir=%CD%

rem send some information
ECHO "uploading %name% (%curPath%)"

CD /d D:\Programme\steamapps\common\GarrysMod\bin

rem create .gma file
gmad.exe create -folder %curPath% -out %gma%

SET tmpFile=%scriptPath%\temp.txt

gmpublish.exe create -addon "%gma%" -icon "%icon%" > %tmpFile%

IF NOT EXIST %tmpFile% ECHO "Couldn't create file '%tmpFile%'!" & GOTO End

rem fetch / parse ws-UID
FOR /f "tokens=*" %%A IN (%tmpFile%) DO (
	SET strTmp=%%A

	ECHO "%%A"| findstr /b /r ".UID" > NUL && (
		SET str="%%A"
		SET mUID=!str:~6,-1!
		
		ECHO SET %name%=!mUID! >> %scriptPath%\addon_data.bat
		
		DEL %tmpFile%
	)
)

:End

PAUSE
