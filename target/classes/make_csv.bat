@echo off
setlocal enabledelayedexpansion

:: タブ文字を表す変数を設定
set "TAB=	"

:: 出力先のパスを指定
set outputPath=C:\Users\miyaw\Documents\schedule

:: 現在の年月を取得
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set datetime=%%a
set year=!datetime:~0,4!
set month=!datetime:~4,2!

:: その月の日数を取得
call :getDaysInMonth !year! !month! daysInMonth

:: 指定されたフォーマットでファイルに書き込む
set filename=!outputPath!\attendance_!year!_!month!.txt
if exist "!filename!" del "!filename!"

for /l %%d in (1,1,!daysInMonth!) do (
    set day=%%d
    if !day! lss 10 set day=0!day!
    echo !year!/!month!/!day!!TAB!!TAB!>> "!filename!"
)

echo Generated !filename! with !daysInMonth! days.
pause
goto :eof

:: その月が何日あるかを計算する関数
:getDaysInMonth
setlocal enableextensions enabledelayedexpansion
set year=%1
set month=%2
set /a monthNext=1%month% + 1
set /a yearNext=%year%
if %monthNext% gtr 112 (
    set /a monthNext=101
    set /a yearNext+=1
)

:: PowerShellを使用してその月の日数を取得
for /f %%a in ('powershell -Command "(Get-Date -Year !year! -Month !month! -Day 1).AddMonths(1).AddDays(-1).Day"') do set daysInMonth=%%a

endlocal & set %3=%daysInMonth%
goto :eof
