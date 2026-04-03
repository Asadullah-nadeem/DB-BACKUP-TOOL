@echo off
setlocal enabledelayedexpansion


:: ============================================
::        DB BACKUP TOOL (1.0 VERSION)
:: ============================================
:: Author  : Asadullah Nadeem
:: Purpose : Backup multiple MySQL databases
:: Note    : Password removed for security
:: ============================================


:: --- CONFIGURATION ---
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_PORT=3306
set MYSQL_HOST=127.0.0.1
set BACKUP_ROOT=C:\MySQL_Backups_test
set MYSQLDUMP_PATH="C:\xampp\mysql\bin\mysqldump.exe"

set DBS=db_test1 db_test2 db_test3 db_test4 db_test5

:: --- SCHEDULER AUTO-ADD (6:00 PM) ---
set TASK_NAME="MySQL_Daily_test_Backup"
schtasks /query /tn %TASK_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo Task not found. Adding %TASK_NAME% to Scheduler...
    :: /rl highest fixes the 0 KB issue by granting Admin rights
    schtasks /create /tn %TASK_NAME% /tr "\"%~f0\"" /sc daily /st 18:00 /rl highest /f
    echo Task scheduled for 6:00 PM daily.
)

:: --- TIMESTAMP & FOLDER LOGIC ---
for /f %%i in ('wmic os get localdatetime ^| find "."') do set datetime=%%i
set timestamp=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!-!datetime:~10,2!

set BACKUP_DIR=!BACKUP_ROOT!\test_!timestamp!
set LOGFILE=!BACKUP_DIR!\backup_log.txt

if not exist "!BACKUP_ROOT!" mkdir "!BACKUP_ROOT!"
if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"

echo Backup started at !timestamp! > "!LOGFILE!"
echo ======================================= >> "!LOGFILE!"

:: --- BACKUP LOOP ---
for %%D in (!DBS!) do (
    echo Backing up database: %%D
    set FILENAME=!BACKUP_DIR!\%%D_!timestamp!.sql

    :: Run mysqldump - Redirecting error output to log to see why 0 KB happens
    !MYSQLDUMP_PATH! -u !MYSQL_USER! -p!MYSQL_PASSWORD! -P !MYSQL_PORT! -h !MYSQL_HOST! %%D > "!FILENAME!" 2>> "!LOGFILE!"

    :: Verify file size
    if exist "!FILENAME!" (
        for %%F in ("!FILENAME!") do set SIZE=%%~zF
        if !SIZE! GTR 0 (
            echo SUCCESS: %%D [!SIZE! bytes] >> "!LOGFILE!"
            echo Success: %%D
        ) else (
            echo WARNING: %%D resulted in 0 KB. Check DB connection or permissions. >> "!LOGFILE!"
            echo Failed: %%D (0 KB file)
        )
    )
)

echo ======================================= >> "!LOGFILE!"
echo All tasks complete. Closing in 4 seconds...
timeout /t 4
