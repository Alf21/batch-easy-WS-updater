@echo off

SET file=%1
SET name=%2
SET title=%3
SET type=%4
SET tags=%5

SET tags=%tags:~1,-1%

@echo {> %file%
@echo 	"title"		:	%title%,>> %file%
@echo 	"type"		:	%type%,>> %file%
@echo 	"tags"		:	%tags%,>> %file%
@echo 	"ignore"	:>> %file%
@echo 	[>> %file%
@echo 		"*.psd",>> %file%
@echo 		"*.vcproj",>> %file%
@echo 		"*.svn*",>> %file%
@echo 		"*.git*",>> %file%
@echo 		"*.md",>> %file%
@echo 		".ftpconfig",>> %file%
@echo 		"todo.txt",>> %file%
@echo 		"*.gma",>> %file%
@echo 		"license",>> %file%
@echo 		"%name%.png",>> %file%
@echo 		"%name%.jpg">> %file%
@echo 	]>> %file%
@echo }>> %file%