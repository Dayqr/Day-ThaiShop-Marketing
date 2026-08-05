@echo off
REM ============================================================
REM  Day-ThaiShop-Marketing - ติดตั้งอัตโนมัติ
REM  ดับเบิลคลิกไฟล์นี้ครั้งเดียว จบทุกอย่าง
REM
REM  สิ่งที่สคริปต์นี้ทำ:
REM   1. เช็คว่ามี git / python / ffmpeg ครบไหม
REM   2. ก๊อป pipeline จาก Day-News-Aus มาไว้ที่ pipeline\
REM   3. สร้าง venv + ติดตั้ง library
REM   4. สร้างโฟลเดอร์คลังเก็บวิดีโอที่ D:\video-archive
REM   5. สร้างไฟล์ .env (ถ้ายังไม่มี)
REM
REM  ปลอดภัย: ไม่ลบไฟล์อะไรทั้งสิ้น ถ้ามีของอยู่แล้วจะข้ามไป
REM ============================================================

chcp 65001 >nul
setlocal EnableDelayedExpansion
title Day-ThaiShop-Marketing - Setup
cd /d "%~dp0"

set "SRC_REPO=%~dp0..\Day-News-Aus"
set "ARCHIVE=D:\video-archive"
set "ERRCOUNT=0"

echo.
echo ============================================================
echo   Day-ThaiShop-Marketing - ติดตั้งอัตโนมัติ
echo ============================================================
echo   โฟลเดอร์โปรเจกต์ : %~dp0
echo   คลังเก็บวิดีโอ    : %ARCHIVE%
echo ============================================================
echo.

REM ---------- ขั้นที่ 1: เช็คโปรแกรมที่ต้องมี ----------
echo [1/5] เช็คโปรแกรมที่ต้องมี...
echo.

where git >nul 2>&1
if errorlevel 1 (
  echo   [X] ไม่พบ git       ^-^-^> ติดตั้งที่ https://git-scm.com/download/win
  set /a ERRCOUNT+=1
) else ( echo   [OK] git )

where python >nul 2>&1
if errorlevel 1 (
  echo   [X] ไม่พบ python    ^-^-^> ติดตั้งที่ https://www.python.org/downloads/
  echo        ^(ตอนติดตั้งต้องติ๊ก "Add Python to PATH" ด้วย^)
  set /a ERRCOUNT+=1
) else ( echo   [OK] python )

where ffmpeg >nul 2>&1
if errorlevel 1 (
  echo   [!] ไม่พบ ffmpeg   ^-^-^> จำเป็นตอนทำวิดีโอ ติดตั้งที่ https://www.gyan.dev/ffmpeg/builds/
  echo        ^(ตอนนี้ข้ามไปก่อนได้ ติดตั้งทีหลังแล้วรัน setup.bat ใหม่^)
) else ( echo   [OK] ffmpeg )

if !ERRCOUNT! GTR 0 (
  echo.
  echo   ต้องติดตั้งโปรแกรมข้างบนก่อน แล้วรัน setup.bat ใหม่อีกครั้ง
  echo.
  pause
  exit /b 1
)
echo.

REM ---------- ขั้นที่ 2: ก๊อป pipeline จาก Day-News-Aus ----------
echo [2/5] ก๊อป pipeline จาก Day-News-Aus...
echo.

if not exist "%SRC_REPO%\src" (
  echo   [!] หา Day-News-Aus ไม่เจอที่ %SRC_REPO%
  echo.
  echo       โปรเจกต์นี้ควรอยู่ข้างๆ Day-News-Aus แบบนี้:
  echo         C:\Users\dacha\youtube150226\Day-News-Aus\
  echo         C:\Users\dacha\youtube150226\Day-ThaiShop-Marketing\   ^<-- ตรงนี้
  echo.
  echo       ข้ามขั้นนี้ไปก่อน เดี๋ยวก๊อปเองทีหลังได้
  echo.
  goto :step3
)

if exist "pipeline\src" (
  echo   [ข้าม] pipeline\src มีอยู่แล้ว - ไม่ทับของเดิม
) else (
  xcopy /E /I /Q /Y "%SRC_REPO%\src" "pipeline\src" >nul
  if errorlevel 1 ( echo   [X] ก๊อป src ไม่สำเร็จ ) else ( echo   [OK] pipeline\src )
)

if exist "pipeline\fonts" (
  echo   [ข้าม] pipeline\fonts มีอยู่แล้ว
) else (
  xcopy /E /I /Q /Y "%SRC_REPO%\fonts" "pipeline\fonts" >nul
  if errorlevel 1 ( echo   [X] ก๊อป fonts ไม่สำเร็จ ) else ( echo   [OK] pipeline\fonts )
)

if exist "pipeline\requirements.txt" (
  echo   [ข้าม] pipeline\requirements.txt มีอยู่แล้ว
) else (
  copy /Y "%SRC_REPO%\requirements.txt" "pipeline\requirements.txt" >nul
  if errorlevel 1 ( echo   [X] ก๊อป requirements.txt ไม่สำเร็จ ) else ( echo   [OK] pipeline\requirements.txt )
)

REM ก๊อป skill files ไว้อ่านอ้างอิง (ไม่ทับของเดิม)
if not exist "pipeline\reference" mkdir "pipeline\reference" >nul 2>&1
for %%F in (HOOK_WRITING.md SHORT_PEXELS.md SHORT_AI.md LANDSCAPE_PEXELS.md) do (
  if exist "%SRC_REPO%\skills\%%F" (
    if not exist "pipeline\reference\%%F" copy /Y "%SRC_REPO%\skills\%%F" "pipeline\reference\%%F" >nul
  )
)
echo   [OK] pipeline\reference  ^(skill files ไว้อ่านอ้างอิง^)
echo.

