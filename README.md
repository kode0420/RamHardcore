<div align="center">

# 🔥 RAM HARDCORE

### Optimizador de Rendimiento Extremo para Windows 10

Libera RAM, vacía caché del sistema, cierra procesos innecesarios y exprime cada MB disponible — con un solo clic.

![Platform](https://img.shields.io/badge/platform-Windows%2010-0078D6?style=flat-square&logo=windows)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Version](https://img.shields.io/badge/version-1.0-orange?style=flat-square)

[Instalación](#-instalación) · [Cómo usar](#-cómo-usar) · [Personalización](#-personalización) · [FAQ](#-preguntas-frecuentes)

</div>

---

## 📋 Tabla de contenidos

- [Qué es RAM HARDCORE](#-qué-es-ram-hardcore)
- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Cómo usar](#-cómo-usar)
- [Qué hace paso a paso](#-qué-hace-paso-a-paso)
- [Personalización](#-personalización)
- [Notas importantes y seguridad](#-notas-importantes-y-seguridad)
- [Detalles técnicos](#-detalles-técnicos)
- [Preguntas frecuentes](#-preguntas-frecuentes)
- [Licencia](#-licencia)

---

## 🎯 Qué es RAM HARDCORE

**RAM HARDCORE** es un script para Windows 10 que fuerza al sistema a liberar memoria RAM, caché de disco y memoria de video que normalmente queda atascada en segundo plano. No es un "limpiador" cosmético que solo borra accesos directos — ejecuta las mismas técnicas de bajo nivel que usan herramientas como RAMMap de Microsoft Sysinternals, combinadas con limpieza de caché, gestión de servicios y tweaks de rendimiento, todo automatizado en un solo clic.

Pensado para gamers, creadores de contenido y cualquiera que quiera exprimir hardware limitado sin comprar RAM nueva.

🎥 Video de presentación: *(link aquí)*

---

## 🚀 Características

| Módulo | Qué hace |
|---|---|
| 🧠 **Working Set Trim** | Libera la RAM física retenida por *todos* los procesos activos, sin cerrar ninguno |
| 🗑️ **Cierre de procesos** | Termina automáticamente ~25 procesos de fondo innecesarios (OneDrive, Cortana, updaters, telemetría de GPU) |
| 💾 **Purga de Standby List** | Vacía la caché de RAM de Windows a nivel de kernel (misma técnica que RAMMap) |
| 🧹 **Limpieza de caché** | TEMP, caché de Windows Update, Delivery Optimization, miniaturas, DNS, portapapeles y papelera |
| 🎮 **Reset de GPU** | Fuerza al driver de video a soltar memoria huérfana |
| ⚙️ **Gestión de servicios** | Detiene Superfetch, telemetría e indexado sin romper dependencias |
| ⚡ **Perfil de rendimiento** | Plan de energía Alto Rendimiento + prioridad MMCSS para juegos |
| 📊 **Reporte automático** | RAM antes/después en MB reales + log `.txt` por cada ejecución |

---

## 📋 Requisitos

- Windows 10 (build 1809 o superior)
- PowerShell 5.1 o superior (ya viene preinstalado en Windows 10)
- Permisos de administrador
- ~10 segundos de tu tiempo

---

## 📥 Instalación

1. Descarga **[RAM HARDCORE.zip](RAM%20HARDCORE.zip)** de este repositorio, o el botón verde **Code → Download ZIP**
2. Extrae el contenido en cualquier carpeta (Escritorio, Descargas, donde quieras)
3. Listo — no requiere instalación ni dependencias externas

```
RAM-HARDCORE/
├── KODE420-PURGE.bat   ← ejecutas este
├── KODE420-PURGE.ps1   ← motor del script, no lo toques directo
├── LICENSE
└── README.md
```

---

## 🎮 Cómo usar

1. Doble clic en **`KODE420-PURGE.bat`**
2. Windows pedirá permisos de administrador (UAC) — acepta
3. El script corre solo: verás cada paso en tiempo real con código de colores
4. Al final se muestra la RAM liberada y se guarda un reporte `.txt` en la misma carpeta

No hay botones que apretar ni configuración que llenar. Un clic, unos segundos, listo.

> ⚠️ **Windows SmartScreen** puede marcarlo como "no reconocido" la primera vez, porque es un script sin firma digital — normal en herramientas independientes que no pagan un certificado de firma de código. Click en **Más información → Ejecutar de todas formas**.

---

## 🔍 Qué hace paso a paso

<details>
<summary><b>1️⃣ Libera RAM de todos los procesos activos</b></summary>
<br>

Usa la API `EmptyWorkingSet` de Windows sobre cada proceso corriendo en el sistema. Esto no cierra nada: simplemente le pide a cada proceso que devuelva las páginas de memoria que no está usando activamente en ese momento. Los procesos siguen corriendo normal.
</details>

<details>
<summary><b>2️⃣ Cierra procesos de fondo innecesarios</b></summary>
<br>

Termina una lista curada de procesos que casi nunca necesitas activos: OneDrive, Cortana, updaters de Adobe/Google/Edge, telemetría de NVIDIA/AMD, Xbox Game Bar, etc. La lista es editable — ver [Personalización](#-personalización).
</details>

<details>
<summary><b>3️⃣ Purga la Standby List y Modified Page List</b></summary>
<br>

Esta es la parte "hardcore": usa `NtSetSystemInformation` (API interna de Windows) para vaciar la caché de RAM que el sistema guarda "por si acaso" — es la misma memoria que el Administrador de tareas muestra como "En caché" y que mucha gente confunde con RAM realmente ocupada. Es exactamente lo que hace el botón "Empty Standby List" de RAMMap, herramienta oficial de Microsoft Sysinternals.
</details>

<details>
<summary><b>4️⃣ Limpieza de caché en disco</b></summary>
<br>

Vacía, en orden: TEMP de usuario, TEMP de Windows, caché de descargas de Windows Update, caché de Delivery Optimization, caché de miniaturas (con reinicio de Explorer), caché DNS, portapapeles y papelera de reciclaje. El reporte muestra cuántos MB liberó cada una.
</details>

<details>
<summary><b>5️⃣ GPU: reset de driver</b></summary>
<br>

Windows no tiene un comando nativo para "vaciar la VRAM" como si fuera RAM del sistema — eso no existe a nivel de SO para ningún fabricante de GPU. Lo más cercano y real es forzar un reset del driver de pantalla (el mismo mecanismo detrás del atajo `Ctrl+Win+Shift+B`), que suelta memoria de video huérfana dejada por procesos que ya cerraron. La pantalla puede parpadear un instante — es normal.
</details>

<details>
<summary><b>6️⃣ Detiene servicios no críticos</b></summary>
<br>

Pasa a modo **Manual** (no Disabled) servicios como SysMain/Superfetch, DiagTrack (telemetría), WSearch (indexado) y otros que solo consumen RAM en segundo plano. Manual significa que quedan apagados pero disponibles si algo los necesita — no rompe nada.
</details>

<details>
<summary><b>7️⃣ Aplica perfil de rendimiento</b></summary>
<br>

Cambia el plan de energía a **Alto Rendimiento**, ajusta los efectos visuales a "mejor rendimiento", y prioriza el scheduler multimedia (MMCSS) para juegos y la app en primer plano.
</details>

<details>
<summary><b>8️⃣ Reporte final</b></summary>
<br>

Muestra RAM libre antes/después en MB reales, cuántos procesos se liberaron/cerraron y el tiempo total de ejecución, y guarda todo en un `.txt` con timestamp en la misma carpeta del script.
</details>

---

## 🔧 Personalización

Todo es editable al inicio de `KODE420-PURGE.ps1`, sin tocar el resto del código:

```powershell
# Agrega o comenta procesos segun lo que uses
$BloatProcesses = @(
    'OneDrive', 'Cortana', 'Teams', ...
)

# Servicios que se pasan a Manual
$ServicesToOptimize = @(
    @{Name='SysMain'; Desc='Superfetch/Prefetch'},
    ...
)

# Activa o desactiva el cambio de efectos visuales
$DisableVisualEffects = $true
```

Si usas activamente algo de la lista de procesos (ej. Spotify, Discord), simplemente borra o comenta esa línea.

---

## 🔒 Notas importantes y seguridad

- ✅ **Reversible:** plan de energía, efectos visuales y servicios (pasan a Manual, se reactivan desde `services.msc` cuando quieras)
- ❌ **No reversible:** los archivos en TEMP y la papelera de reciclaje se borran de forma permanente
- 🛡️ No modifica Windows Defender, Firewall ni Windows Update de forma permanente — nunca toca la seguridad del sistema
- 🔁 Seguro de ejecutar las veces que quieras, no acumula efectos raros entre corridas
- 🧩 El código está a la vista en `KODE420-PURGE.ps1` — revísalo antes de correrlo si quieres, no hay nada oculto ni ofuscado

---

## 🧠 Detalles técnicos

- Escrito 100% en PowerShell, con un bloque de C# embebido (`Add-Type`) para las llamadas a la API de Windows (`psapi.dll`, `ntdll.dll`, `advapi32.dll`, `user32.dll`)
- Auto-elevación de permisos incluida — no necesitas clic derecho → Ejecutar como administrador
- Manejo de errores en cada paso: si algo falla en un build específico de Windows, el script avisa y continúa en vez de romperse
- Sin dependencias externas, sin telemetría propia, sin conexión a internet

---

## ❓ Preguntas frecuentes

**¿Funciona en Windows 11?**
No está probado ahí. Está hecho y probado específicamente para Windows 10.

**¿Por qué pide permisos de administrador?**
Varias operaciones (purgar la Standby List, tocar servicios del sistema, cambiar el plan de energía) requieren privilegios elevados por diseño de Windows, no por el script en sí.

**¿Va a "romper" algo?**
No. Todo lo que se apaga es no crítico y reversible, y el código está abierto para que lo audites tú mismo.

**¿Cuánta RAM libera realmente?**
Depende de cuánto tenías abierto y cuánta "basura" acumulada tenía tu sistema. La ganancia real se ve en el reporte que genera cada ejecución.

---

## 📄 Licencia

MIT — úsalo, modifícalo, compártelo. Ver [LICENSE](LICENSE).

---

<div align="center">

Hecho por **KODE420** 🎬

⭐ Si te sirvió, dale estrella al repo

</div>
