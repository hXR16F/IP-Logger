:: Programmed by hXR16F
:: hXR16F.ar@gmail.com

@echo off & mode 90,28 & consetbuffer.exe 300 400 & color 07 & ansicon -p
for %%i in ("index.php"	"log.txt"	"ips.txt"	"err.vbs") do (if exist %%~i del /f /q %%~i >nul)

(php -v >nul 2>&1) || ((echo x=msgbox^("PHP is not installed!"^)> "err.vbs")&start "" "err.vbs"&exit)
(start /min "" "ssh") || ((echo x=msgbox^("SSH is not installed!"^)> "err.vbs")&start "" "err.vbs"&exit)

set /p "alias=[93m[[0m[97m?[0m[93m] Alias:[0m [97m"&echo [0m>nul
set /p "redirect=[93m[[0m[97m?[0m[93m] Redirect URL [97m(leave blank for invalid response)[0m[93m:[0m [97m"&echo [0m>nul
if "%redirect%" equ "" (set "redirect=http://"&set "redirect_title=ERR_INVALID_REDIRECT") else (set "redirect_title=%redirect%")

echo ^<?php>> "index.php"
echo 	if (!empty($_SERVER['HTTP_CLIENT_IP'])) {>> "index.php"
echo 		$ipaddress = $_SERVER['HTTP_CLIENT_IP'];>> "index.php"
echo 	} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {>> "index.php"
echo 		$ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];>> "index.php"
echo 	} else {>> "index.php"
echo 		$ipaddress = $_SERVER['REMOTE_ADDR'];>> "index.php"
echo 	}>> "index.php"
echo 	$browser = $_SERVER['HTTP_USER_AGENT'];>> "index.php"
echo 	$file = 'log.txt';>> "index.php"
echo 	$fp = fopen($file, 'a');>> "index.php"
echo 	fwrite($fp, $ipaddress."  	");>> "index.php"
echo 	fwrite($fp, $browser."\r\n");>> "index.php"
echo 	fclose($fp);>> "index.php">> "index.php"
echo 	header("Location: %redirect%");>> "index.php"
echo ?^>>> "index.php"

echo.
echo [97m[[0m[93m*[0m[97m] Starting PHP server...[0m
start /b "" "php" -S localhost:80 >nul 2>&1
@ping localhost -n 1 >nul

echo [97m[[0m[93m*[0m[97m] Starting SSH tunelling...[0m
start /b "" "ssh" -R %alias%:80:localhost:80 serveo.net >nul 2>&1
@ping localhost -n 2 >nul

title 0 requests, [http://%alias%.serveo.net --^> %redirect_title%]
echo.
echo [93m[[0m[97m*[0m[93m] IP Address  	User-Agent
rem echo     ------------------------------[0m
echo     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[0m
setlocal EnableDelayedExpansion

if not exist "capture.txt" (
	echo # This file has been generated using IP-Logger by hXR16F>> "capture.txt"
	echo # https://github.com/hXR16F/IP-Logger>> "capture.txt"
	echo.>> "capture.txt"
	echo IP Address	User-Agent>> "capture.txt"
	echo -------------------------->> "capture.txt"
)

:loop
	if exist "log.txt" (
		for /f "tokens=1,2 delims=	" %%i in (log.txt) do (
			(find "%%i" ips.txt >nul 2>&1) || echo [97m[[0m[93m+[0m[97m] %%i	%%j[0m
			(find "%%i" capture.txt >nul 2>&1) || echo %%i	%%j>> "capture.txt"
			echo %%i>> "ips.txt"
		)
		del /f /q "log.txt" >nul
		set /a requests+=1
		if not "!requests!" equ "1" (title !requests! requests, [http://%alias%.serveo.net --^> %redirect_title%]) else (title !requests! request, [http://%alias%.serveo.net --^> %redirect_title%])
	)
	@ping localhost -n 2 >nul
	goto :loop

for /l %%i in (0,0,1) do pause >nul