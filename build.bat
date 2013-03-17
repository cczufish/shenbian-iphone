@echo off

echo.
echo 编译模块

echo 将安装文件集中发布到output目录下
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
