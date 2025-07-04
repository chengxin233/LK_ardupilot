#Powershell script to download and configure the APM SITL environment

Import-Module BitsTransfer

Write-Output "Starting Downloads"

Write-Output "Downloading MAVProxy (1/7)"
Start-BitsTransfer -Source "https://firmware.ardupilot.org/Tools/MAVProxy/MAVProxySetup-latest.exe" -Destination "$PSScriptRoot\MAVProxySetup-latest.exe"

Write-Output "Downloading Cygwin x64 (2/7)"
Start-BitsTransfer -Source "https://cygwin.com/setup-x86_64.exe" -Destination "$PSScriptRoot\setup-x86_64.exe"

Write-Output "Downloading ARM GCC Compiler 10-2020-Q4-Major (3/7)"
Start-BitsTransfer -Source "https://firmware.ardupilot.org/Tools/STM32-tools/gcc-arm-none-eabi-10-2020-q4-major-win32.exe" -Destination "$PSScriptRoot\gcc-arm-none-eabi-10-2020-q4-major-win32.exe"

Write-Output "Installing Cygwin x64 (4/7)"
Start-Process -wait -FilePath $PSScriptRoot\setup-x86_64.exe -ArgumentList "--root=C:\cygwin64 --no-startmenu --local-package-dir=$env:USERPROFILE\Downloads --site=http://cygwin.mirror.constant.com --packages autoconf,automake,ccache,cygwin32-gcc-g++,gcc-g++=7.4.0-1,libgcc1=7.4.0.1,gcc-core=7.4.0-1,git,libtool,make,gawk,libexpat-devel,libxml2-devel,python39,python39-future,python39-lxml,python39-pip,libxslt-devel,python39-devel,procps-ng,zip,gdb,ddd,xterm --quiet-mode"

Write-Output "Downloading extra Python packages (5/7)"
Start-Process -wait -FilePath "C:\cygwin64\bin\bash" -ArgumentList "--login -i -c 'python3.9 -m pip install empy==3.3.4 pyserial pymavlink intelhex dronecan pexpect'"

Write-Output "Installing ARM GCC Compiler 10-2020-Q4-Major (6/7)"
& $PSScriptRoot\gcc-arm-none-eabi-10-2020-q4-major-win32.exe /S /P /R

Write-Output "Installing MAVProxy (7/7)"
& $PSScriptRoot\MAVProxySetup-latest.exe /SILENT | Out-Null

Write-Host "Finished. Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
