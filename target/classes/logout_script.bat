@echo off
setlocal enabledelayedexpansion

:: タブ文字を変数に設定
set "TAB=	"

:: 現在の日時を取得
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set datetime=%%I
set year=!datetime:~0,4!
set month=!datetime:~4,2!
set day=!datetime:~6,2!
set hours=!datetime:~8,2!
set mins=!datetime:~10,2!

:: 分が一桁の場合、先頭に0を追加して2桁にする
if !mins! lss 10 set mins=0!mins!

:: 退勤時刻の処理
:: 17時半以降は15分刻みで切り捨て
if !hours! geq 17 (
    if !hours!==17 (
        if !mins! geq 30 (
            set /a mins=!mins!/15*15
        ) else (
            set mins=30
        )
    ) else (
        set /a mins=!mins!/15*15
    )
    if !mins! lss 10 set mins=0!mins!
    set leavetime=!hours!:!mins!
) else (
    set leavetime=!hours!:!mins!
)

:: 出勤時刻は固定で09:00
set "attendancetime=09:00"

:: ファイル名と一時ファイル名を定義
set "filename=attendance_2024_02.txt"
set "tempfile=temp_attendance_2024_02.txt"

:: 一時ファイルが存在する場合、削除
if exist "!tempfile!" del "!tempfile!"

:: 日付のフォーマットを設定
set "date=!year!/!month!/!day!"

:: ファイルを読み込み、指定された日付の行を更新
(for /f "tokens=*" %%A in ('type "!filename!"') do (
    set "line=%%A"
    if "!line:~0,10!"=="!date!" (
        echo !date!!TAB!!attendancetime!!TAB!!leavetime!!TAB!0.75
    ) else (
        echo %%A
    )
)) > "!tempfile!"

:: 一時ファイルを元のファイルに上書きコピー
move /Y "!tempfile!" "!filename!"

echo Updated !filename! for !date!.
endlocal
