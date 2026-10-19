
@echo off
setlocal EnableExtensions
chcp 65001 >nul
title NodePortable - Gerenciador
color 0A

set "ROOT=%~dp0"
set "NODEDIR=%ROOT%node-v24.22.0-win-x64"
set "NODE=%NODEDIR%\node.exe"
set "NPM=%NODEDIR%\npm.cmd"
set "PROJETOS=%ROOT%projetos"
set "CACHE=%ROOT%cache"

if not exist "%PROJETOS%" mkdir "%PROJETOS%"
if not exist "%CACHE%" mkdir "%CACHE%"

if not exist "%NODE%" (
    echo ERRO: node.exe nao encontrado!
    echo Caminho esperado: "%NODE%"
    pause
    exit /b 1
)

set "PATH=%NODEDIR%;%PATH%"
set "npm_config_cache=%CACHE%"

:MENU
cls
echo ==========================================
echo          NODE PORTABLE v24
echo ==========================================
echo Pasta: %ROOT%
echo.
echo [1] Verificar Node.js e npm
echo [2] Executar arquivo JavaScript
echo [3] Instalar pacote npm
echo [4] Abrir terminal de projetos
echo [5] Listar arquivos de projetos
echo [6] Criar novo projeto
echo [7] Abrir pasta NodePortable
echo [8] Testar projetos
echo [9] Criar projeto React Native Expo
echo [10] Iniciar projeto Expo
echo [11] Instalar dependencias do projeto
echo [12] Verificar projeto Expo
echo [15] Criar projeto React Native CLI
echo [0] Sair
echo.
set "OP="
set /p "OP=Escolha: "

if "%OP%"=="1" goto VERSAO
if "%OP%"=="2" goto EXECUTAR
if "%OP%"=="3" goto PACOTE
if "%OP%"=="4" goto TERMINAL
if "%OP%"=="5" goto LISTAR
if "%OP%"=="6" goto CRIAR
if "%OP%"=="7" start "" "%ROOT%" & goto MENU
if "%OP%"=="8" goto TESTAR
if "%OP%"=="9" goto EXPO_CRIAR
if "%OP%"=="10" goto EXPO_INICIAR
if "%OP%"=="11" goto EXPO_INSTALAR
if "%OP%"=="12" goto EXPO_VERIFICAR
if "%OP%"=="15" goto RNCLI_CRIAR
if "%OP%"=="0" exit /b
goto MENU

:VERSAO
cls
echo === NODE.JS ===
"%NODE%" -v
echo.
echo === NPM ===
call "%NPM%" -v
echo.
pause
goto MENU

:EXECUTAR
cls
set "ARQ="
set /p "ARQ=Nome do arquivo JS em projetos: "
if not exist "%PROJETOS%\%ARQ%" (
    echo Arquivo nao encontrado!
    pause
    goto MENU
)
"%NODE%" "%PROJETOS%\%ARQ%"
echo.
pause
goto MENU

:PACOTE
cls
set "PAC="
set /p "PAC=Nome do pacote npm: "
if not defined PAC goto MENU
pushd "%PROJETOS%"
call "%NPM%" install "%PAC%"
popd
pause
goto MENU

:TERMINAL
start "Terminal NodePortable" /D "%PROJETOS%" cmd /k "set PATH=%NODEDIR%;%PATH%&& set npm_config_cache=%CACHE%"
goto MENU

:LISTAR
cls
dir /b "%PROJETOS%"
echo.
pause
goto MENU

:CRIAR
cls
set "NOME="
set /p "NOME=Nome do novo projeto: "
if not defined NOME goto MENU
if exist "%PROJETOS%\%NOME%" (
    echo Essa pasta ja existe!
    pause
    goto MENU
)
mkdir "%PROJETOS%\%NOME%"
pushd "%PROJETOS%\%NOME%"
call "%NPM%" init -y
popd
pause
goto MENU




:TESTAR
cls
echo ==========================================
echo         TESTAR PROJETO EXPO
echo ==========================================
echo.
echo Projetos disponiveis:
for /d %%D in ("%PROJETOS%\*") do (
    if exist "%%D\package.json" echo %%~nxD
)
echo.
set "NOME="
set /p "NOME=Digite o nome do projeto: "

if not defined NOME goto MENU

if not exist "%PROJETOS%\%NOME%\package.json" (
    echo.
    echo Projeto nao encontrado!
    pause
    goto MENU
)

cls
echo ==========================================
echo Iniciando projeto: %NOME%
echo ==========================================
echo.

