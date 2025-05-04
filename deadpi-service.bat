@echo off
chcp 65001 >nul
:: 65001 - UTF-8

:: Admin rights check
echo перезапусти батник с админ-правами,если так и сделал,проигнорируй сообщение.
echo нажмите любую клавишу, чтобы продолжить создание сервиса
pause

set BIN=%~dp0bin\
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist=\"%~dp0list-general.txt\" --dpi-desync=fake,disorder2 --dpi-desync-cutoff=d4 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-65535 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d4 --dpi-desync-fake-quic=\"%BIN%quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --hostlist=\"%~dp0list-general.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list-general.txt\" --dpi-desync=fake,disorder2 --dpi-desync-autottl=1 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=\"%BIN%tls_clienthello_www_google_com.bin\"

set SRVCNAME=kizil

net stop %SRVCNAME%
sc delete %SRVCNAME%
sc create %SRVCNAME% binPath= "\"%BIN%winws.exe\" %ARGS%" DisplayName= "kizil bypass : %SRVCNAME%" start= auto
sc description %SRVCNAME% "kizil bypass by KizilAnanasovich"
sc start %SRVCNAME%

pause
