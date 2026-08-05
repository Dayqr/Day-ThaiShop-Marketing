@echo off
REM ============================================================
REM  archive.bat - ย้ายวิดีโอที่ทำเสร็จแล้วจาก C: ไปเก็บที่ D:
REM
REM  ทำไมต้องย้าย:
REM    C: เป็น SSD  -> เร็ว ใช้เรนเดอร์ แต่พื้นที่มีจำกัด
REM    D: เป็น HDD  -> ช้า แต่พื้นที่เยอะ เหมาะเก็บของที่ทำเสร็จแล้ว
REM
REM  ปลอดภัย: ย้ายเฉพาะไฟล์วิดีโอ/เสียง และถามยืนยันก่อนย้ายเสมอ
REM  แนะนำ: รันสัปดาห์ละครั้ง
REM ============================================================

chcp 65001 >nul
setlocal EnableDelayedExpansion
title Day-ThaiShop-Marketing - Archive to D:
cd /d "%~dp0"

set "SRC=%~dp0output"
set "DEST=D:\video-archive\uploaded"

echo.
echo ============================================================
echo   ย้ายวิดีโอที่ทำเสร็จแล้ว  C: ^-^-^> D:
echo ============================================================
echo   จาก : %SRC%
echo   ไป  : %DEST%
echo ============================================================
echo.

if not exist "%SRC%" (
  echo   ยังไม่มีโฟลเดอร์ output - ยังไม่ได้ทำวิดีโอเลย
  echo.
  pause
  exit /b 0
)

if not exist "D:\" (
  echo   [X] ไม่พบไดรฟ์ D:
  echo.
  pause
  exit /b 1
)

if not exist "%DEST%" mkdir "%DEST%" >nul 2>&1

REM ---------- นับไฟล์ที่จะย้าย ----------
set "COUNT=0"
for /r "%SRC%" %%F in (*.mp4 *.mov *.wav *.mp3 *.m4a) do set /a COUNT+=1

if !COUNT! EQU 0 (
  echo   ไม่มีไฟล์วิดีโอ/เสียงให้ย้าย
  echo.
  pause
  exit /b 0
)

echo   พบไฟล์ที่ย้ายได้ : !COUNT! ไฟล์
echo.
echo   ตัวอย่าง 10 ไฟล์แรก:
set "SHOWN=0"
for /r "%SRC%" %%F in (*.mp4 *.mov *.wav *.mp3 *.m4a) do (
  if !SHOWN! LSS 10 (
    echo     - %%~nxF  ^(%%~zF bytes^)
    set /a SHOWN+=1
  )
)
echo.

REM ---------- ถามยืนยัน ----------
set "ANS="
set /p "ANS=  ย้ายไป D: เลยไหม? พิมพ์ y แล้วกด Enter (อย่างอื่น = ยกเลิก): "
if /i not "!ANS!"=="y" (
  echo.
  echo   ยกเลิกแล้ว - ไม่มีไฟล์ไหนถูกย้าย
  echo.
  pause
  exit /b 0
)

echo.
echo   กำลังย้าย...
echo.

REM ---------- ย้ายจริง คงโครงสร้างโฟลเดอร์ไว้ ----------
set "MOVED=0"
set "FAILED=0"
for /r "%SRC%" %%F in (*.mp4 *.mov *.wav *.mp3 *.m4a) do (
  set "FULL=%%~dpF"
  set "REL=!FULL:%SRC%\=!"
  set "TARGETDIR=%DEST%\!REL!"
  if not exist "!TARGETDIR!" mkdir "!TARGETDIR!" >nul 2>&1
  move /Y "%%~fF" "!TARGETDIR!" >nul 2>&1
  if errorlevel 1 (
    echo     [X] %%~nxF
    set /a FAILED+=1
  ) else (
    echo     [OK] %%~nxF
    set /a MOVED+=1
  )
)

echo.
echo ============================================================
echo   ย้ายสำเร็จ : !MOVED! ไฟล์
if !FAILED! GTR 0 echo   ย้ายไม่ได้ : !FAILED! ไฟล์  ^(อาจเปิดค้างอยู่ - ปิดโปรแกรมแล้วลองใหม่^)
echo   เก็บไว้ที่ : %DEST%
echo ============================================================
echo.
pause
endlocal