pushd "%PROJETOS%\%NOME%"
call "%NODEDIR%\npx.cmd" expo start
popd

echo.
echo Expo encerrado.
pause
goto MENU



:EXPO_CRIAR
cls
echo ==========================================
echo       CRIAR PROJETO REACT NATIVE EXPO
echo ==========================================
echo.

set "NOME="
set /p "NOME=Nome do projeto (ex: MeuApp): "

if not defined NOME goto MENU

if exist "%PROJETOS%\%NOME%" (
    echo Essa pasta ja existe!
    pause
    goto MENU
)

pushd "%PROJETOS%"
echo.
echo Criando projeto Expo...
echo Isso pode demorar alguns minutos.
echo.

call "%NODEDIR%\npx.cmd" create-expo-app@latest "%NOME%"
set "RESULTADO=%ERRORLEVEL%"
popd

if not "%RESULTADO%"=="0" (
    echo.
    echo Falha ao criar o projeto.
    echo Confira a conexao com a internet.
    pause
    goto MENU
)

echo.
echo Projeto criado em:
echo %PROJETOS%\%NOME%
pause
goto MENU


:EXPO_INICIAR
cls
echo ==========================================
echo             INICIAR EXPO
echo ==========================================
echo.

set "NOME="
set /p "NOME=Nome da pasta do projeto: "

if not defined NOME goto MENU

if not exist "%PROJETOS%\%NOME%\package.json" (
    echo Projeto nao encontrado!
    pause
    goto MENU
)

pushd "%PROJETOS%\%NOME%"
echo.
echo Iniciando servidor Expo...
echo Pressione Ctrl+C para parar.
echo.

call "%NODEDIR%\npx.cmd" expo start

popd
pause
goto MENU


:EXPO_INSTALAR
cls
echo ==========================================
echo        INSTALAR DEPENDENCIAS EXPO
echo ==========================================
echo.

set "NOME="
set /p "NOME=Nome da pasta do projeto: "

if not defined NOME goto MENU

if not exist "%PROJETOS%\%NOME%\package.json" (
    echo Projeto nao encontrado!
    pause
    goto MENU
)

pushd "%PROJETOS%\%NOME%"
echo.
call "%NPM%" install
set "RESULTADO=%ERRORLEVEL%"
popd

echo.
echo Codigo de saida: %RESULTADO%
pause
goto MENU


:EXPO_VERIFICAR
cls
echo ==========================================
echo           VERIFICAR PROJETO EXPO
echo ==========================================
echo.

set "NOME="
set /p "NOME=Nome da pasta do projeto: "

if not defined NOME goto MENU

if not exist "%PROJETOS%\%NOME%\package.json" (
    echo Projeto nao encontrado!
    pause
    goto MENU
)

pushd "%PROJETOS%\%NOME%"
echo.
echo Executando Expo Doctor...
call "%NODEDIR%\npx.cmd" expo-doctor
set "RESULTADO=%ERRORLEVEL%"
popd

echo.
echo Codigo de saida: %RESULTADO%
pause
goto MENU


:RNCLI_CRIAR
cls
echo ==========================================
echo      CRIAR PROJETO REACT NATIVE CLI
echo ==========================================
echo.

set "NOME="
set /p "NOME=Nome do projeto (ex: MeuApp): "

if not defined NOME goto MENU

if exist "%PROJETOS%\%NOME%" (
    echo.
    echo Essa pasta ja existe!
    pause
    goto MENU
)

echo.
echo Verificando Node.js...
"%NODE%" -v

echo.
echo Criando projeto React Native CLI...
echo Isso pode demorar varios minutos.
echo.

pushd "%PROJETOS%"
call "%NODEDIR%\npx.cmd" @react-native-community/cli@latest init "%NOME%"
set "RESULTADO=%ERRORLEVEL%"
popd

if not "%RESULTADO%"=="0" (
    echo.
    echo ERRO ao criar o projeto.
    echo Confira a internet e as dependencias.
    pause
    goto MENU
)

echo.
echo ==========================================
echo Projeto criado com sucesso!
echo Pasta: %PROJETOS%\%NOME%
echo ==========================================
echo.
echo Para testar, use a opcao 14 do menu.
pause
goto MENU




:RNWEB_ERRO
echo.
echo ERRO durante a configuracao web.
echo A pasta do projeto foi mantida para diagnostico.
echo Consulte as mensagens anteriores.
popd
pause
goto MENU