:step3
REM ---------- ขั้นที่ 3: venv + ติดตั้ง library ----------
echo [3/5] สร้าง venv และติดตั้ง library...
echo.

if exist "venv\Scripts\python.exe" (
  echo   [ข้าม] venv มีอยู่แล้ว
) else (
  python -m venv venv
  if errorlevel 1 (
    echo   [X] สร้าง venv ไม่สำเร็จ
    goto :step4
  )
  echo   [OK] สร้าง venv
)

if exist "pipeline\requirements.txt" (
  echo   กำลังติดตั้ง library... ^(ใช้เวลาสักครู่^)
  call "venv\Scripts\python.exe" -m pip install --quiet --upgrade pip
  call "venv\Scripts\python.exe" -m pip install --quiet -r "pipeline\requirements.txt"
  if errorlevel 1 (
    echo   [!] ติดตั้งบาง library ไม่สำเร็จ - ดูข้อความข้างบน
  ) else (
    echo   [OK] ติดตั้ง library ครบ
  )
) else (
  echo   [ข้าม] ยังไม่มี requirements.txt
)
echo.

:step4
REM ---------- ขั้นที่ 4: สร้างคลังเก็บวิดีโอที่ D: ----------
echo [4/5] สร้างคลังเก็บวิดีโอที่ %ARCHIVE% ...
echo.

if not exist "D:\" (
  echo   [!] ไม่พบไดรฟ์ D:  ^-^-^> ข้ามไปก่อน
  echo        เดี๋ยวแก้ ARCHIVE_DIR ในไฟล์ .env ทีหลังได้
  goto :step5
)

for %%D in ("%ARCHIVE%" "%ARCHIVE%\uploaded" "%ARCHIVE%\avatar-source" "%ARCHIVE%\backup") do (
  if exist "%%~D" (
    echo   [ข้าม] %%~D มีอยู่แล้ว
  ) else (
    mkdir "%%~D" >nul 2>&1
    if errorlevel 1 ( echo   [X] สร้าง %%~D ไม่สำเร็จ ) else ( echo   [OK] %%~D )
  )
)
echo.

:step5
REM ---------- ขั้นที่ 5: สร้างไฟล์ .env ----------
echo [5/5] สร้างไฟล์ .env ...
echo.

if exist ".env" (
  echo   [ข้าม] .env มีอยู่แล้ว - ไม่ทับของเดิม
) else (
  (
    echo # ============================================
    echo # Day-ThaiShop-Marketing - ไฟล์ตั้งค่า
    echo # สร้างโดย setup.bat
    echo # !! ห้ามอัปขึ้น GitHub !! ^(.gitignore กันไว้แล้ว^)
    echo # ============================================
    echo.
    echo # ---- ที่เก็บไฟล์ ----
    echo # C: ^(SSD^) = ที่เรนเดอร์  ^|  D: ^(HDD^) = ที่เก็บถาวร
    echo ARCHIVE_DIR=%ARCHIVE%
    echo.
    echo # ---- ฟรีทั้งหมด ----
    echo PEXELS_API_KEY=
    echo GOOGLE_APPLICATION_CREDENTIALS=
    echo.
    echo # ---- ช่องใหม่: ต้องสร้าง OAuth ใหม่ ห้ามใช้ของ Day-News-Aus ----
    echo YOUTUBE_CLIENT_ID=
    echo YOUTUBE_CLIENT_SECRET=
    echo FACEBOOK_PAGE_ID=
    echo FACEBOOK_PAGE_TOKEN=
    echo.
    echo # ---- มีค่าใช้จ่าย: ใส่เมื่อพร้อมเท่านั้น ----
    echo HEYGEN_API_KEY=
    echo HEYGEN_AVATAR_ID=
    echo.
    echo # ---- ตั้งค่าช่อง ----
    echo CHANNEL_LANGUAGE=th
    echo TARGET_AUDIENCE=เจ้าของร้านไทยในออสเตรเลีย
  ) > ".env"
  echo   [OK] สร้าง .env แล้ว - ยังต้องใส่ API key เอง
)

if exist ".env" (
  if exist "%SRC_REPO%\.env" (
    echo.
    echo   [ทิป] Day-News-Aus มีไฟล์ .env ที่ใช้งานได้อยู่แล้ว
    echo         ก๊อป PEXELS_API_KEY กับ GOOGLE_APPLICATION_CREDENTIALS มาใช้ได้เลย
    echo         แต่ YOUTUBE / FACEBOOK ต้องสร้างใหม่ ^(คนละช่องกัน^)
  )
)

echo.
echo ============================================================
echo   ติดตั้งเสร็จแล้ว
echo ============================================================
echo.
echo   ต่อไปทำอะไร:
echo.
echo   1. เปิดไฟล์ .env แล้วใส่ API key
echo   2. เปิดโปรเจกต์ใน VS Code:  code .
echo   3. บอก Claude ว่า: "อ่าน CLAUDE.md แล้วบอกผมว่าต้องเริ่มทำอะไร"
echo.
echo   ไฟล์ที่ควรอ่านก่อน:
echo     README.md                  ภาพรวมโปรเจกต์
echo     docs\01-STRATEGY.md        กลยุทธ์ ^(มี 3 เรื่องรอคุณเดตัดสินใจ^)
echo     docs\06-ROADMAP-90DAYS.md  แผน 90 วัน
echo.
echo   เก็บวิดีโอที่ทำเสร็จแล้วไป D: ^-^-^>  ดับเบิลคลิก archive.bat
echo.
echo ============================================================
echo.
pause
endlocal
