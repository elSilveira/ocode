@echo off

setlocal enabledelayedexpansion
set "input=%~1"

rem Verificar se o primeiro parâmetro contém o caractere de separação de diretórios
echo !input! | findstr "\\" >nul 2>&1 || echo !input! | findstr "/" >nul 2>&1
if %errorlevel% neq 0 (   
    rem Parâmetro não contém caractere de separação de diretórios, usar variável armazenada
    set OCODE_VAR=!input!
    set IS_FOLDER=0
  ) else (
    set "OCODE_DIR=%~1"
    set IS_FOLDER=1
    for %%i in ("%input%") do set "last_folder=%%~nxi"
  )

for %%i in ("%input%") do set "last_folder=%%~nxi"

if %IS_FOLDER% equ 0 (
echo Trying to Open: !%OCODE_VAR%!
  cd /d !%OCODE_VAR%!
) else (
echo Trying to Open: %OCODE_DIR%
  cd /d %OCODE_DIR%
)

if %errorlevel% neq 0 (
  if %IS_FOLDER% neq 0 (
    echo Erro: o diretorio informado nao existe ou nao pode ser acessado.
  ) else (
    echo Erro: a variavel informada nao existe.
  )
  goto fim
) else (  
  if %IS_FOLDER% equ 1 (
    setx %last_folder% %OCODE_DIR%
  )
)

if %errorlevel% equ 0 if %IS_FOLDER% equ 1 (
    echo Saved as %last_folder% restart the command line.
    echo Try 'ocode %last_folder%' next time.
)

rem Abrir o Visual Studio Code
code .

rem Retornar para o caminho anterior
cd /d %OCODE_DIR%

:fim
