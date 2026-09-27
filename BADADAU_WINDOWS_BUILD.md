# Compilación e Instalación de Badadau en Windows

Este documento detalla los pasos para compilar, empaquetar e instalar **Badadau** en sistemas Microsoft Windows.

---

## 1. Modos de Compilación Disponibles

Badadau ofrece dos rutas principales para generar el ejecutable de Windows:

1. **Compilación Cruzada desde Linux (Recomendado para CI/Packaging)**:
   Utilizando las herramientas de compilación de Waf y MSYS2/MinGW de 64 bits (`tools/x-win/compile.sh` y `tools/x-win/package.sh`).
2. **Compilación Nativa en Windows con MSVC / Visual Studio**:
   Utilizando la solución MSVC en el directorio `MSVCardour3/` y los encabezados adicionales `msvc_extra_headers/`.

---

## 2. Guía Paso a Paso: Compilación Cruzada con MinGW (Linux / WSL)

### Prerrequisitos
En una distribución de Linux basada en Debian/Ubuntu o WSL2:
```bash
sudo apt-get update
sudo apt-get install -y mingw-w64 gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 nsis
```

### Configuración e Instalación de Dependencias MinGW
Ejecuta la configuración orientada a Windows:
```bash
./configure-badadau.sh --build-target=mingw
```

### Compilación y Generación del Paquete Instalador
```bash
./waf
./tools/x-win/package.sh
```
Esto generará el paquete instalador comprimido de Windows o ejecutable NSIS en el directorio `build/` o `setup/` con el nombre `Badadau-9.8.0-x86_64.exe`.

---

## 3. Guía Paso a Paso: Compilación Nativa en Windows con Visual Studio

1. Abre **Visual Studio 2022** (o superior) con las cargas de trabajo de desarrollo en C++ instaladas.
2. Abre el archivo de solución `MSVCardour3/ardour3.sln`.
3. Selecciona la configuración de compilación `Release` y la plataforma `x64`.
4. Asegúrate de incluir las rutas de encabezados `msvc_extra_headers/` en el proyecto.
5. Haz clic en **Compilar solución** (*Build Solution*).

---

## 4. Directorios de Configuración y Perfiles en Windows

Badadau mantiene sus perfiles y ajustes aislados de Ardour en Windows:

* **Ajustes de Usuario y Preferencias**:
  `%LOCALAPPDATA%\badadau9\` (ej. `C:\Users\<Usuario>\AppData\Local\badadau9\`)
* **Archivos de Configuración del Servidor de Audio / ASIO**:
  `%LOCALAPPDATA%\badadau9\badadau_system_config`

---

## 5. Probar y Ejecutar en Windows

1. Ejecuta `Badadau.exe` desde la carpeta de instalación o el acceso directo del escritorio.
2. Al iniciar por primera vez, selecciona el controlador de audio deseado:
   - **WASAPI**: Baja latencia predeterminada sin drivers adicionales.
   - **ASIO**: Recomendado si utilizas una interfaz de audio dedicada (Focusrite, Behringer, Universal Audio, etc.).
   - **JACK / Dummy**: Para pruebas sin hardware de audio activo.
