PCの起動時とログアウト（スリープを含む）時に自動で勤怠を登録するには、Windowsのタスクスケジューラを利用する方法が適しています。タスクスケジューラを使用すると、特定のイベント（例えば、ログオンやログオフ）が発生したときにスクリプトを自動実行できます。

### 必要な要件

1. **タスクスケジューラの設定**
   - PCの起動時（ログオン時）に実行するタスクを設定。
   - ログアウトやスリープ時に実行するタスクを設定。

2. **スクリプトの作成**
   - 起動時に現在時刻をCSVに出勤時間として記録するスクリプト。
   - ログアウトやスリープ時に現在時刻をCSVに退勤時間として記録するスクリプト。

### スクリプト例

**出勤記録スクリプト（logon_script.bat）:**

```batch
@echo off
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set datetime=%%I
set datetime=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%
echo Logon, %datetime% >> C:\path\to\attendance.csv
```

**退勤記録スクリプト（logout_script.bat）:**

```batch
@echo off
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set datetime=%%I
set datetime=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%
echo Logout, %datetime% >> C:\path\to\attendance.csv
```

### タスクスケジューラでの設定方法

1. **タスクスケジューラを開く**
   - スタートメニューから「タスクスケジューラ」を検索して開く。

2. **新しいタスクを作成**
   - 「アクション」メニューから「タスクの作成」を選択。

3. **トリガーの設定**
   - 「トリガー」タブで「新規」をクリックし、タスクの開始条件を設定。
   - 起動時タスクでは「ログオン時」、ログアウト時タスクでは「ワークステーションのロック」または「ワークステーションのロック解除」を選択（スリープからの復帰を含む）。

4. **操作の設定**
   - 「操作」タブで「新規」をクリックし、実行するスクリプトを指定。

5. **その他の設定**
   - 必要に応じて「条件」や「設定」タブで詳細な設定を行う。

6. **タスクの保存**
   - 設定が完了したら「OK」をクリックしてタスクを保存。

この方法により、PCの起動時とログアウト（またはスリープ）時に自動で勤怠記録が行われるようになります。スクリプトのパスやCSVファイルの保存場所は、実際の環境に合わせて適宜変更してください。

文字数: 2262
トークン数: 305


`logon_script.bat`のスクリプト内容について説明します。

```batch
@echo off
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set datetime=%%I
set datetime=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%
echo Logon, %datetime% >> C:\path\to\attendance.csv
```

### スクリプトの各行の説明

1. `@echo off`
   - このコマンドは、バッチファイルの実行中にコマンド自体を表示させないようにするためのものです。コマンドの実行結果のみが表示されます。

2. `for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set datetime=%%I`
   - この行は、Windows Management Instrumentation Command-line (WMIC) を使用して、システムのローカル日時を取得します。
   - `for /f`ループは、コマンドの出力を処理し、`tokens=2 delims==`を使用して出力を分割し、2番目のトークン（この場合は日時の値）を変数`%%I`に割り当てます。
   - `wmic OS Get localdatetime /value`コマンドは、オペレーティングシステムのローカル日時を`YYYYMMDDHHMMSS.MMMMMM+UUU`の形式で取得します。
   - 取得した日時は`datetime`変数に格納されます。

3. `set datetime=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%`
   - この行は、`datetime`変数に格納された日時をより読みやすい形式（`YYYY/MM/DD HH:MM`）に変換します。
   - 文字列の部分選択機能を使用して、年、月、日、時、分を適切な位置から抽出し、フォーマットを整えます。

4. `echo Logon, %datetime% >> C:\path\to\attendance.csv`
   - このコマンドは、`Logon`と変換された日時を`attendance.csv`ファイルに追記します。ファイルが存在しない場合は新しく作成されます。
   - `>>`オペレータは、指定されたファイルの末尾に出力を追加します。これにより、ログオンのたびに新しい行がCSVファイルに追加されます。

### 結論

このスクリプトは、PCのログオン時に現在の日時を`YYYY/MM/DD HH:MM`の形式で`attendance.csv`に記録します。これにより、勤怠管理の自動化が可能になります。スクリプトのパスやCSVファイルの保存場所は、使用する環境に応じて適宜変更する必要があります。

文字数: 1644
トークン数: 221

Windowsでタスクスケジューラーを使用して`logout_script.bat`を登録し、cronのようにバッチ処理でタスクの登録や確認を行うことは可能です。Windowsのタスクスケジューラーは、`schtasks`コマンドを使ってコマンドラインから操作できます。これにより、スクリプトを特定のイベント（例えば、ログオフ時）に自動的に実行させることができます。

### `logout_script.bat`をログオフ時に実行するタスクを作成

以下は、`logout_script.bat`をユーザーがログオフしたときに実行するタスクを作成するためのコマンド例です。

```batch
schtasks /create /tn "Logout Task" /tr "C:\path\to\logout_script.bat" /sc onlogoff
```

- `/tn "Logout Task"`: タスクの名前を指定します。
- `/tr "C:\path\to\logout_script.bat"`: 実行するスクリプトのパスを指定します。
- `/sc onlogoff`: タスクのスケジュールをログオフ時に設定します。

### タスクの確認

登録したタスクの一覧を表示するには、以下のコマンドを使用します。

```batch
schtasks /query
```

特定のタスクの詳細情報を確認するには、以下のコマンドを使用します。

```batch
schtasks /query /tn "Logout Task" /v
```

- `/tn "Logout Task"`: 確認したいタスクの名前を指定します。
- `/v`: 詳細情報を表示します。

### タスクの削除

登録したタスクを削除するには、以下のコマンドを使用します。

```batch
schtasks /delete /tn "Logon Task"
```

- `/tn "Logout Task"`: 削除したいタスクの名前を指定します。

これらのコマンドをバッチファイルにまとめることで、タスクの登録、確認、削除を自動化するスクリプトを作成することができます。cronのように定期的な実行ではなく、特定のイベント（この場合はログオフ時）に基づいてスクリプトを実行するタスクを簡単に管理できます。
