@echo off
:: ─────────────────────────────────────────────────────────
::  GH30 — Arrancador rápido para Windows
::  Haz doble clic en este archivo para iniciar el backend
::  Colócalo en:  gh30\backend\GH30_arrancar.bat
:: ─────────────────────────────────────────────────────────

title GH30 — Agente Verde Backend

echo.
echo  ====================================
echo    GH30 Green House 2030 - Backend
echo  ====================================
echo.

:: Verifica que Python esté disponible
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no encontrado en el PATH.
    echo Reinstala Python 3.10 marcando "Add to PATH".
    pause
    exit /b 1
)

:: Va a la carpeta donde está este archivo
cd /d "%~dp0"

:: Carga variables de entorno
if not exist .env (
    echo [ERROR] No se encontro el archivo .env
    echo Crea el archivo .env en esta carpeta con tu configuracion.
    pause
    exit /b 1
)

echo [OK] Archivo .env encontrado
echo [OK] Iniciando backend en http://localhost:8000
echo.
echo  Endpoints disponibles:
echo   - http://localhost:8000/health    Estado del sistema
echo   - http://localhost:8000/docs      Documentacion API
echo   - http://localhost:8000/api/chat  Agente Verde IA
echo.
echo  Para usar la app: abre frontend\index.html en el navegador
echo  Para detener:     presiona Ctrl+C en esta ventana
echo.

:: Inicia el servidor
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause
