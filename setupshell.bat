@echo off

d:

cd projects\jai\adventofcode

git pull

call build.bat

start /max c:\4coder\4ed.exe
start /max C:\remedybg\remedybg.exe open-session "adventofcode.rdbg"