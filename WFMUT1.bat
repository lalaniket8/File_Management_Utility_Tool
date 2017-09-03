:startprog

@echo off
setlocal EnableDelayedExpansion

set "dash=\"
set UserDesktop=%UserProfile%\Desktop

set /p var=Enter path of SOURCE folder(append with \):
set "varSource=%var%%dash%"
echo %varSource%

set /p var2=Enter path of DESTINATION folder(append with \):
set "varDest=%var2%%dash%"
echo %varDest%

set /p type=Set target file type(*,bmp,docx,jpg,etc):
rem set "type=txt"
echo %type%
set /p name=Set target file name(* for any file or file name):
rem set "name=*"
echo %name%
set /p op=Select opertaion(enter "del" or "copy" or "move" or "inf" or "seg" or "hide" or "show":
rem set "op=show"
echo %op%

pause

IF "%op%"=="copy" (goto labelcopy)
IF "%op%"=="del" (goto labeldel)
IF "%op%"=="move" (goto labelmove)
IF "%op%"=="inf" (goto labelinf)
IF "%op%"=="seg" (goto labelseg)
IF "%op%"=="hide" (goto labelhide)
IF "%op%"=="show" (goto labelshow)
echo INCORRECT
goto exitprog

:labelcopy
ECHO copying files...
  For /R %varSource% %%G IN (%name%.%type%) do (
	echo "%%G" 
	copy "%%G" "%varDest%"
  )
goto exitprog

:labeldel
ECHO deleting files...
For /R %varSource% %%G IN (%name%.%type%) do (
	echo "%%G" 
	del /F /Q "%%G" "%varDest%"
)
goto exitprog

:labelmove
ECHO moving files...
  For /R %varSource% %%G IN (%name%.%type%) do (
	echo "%%G" 
	move "%%G" "%varDest%"
  )
goto exitprog

:labelinf
ECHO segreagting files...
ECHO copying files into destination...
  For /R %varSource% %%G IN (%name%.%type%) do (
	echo "%%G" 
	echo %%~nG
	echo %%~xG
	echo %%~snG
	echo %%~aG 
	echo %%~dG
	echo %%~zG
	echo %%~tG
	echo %%~dpG
	echo %%~fG
	echo %%~sfG
	set filedate=%%~tG
	echo %filedate%
	rem copy "%%G" "%varDest%"
  )

:labelseg
set /p segchoice=segregate by week, month or year(enter "week" or "month" or "year"):
echo %segchoice%
ECHO segregting files by %segchoice%...

  For /R %varSource% %%G IN (%name%.%type%) do (
  	set filedate=%%~tG
	echo %%G	
	rem echo !filedate!
	set date=!filedate:~0,2!
	set /a week=!date!/7
	set /a week=!week!+1
	set fileMonth=!filedate:~3,2!
	set fileYear=!filedate:~6,4!
	rem echo filedate=!filedate! fileMonth=!fileMonth! and fileYear=!fileYear!

	IF "%segchoice%"=="week" (
		set "foldername=Week!week!-!fileMonth!-!fileYear!"
		echo copied into :\!foldername!\
		IF not exist %varDest%\!foldername!\ mkdir %varDest%\!foldername!
		copy "%%G" "%varDest%\!foldername!\"
		)
	IF "%segchoice%"=="month" (
		set "foldername=!fileMonth!-!fileYear!"
		echo copied into :\!foldername!\
		IF not exist %varDest%\!foldername!\ mkdir %varDest%\!foldername!
		copy "%%G" "%varDest%\!foldername!\"
		)
	IF "%segchoice%"=="year" (
		set "foldername=!fileYear!"
		echo copied into :\!foldername!\
		IF not exist %varDest%\!foldername!\ mkdir %varDest%\!foldername!
		copy "%%G" "%varDest%\!foldername!\"
		)
  )
goto exitprog

:labelhide
set /p folderhide=Drag file/folder to hide(remember the location string of all files you are hiding and check "Dont show hidden folders" in folder options setting in Windows):
echo %folderhide%
attrib +r +s +h %folderhide%
goto exitprog

:labelshow
set /p foldershow=Type the location of hidden file/folder:
echo %foldershow%
attrib -r -h -s %foldershow%
goto exitprog

:exitprog
set /p exitchoice=Exit???(enter 'y' or 'n'):
IF "%exitchoice%"=="n" (goto startprog)
