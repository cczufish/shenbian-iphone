@echo off

echo.
echo ����ģ��

echo ����װ�ļ����з�����outputĿ¼��
rmdir /S/Q .\output\
mkdir .\output
copy ".\binary\*" .\output

GOTO SUCCESS

:SUCCESS
echo.
cmd /c > 0
echo Succeeded!
GOTO END
 
:ERROR
echo.
if exist 0 del /q 0
ECHO Failed!
GOTO END
 
:END
