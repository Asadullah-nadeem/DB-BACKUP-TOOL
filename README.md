# DB Backup Tool

Windows batch script to backup multiple MySQL databases automatically with logs and scheduling.

---

## What This Tool Does

* Backup multiple databases at once
* Creates timestamp-based backup folders
* Saves logs (success + errors)
* Auto adds daily scheduler (Windows)
* Lightweight (no extra setup)

---

## Setup

1. Install MySQL / XAMPP
2. Update config in `backup.bat`:

```
set MYSQL_USER=root
set MYSQL_PASSWORD=
set MYSQL_PORT=3306
set MYSQL_HOST=127.0.0.1
set MYSQLDUMP_PATH="C:\xampp\mysql\bin\mysqldump.exe"

set DBS=db_test1 db_test2 db_test3 db_test4 db_test5
```

---

## How to Use (Windows)

1. Save file as `backup.bat`
2. Double click it
   OR run:

```
backup.bat
```

3. Backups will be saved in:

```
C:\MySQL_Backups_test\
```

---

## Windows Scheduler (Auto)

Script automatically creates a scheduled task.

### Default:

* Runs daily at **6:00 PM**

### Check manually:

1. Open **Task Scheduler**
2. Go to:

   ```
   Task Scheduler Library
   ```
3. Find:

   ```
   MySQL_Daily_test_Backup
   ```

---

## Linux Setup (Cron Job)

### Step 1: Create script

```
backup.sh
```

### Step 2: Make executable

```
chmod +x backup.sh
```

### Step 3: Open cron

```
crontab -e
```

### Step 4: Add (6 PM daily)

```
0 18 * * * /path/to/backup.sh
```

---

## Where You Can Use It

* Local development backup
* Client database backup
* Testing environments
* Small server automation

---

##  Notes

* MySQL must be running
* `mysqldump` path must be correct
* DB names must exist
* Add password if needed

---



---
