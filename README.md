🚀 RAM HARDCORE (PURGE v1.0)
El script de optimización y liberación de memoria más agresivo y seguro para Windows 10/11.

    "No solo liberas RAM, recuperas el control de tu PC."

License: MITPlatform: WindowsYouTube: kode0420
📋 Tabla de Contenidos

    ¿Qué es RAM HARDCORE?
    Resultados en Tiempo Real
    Anatomía del Script: ¿Qué hace exactamente?
    ¿Es seguro? (Transparencia Total)
    Guía de Instalación y Uso
    Video de Demostración
    Contribuciones y Soporte

🧠 ¿Qué es RAM HARDCORE?

RAM HARDCORE (bautizado internamente como PURGE v1.0) es un script de optimización diseñado para usuarios de Windows que sufren de cuellos de botella por consumo excesivo de memoria RAM. A diferencia de los "optimizadores" milagrosos de dudosa procedencia, este script utiliza comandos nativos del sistema y técnicas de gestión de memoria a bajo nivel para forzar la liberación de cachés, "Working Sets" y procesos zombies que consumen tus recursos.

Ideal para:

    Gamers que necesitan el máximo FPS antes de lanzar títulos pesados.
    Creadores de contenido editando video/audio.
    PCs antiguas que necesitan un respiro.-Usuarios con tabs de Chrome abiertos hasta en la barra de tareas.

📊 Resultados en Tiempo Real

No prometemos magia, mostramos datos reales. Al ejecutar PURGE v1.0, el script genera un reporte en tiempo real. Este es un extracto de un log generado en una máquina de pruebas:

========================================      PURGE v1.0 - REPORTE DE OPTIMIZACIÓN========================================Sistema Operativo: Windows 10 Pro[+] Iniciando purga de memoria...[+] Forzando liberación de Working Sets...[+] Limpiando caché de DNS y File System...[+] Finalizando procesos en segundo plano no críticos...--- ESTADÍSTICAS DE RAM ---RAM Inicial:  8429 MB en usoRAM Final:    9443 MB disponibles (Liberados)RECUPERACIÓN: 1014 MB ¡Liberados con éxito!========================================

⚙️ Anatomía del Script: ¿Qué hace exactamente?

Para que sepas exactamente qué estás ejecutando en tu PC (transparencia 100%), aquí te detallo las funciones principales del script:

    Purga de Working Sets (EmptyWorkingSet):
    El núcleo de RAM HARDCORE. Utiliza llamadas a la API de Windows para forzar a las aplicaciones en ejecución a vaciar su memoria "no esencial" (Working Set) al archivo de paginación. Esto libera GBs de RAM al instante sin cerrar tus programas.

    Limpieza de Caché del Sistema (FlushSystemCaches):
    Ordena al sistema operativo vaciar la memoria caché de archivos y la lista de páginas en espera (Standby List), devolviendo esa memoria al pool disponible.

    Gestión Agresiva de Procesos (Opcional/Terminación Segura):
    Identifica y finaliza procesos en segundo plano que consumen RAM innecesariamente (servicios de telemetría de Windows, actualizaciones en pausa, procesos zombies). Nota: Nunca toca procesos críticos del sistema (System, smss.exe, csrss.exe) para evitar pantallazos azules (BSOD).

    Limpieza de File System y DNS:
    Ejecuta ipconfig /flushdns y limpia los iconos en caché para aliviar la carga del explorador de Windows (explorer.exe), haciendo que el sistema responda más fluido.

    Generador de Log (PURGE_Log.txt):
    Crea un archivo de texto detallado (como el que ves en la introducción) con el antes y después de la memoria RAM, para que puedas comprobar la efectividad del script.

🛡️ ¿Es seguro? (Transparencia Total)

SÍ. Este proyecto es de código abierto bajo licencia MIT. 

     No contiene malware, troyanos ni minería de criptomonedas.
     No recopila datos personales (telemetría cero).
     Puedes revisar el código línea por línea en este mismo repositorio. Si no confías en el ejecutable o script, ¡lee el código y compílalo tú mismo!

🛠️ Guía de Instalación y Uso

Sigue estos pasos para optimizar tu PC en segundos:

    Ve a la carpeta principal de este repositorio.
    Descarga el archivo RAM-HARDCORE.bat (o el .ps1 dependiendo de tu versión).
    Haz clic derecho sobre el archivo descargado y selecciona "Ejecutar como Administrador" (Obligatorio para limpiar la memoria del sistema).
    Observa cómo la consola hace su magia y revisa el reporte final.
    ¡Listo! Tu PC ahora tiene memoria libre para las tareas pesadas.

🎬 Video de Demostración

¿Quieres ver cómo se instala y funciona en tiempo real? He preparado un video exclusivo en mi canal de YouTube explicando su desarrollo y poniéndolo a prueba en una PC saturada.

👉 HAZ CLIC AQUÍ PARA VER EL VIDEO EN YOUTUBE
(Reemplaza este enlace con el URL de tu video)

¡No olvides suscribirte y dejar tu like si el script te sirvió!
🤝 Contribuciones y Soporte

Este script está en constante evolución. Si encuentras un bug, tienes ideas para liberar más RAM o quieres aportar al código:

    Abre un "Issue" en este repositorio.
    Haz un "Fork", modifica el código y envía un "Pull Request".

Creador: @kode0420

¡Gracias por confiar en RAM HARDCORE!
text
 
  
