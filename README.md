<div align="center">

# ⚡ RAM HARDCORE (PURGE v1.0) ⚡
<h2>🚀 El Script Definitivo para Liberar Memoria en Windows 10/11 🚀</h2>

**¿Tu PC va lenta? ¿Juegos con lag? ¡Recupera tu RAM al instante y de forma agresiva!**

<br>

<img src="https://img.shields.io/badge/Versión-1.0-9cf?style=for-the-badge&logo=github" alt="Version">
<img src="https://img.shields.io/badge/Plataforma-Windows%2010%2F11-blue?style=for-the-badge&logo=windows" alt="Platform">
<img src="https://img.shields.io/badge/Licencia-MIT-success?style=for-the-badge&logo=opensourceinitiative" alt="License">
<img src="https://img.shields.io/badge/YouTube-kode0420-red?style=for-the-badge&logo=youtube" alt="YouTube">

<br>
<hr style="border: 1px solid #333;">

</div>

## 📌 Tabla de Contenidos
1. [🧠 ¿Qué es RAM HARDCORE?](#-qué-es-ram-hardcore)
2. [📊 Evidencia de Rendimiento](#-evidencia-de-rendimiento)
3. [⚙️ Anatomía Técnica (¿Qué hace?)](#-anatomía-técnica-qué-hace)
4. [🛡️ Seguridad y Transparencia](#-seguridad-y-transparencia)
5. [⬇️ Guía de Instalación](#-guía-de-instalación)
6. [🎥 Video de Demostración](#-video-de-demostración)

<br>

## 🧠 ¿Qué es RAM HARDCORE?

**RAM HARDCORE** (motor de purga `PURGE v1.0`) no es un "optimizador milagro" más. Es un script de alto rendimiento diseñado para forzar a Windows a liberar la memoria que está reteniendo innecesariamente. 

Utiliza llamadas a la API del sistema y comandos nativos a bajo nivel para limpiar "Working Sets", cachés y procesos en segundo plano que están consumiendo tus recursos.

#### 🎯 Ideal para:
- 🎮 **Gamers:** Maximiza tus FPS liberando RAM antes de lanzar juegos pesados.
- 🎬 **Creadores de Contenido:** Evita crasheos en Premiere, OBS o DaVinci.
- 💻 **PCs Antiguas:** Dale una segunda vida a equipos con poca memoria.
- 🌐 **Usuarios Extremos:** Cierra cientos de pestañas de Chrome sin que el sistema muera en el intento.

<br>

## 📊 Evidencia de Rendimiento

No prometemos magia, mostramos **datos reales**. Al ejecutar el script, se genera un reporte en vivo. Así se vio en nuestra última prueba de estrés:

```text
========================================
      ⚡ PURGE v1.0 - REPORTE DEL SISTEMA ⚡
========================================
Sistema Operativo: Windows 10 Pro
[+] Iniciando purga de memoria...
[+] Forzando liberación de Working Sets...
[+] Limpiando caché de DNS y File System...
[+] Finalizando procesos en segundo plano no críticos...

--- 📈 ESTADÍSTICAS DE RAM ---
RAM Inicial:  8429 MB en uso
RAM Final:    9443 MB disponibles
RECUPERACIÓN: 1014 MB ¡Liberados con éxito! ✅
========================================
<br>

⚙️ Anatomía Técnica del Script

Para garantizar la transparencia total, a continuación se detalla el comportamiento exacto del código al ejecutarse en su sistema. Cero caja negra, sabes exactamente qué hace cada línea:
⚙️ Función
	
💡 Descripción Técnica
🧹 Purga de Working Sets	Invoca la API de Windows (EmptyWorkingSet) para forzar a las aplicaciones en ejecución a vaciar su memoria no esencial al archivo de paginación. Libera GBs de RAM física sin cerrar programas.
🧊 FlushSystemCaches	Ordena al kernel vaciar la memoria caché del sistema de archivos y la lista de páginas en espera (Standby List), devolviendo la memoria al pool disponible.
🔪 Gestión Agresiva de Procesos	Identifica y finaliza servicios en segundo plano innecesarios (telemetría, procesos zombies). Omite la terminación de procesos críticos (System, smss.exe, csrss.exe) para prevenir BSOD (Pantallazos Azules).
🌐 Red & File System	Ejecuta ipconfig /flushdns y purga la caché de iconos del explorador (explorer.exe) para restaurar la fluidez de la interfaz de Windows.
📝 Generador de Log	Crea un archivo de texto plano (PURGE_Log.txt) documentando las métricas de memoria antes y después de la ejecución para auditoría del usuario.
  
<br>

🛡️ Política de Seguridad y Transparencia

¡SÍ, ES 100% SEGURO Y DE CÓDIGO ABIERTO! 🟢

Este proyecto está bajo licencia MIT. Puede revisar el código línea por línea en este repositorio.

     ❌ Cero Malware: No contiene mineros de criptomonedas, troyanos ni software de terceros.
     ❌ Cero Telemetría: El script no recopila, almacena ni transmite datos personales a ningún servidor.
     ✅ Transparencia Total: Si tiene dudas de seguridad, lo invitamos a leer el código fuente antes de su ejecución. ¡Compílelo usted mismo si lo desea!

<br>

⬇️ Guía de Instalación y Uso

Siga estos pasos simples para implementar el optimizador en su equipo y recuperar su memoria en segundos:

    📥 Diríjase a la sección de archivos de este repositorio y descargue el archivo RAM HARDCORE.zip.
    📁 Extraiga el contenido del archivo .zip en una carpeta de su preferencia.
    🖱️ Haga Clic Derecho sobre el archivo ejecutable/script y seleccione "Ejecutar como Administrador" (Permiso obligatorio para acceder a la gestión de memoria del kernel).
    ⏳ Espere a que la consola finalice las instrucciones y observe el reporte de memoria recuperada.
    ✅ ¡Listo! Tu PC ahora tiene memoria libre para las tareas pesadas.

<br>

🎥 Video de Demostración

Para comprender el funcionamiento interno del script y visualizar su impacto en tiempo real, he preparado un video exclusivo en mi canal de YouTube. Puse a prueba el script en una PC totalmente saturada para que veas los resultados.
<div align="center">

👇 ¡HAZ CLIC AQUÍ PARA VER EL VIDEO! 👇

![Ver Video en YouTube](https://img.shields.io/badge/▶️ VER%20VIDEO%20EN%20YOUTUBE-FF0000?style=for-the-badge&logo=youtube&logoColor=white)
</div>

     

    ¡No olvides suscribirte y dejar tu like si el script te sirvió! Tu apoyo mantiene vivo el proyecto.

<br>

🤝 Soporte y Contribuciones

RAM HARDCORE es un proyecto en evolución constante. Su ayuda es bienvenida para mejorar la eficiencia del código.

     🐛 Para reportar bugs: Abra un nuevo "Issue" detallando su versión de Windows y el comportamiento presentado.
     🛠️ Para contribuir: Realice un "Fork" del repositorio, aplique sus mejoras en una rama separada y envíe un "Pull Request" para revisión.

<br>

<div align="center">

⭐ Creado con dedicación por @kode0420 ⭐

¡Gracias por confiar en RAM HARDCORE!
</div>
```
