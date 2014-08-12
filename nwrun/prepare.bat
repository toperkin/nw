@echo off
echo =====================================================
echo Preparing perm and tmp directories...
mkdir perm
mkdir tmp
REM %* = all parameters
del perm\%*.*
del tmp\%*.*
echo Printing environment variables:
set
echo =====================================================
echo ENTERING NWCHEM SYSTEM...
