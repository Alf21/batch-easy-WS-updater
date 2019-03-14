@echo off
set file=%1
set title=%2
set type=%3
@echo {> %file%
@echo 	"title"		:	"%title%",>> %file%
@echo 	"type"		:	%type%,>> %file%
@echo 	"tags"		:	[ "roleplay", "scenic" ],>> %file%
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
@echo 		"license">> %file%
@echo 	]>> %file%
@echo }>> %file%