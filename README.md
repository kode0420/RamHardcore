RAM HARDCORE (PURGE v1.0)
Script avanzado de optimización y liberación agresiva de memoria para Windows 10/11.

License: MITPlatform: WindowsYouTube: kode0420

    Propósito: Forzar la liberación de memoria caché, "Working Sets" y procesos en segundo plano no críticos para recuperar el máximo rendimiento del sistema de forma inmediata.

Tabla de Contenidos

    Descripción del Proyecto
    Evidencia de Rendimiento
    Anatomía Técnica del Script
    Política de Seguridad y Transparencia
    Guía de Instalación
    Demostración en Video
    Soporte y Contribuciones

Descripción del Proyecto

RAM HARDCORE (motor de purga v1.0) es una herramienta de optimización de sistema diseñada para usuarios de Windows que experimentan cuellos de botella por consumo excesivo de RAM. A diferencia de los optimizadores comerciales de dudosa procedencia, este script utiliza comandos nativos del sistema y llamadas a la API de Windows para gestionar la memoria a bajo nivel.

Casos de uso ideales:

    Preparación de entorno antes de lanzar videojuegos pesados (Maximizar FPS).
    Sistemas operativos saturados tras sesiones prolongadas de uso.
    Equipos de gama media/baja que requieren liberación constante de recursos.
    Estaciones de trabajo para edición de video, audio o renderizado 3D.

Evidencia de Rendimiento

El script genera un reporte de estado en tiempo real. A continuación, se muestra un extracto del log generado en un entorno de prueba estándar:

========================================      PURGE v1.0 - REPORTE DE OPTIMIZACIÓN========================================Sistema Operativo: Windows 10 Pro[+] Iniciando purga de memoria...[+] Forzando liberación de Working Sets...[+] Limpiando caché de DNS y File System...[+] Finalizando procesos en segundo plano no críticos...--- ESTADÍSTICAS DE RAM ---RAM Inicial:  8429 MB en usoRAM Final:    9443 MB disponibles (Liberados)RECUPERACIÓN: 1014 MB ¡Liberados con éxito!========================================

Anatomía Técnica del Script

Para garantizar la transparencia total, a continuación se detalla el comportamiento exacto del código al ejecutarse en su sistema:
Función
	
Descripción Técnica
Purga de Working Sets	Invoca la API de Windows para forzar a las aplicaciones en ejecución a vaciar su memoria no esencial (Working Set) al archivo de paginación, liberando RAM física sin cerrar programas.
FlushSystemCaches	Ordena al kernel vaciar la memoria caché del sistema de archivos y la lista de páginas en espera (Standby List), devolviendo la memoria al pool disponible.
Gestión de Procesos	Identifica y finaliza servicios en segundo plano innecesarios (telemetría, procesos zombies). Se omite la terminación de procesos críticos del sistema para prevenir BSOD (Pantallazos Azules).
Limpieza de Red y FS	Ejecuta ipconfig /flushdns y purga la caché de iconos del explorador para restaurar la fluidez de la interfaz de Windows.
Generador de Log	Crea un archivo de texto plano documentando las métricas de memoria antes y después de la ejecución para auditoría del usuario.
  
Política de Seguridad y Transparencia

Este proyecto es 100% Open Source bajo licencia MIT.

     Cero Telemetría: El script no recopila, almacena ni transmite datos personales.
     Código Abierto: No contiene binarios ofuscados. Puede revisar el código línea por línea en este repositorio.
     Sin Malware: No incluye mineros de criptomonedas, troyanos ni software de terceros.

Si tiene dudas de seguridad, lo invitamos a revisar el código fuente antes de su ejecución.
Guía de Instalación

Siga estos pasos para implementar el optimizador en su equipo:

    Diríjase a la sección de archivos de este repositorio.
    Descargue el archivo RAM HARDCORE.zip.
    Extraiga el contenido del archivo .zip en una carpeta de su preferencia.
    Haga clic derecho sobre el archivo ejecutable/script y seleccione "Ejecutar como Administrador" (Permiso obligatorio para acceder a la gestión de memoria del kernel).
    Espere a que la consola finalice las instrucciones y revise el reporte de memoria recuperada.

Demostración en Video

Para comprender el funcionamiento interno del script y visualizar su impacto en tiempo real, hemos documentado una prueba de estrés en nuestro canal de YouTube. 

Ver tutorial y prueba de rendimiento en YouTube
(Reemplace este enlace con el URL de su video)
Soporte y Contribuciones

RAM HARDCORE es un proyecto en evolución constante. 

     Para reportar bugs: Abra un nuevo "Issue" detallando su versión de Windows y el comportamiento presentado.
     Para contribuir: Realice un "Fork" del repositorio, aplique sus mejoras en una rama separada y envíe un "Pull Request" para revisión.

Autor: @kode0420
