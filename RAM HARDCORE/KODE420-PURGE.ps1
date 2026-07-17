<#
================================================================================
  KODE420 PURGE v1.0
  Optimizador de Rendimiento para Windows 10

  Vacia el working set de todos los procesos, purga la Standby List de RAM,
  cierra procesos de fondo innecesarios, detiene servicios no criticos,
  limpia cache de disco (TEMP, Windows Update, miniaturas, DNS, papelera),
  fuerza un reset del driver de GPU y aplica tweaks de rendimiento
  (energia, efectos visuales, MMCSS).

  Requiere: Windows 10 (build 1809+), PowerShell 5.1+, permisos de Administrador.
  Uso: doble clic en KODE420-PURGE.bat. No ejecutes este .ps1 directamente
       salvo que sepas lo que haces con la politica de ejecucion.

  Nota: los mensajes evitan tildes/ene a proposito para prevenir problemas
  de codificacion en consolas de Windows con distinto codepage.
================================================================================
#>

# ------------------------------------------------------------------------------
# 0. AUTO-ELEVACION
# ------------------------------------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ErrorActionPreference = 'SilentlyContinue'
$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$ReportPath = Join-Path $ScriptRoot ("KODE420-PURGE-Report-{0}.txt" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
$Report = New-Object System.Collections.Generic.List[string]
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# ------------------------------------------------------------------------------
# 1. HELPERS DE SALIDA (estilo KODE420)
# ------------------------------------------------------------------------------
function Log($msg) { $Report.Add($msg) | Out-Null }
function Write-Sep  { Write-Host ('=' * 70) -ForegroundColor DarkGray }
function Write-Ok   ($m) { Write-Host "  [OK] $m" -ForegroundColor Green;  Log "[OK] $m" }
function Write-Info ($m) { Write-Host "  [i]  $m" -ForegroundColor Cyan;   Log "[INFO] $m" }
function Write-Warn ($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow; Log "[WARN] $m" }
function Write-Title($m) { Write-Host ""; Write-Sep; Write-Host " $m" -ForegroundColor Magenta; Write-Sep; Log "== $m ==" }

# ------------------------------------------------------------------------------
# 2. CONFIGURACION (editable)
# ------------------------------------------------------------------------------
# Procesos de fondo tipicamente innecesarios. Agrega o comenta segun lo que uses.
# Si usas Spotify o Discord activamente, no los agregues aqui.
$BloatProcesses = @(
    'OneDrive','Cortana','SearchApp','YourPhone','PhoneExperienceHost',
    'SkypeApp','SkypeBackgroundHost','Teams','GameBar','GameBarFTServer',
    'XboxAppServices','GamingServices','NVDisplay.Container','NvBackend',
    'RadeonSoftware','Widgets','WidgetService','OneDriveStandaloneUpdater',
    'MicrosoftEdgeUpdate','GoogleCrashHandler','GoogleUpdate',
    'Adobe ARM','AdobeIPCBroker','CCXProcess','CoreSync','OfficeClickToRun'
)

# Servicios no criticos. Se pasan a Manual (no Disabled) para no romper
# dependencias: quedan apagados pero disponibles si algo los necesita.
$ServicesToOptimize = @(
    @{Name='SysMain';       Desc='Superfetch/Prefetch'},
    @{Name='DiagTrack';     Desc='Telemetria de Windows'},
    @{Name='WSearch';       Desc='Indexado de busqueda'},
    @{Name='WMPNetworkSvc'; Desc='Compartir Windows Media Player'},
    @{Name='MapsBroker';    Desc='Descarga de mapas offline'},
    @{Name='lfsvc';         Desc='Geolocalizacion'},
    @{Name='RetailDemo';    Desc='Modo demo minorista'},
    @{Name='RemoteRegistry';Desc='Registro remoto'}
)

$DisableVisualEffects = $true

# ------------------------------------------------------------------------------
# 3. SNAPSHOT DE RAM
# ------------------------------------------------------------------------------
function Get-RAMStats {
    $os = Get-CimInstance Win32_OperatingSystem
    # TotalVisibleMemorySize y FreePhysicalMemory vienen en KB
    [PSCustomObject]@{
        TotalMB = [math]::Round($os.TotalVisibleMemorySize / 1024, 0)
        FreeMB  = [math]::Round($os.FreePhysicalMemory / 1024, 0)
    }
}

function Get-FolderMB($path) {
    if (Test-Path $path) {
        $sum = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        if ($sum) { [math]::Round($sum / 1MB, 1) } else { 0 }
    } else { 0 }
}

# ------------------------------------------------------------------------------
# 4. P/INVOKE: working set, standby list, privilegios, reset de GPU
# ------------------------------------------------------------------------------
$sig = @'
using System;
using System.Runtime.InteropServices;

public class KodeMem {
    [DllImport("psapi.dll")]
    public static extern bool EmptyWorkingSet(IntPtr hProcess);

    [DllImport("ntdll.dll")]
    public static extern int NtSetSystemInformation(int InfoClass, IntPtr Info, int Length);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool OpenProcessToken(IntPtr h, uint acc, out IntPtr tok);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool LookupPrivilegeValue(string sys, string name, out long luid);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool AdjustTokenPrivileges(IntPtr tok, bool disAll, ref TOKEN_PRIV newSt, uint len, IntPtr prevSt, IntPtr retLen);

    [DllImport("user32.dll")]
    public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);

    [StructLayout(LayoutKind.Sequential)]
    public struct TOKEN_PRIV {
        public uint Count;
        public long Luid;
        public uint Attr;
    }

    public static void EnablePrivilege(string priv) {
        IntPtr tok;
        OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x28, out tok);
        long luid;
        LookupPrivilegeValue(null, priv, out luid);
        TOKEN_PRIV tp = new TOKEN_PRIV();
        tp.Count = 1; tp.Luid = luid; tp.Attr = 0x2;
        AdjustTokenPrivileges(tok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
    }

    public static void PurgeStandbyList() {
        EnablePrivilege("SeProfileSingleProcessPrivilege");
        IntPtr p = Marshal.AllocHGlobal(4);
        Marshal.WriteInt32(p, 4); // MemoryPurgeStandbyList
        NtSetSystemInformation(80, p, 4); // SystemMemoryListInformation
        Marshal.FreeHGlobal(p);
    }

    public static void ResetGpuDriver() {
        byte VK_CONTROL = 0x11, VK_LWIN = 0x5B, VK_SHIFT = 0x10, VK_B = 0x42;
        uint KEYDOWN = 0, KEYUP = 2;
        keybd_event(VK_CONTROL, 0, KEYDOWN, UIntPtr.Zero);
        keybd_event(VK_LWIN, 0, KEYDOWN, UIntPtr.Zero);
        keybd_event(VK_SHIFT, 0, KEYDOWN, UIntPtr.Zero);
        keybd_event(VK_B, 0, KEYDOWN, UIntPtr.Zero);
        System.Threading.Thread.Sleep(100);
        keybd_event(VK_B, 0, KEYUP, UIntPtr.Zero);
        keybd_event(VK_SHIFT, 0, KEYUP, UIntPtr.Zero);
        keybd_event(VK_LWIN, 0, KEYUP, UIntPtr.Zero);
        keybd_event(VK_CONTROL, 0, KEYUP, UIntPtr.Zero);
    }
}
'@
Add-Type -TypeDefinition $sig -Language CSharp -ErrorAction SilentlyContinue

# ------------------------------------------------------------------------------
# 5. EJECUCION
# ------------------------------------------------------------------------------
Clear-Host
Write-Title "KODE420 PURGE v1.0 - Optimizador Windows 10"
Write-Info "Inicio: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

$before = Get-RAMStats
Write-Info "RAM libre antes: $($before.FreeMB) MB de $($before.TotalMB) MB"

Write-Title "1/8 - Liberando RAM de todos los procesos activos"
$trimmed = 0
Get-Process | ForEach-Object {
    try {
        if ([KodeMem]::EmptyWorkingSet($_.Handle)) { $trimmed++ }
    } catch {}
}
Write-Ok "Working sets liberados en $trimmed procesos"

Write-Title "2/8 - Cerrando procesos innecesarios en segundo plano"
$killed = 0
foreach ($name in $BloatProcesses) {
    $p = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($p) {
        $p | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Ok "Cerrado: $name"
        $killed++
    }
}
if ($killed -eq 0) { Write-Info "Ningun proceso de la lista estaba activo" }

Write-Title "3/8 - Purgando Standby List y Modified Page List (cache de RAM)"
try {
    [KodeMem]::PurgeStandbyList()
    Write-Ok "Standby List purgada (misma tecnica interna que usa RAMMap de Sysinternals)"
} catch {
    Write-Warn "No se pudo purgar la Standby List en este build de Windows"
}

Write-Title "4/8 - Vaciando cache y archivos temporales"
Write-Warn "Esta seccion borra TEMP y vacia la papelera de forma permanente"

$tempMB = Get-FolderMB $env:TEMP
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "TEMP de usuario: $tempMB MB liberados"

$winTempMB = Get-FolderMB "$env:windir\Temp"
Remove-Item "$env:windir\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Ok "TEMP de Windows: $winTempMB MB liberados"

Stop-Service wuauserv,bits -Force -ErrorAction SilentlyContinue
$wuMB = Get-FolderMB "$env:windir\SoftwareDistribution\Download"
Remove-Item "$env:windir\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service bits,wuauserv -ErrorAction SilentlyContinue
Write-Ok "Cache de Windows Update: $wuMB MB liberados"

Stop-Service DoSvc -Force -ErrorAction SilentlyContinue
Remove-Item "$env:windir\SoftwareDistribution\DeliveryOptimization\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service DoSvc -ErrorAction SilentlyContinue
Write-Ok "Cache de Delivery Optimization vaciada"

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Ok "Papelera de reciclaje vaciada"

Set-Clipboard -Value $null -ErrorAction SilentlyContinue
Write-Ok "Portapapeles limpiado"

try { Clear-DnsClientCache } catch { ipconfig /flushdns | Out-Null }
Write-Ok "Cache DNS vaciada"

Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe
Write-Ok "Cache de miniaturas vaciada, Explorer reiniciado"

Write-Title "5/8 - GPU: liberando memoria de video"
Write-Info "Windows no expone un comando nativo para vaciar VRAM directamente"
Write-Info "Se ejecuta el reset del driver de pantalla (equivalente a Ctrl+Win+Shift+B)"
try {
    [KodeMem]::ResetGpuDriver()
    Write-Ok "Reset de driver de GPU enviado (la pantalla puede parpadear un instante)"
} catch {
    Write-Warn "No se pudo enviar el reset de GPU"
}

Write-Title "6/8 - Deteniendo servicios no criticos"
foreach ($svc in $ServicesToOptimize) {
    $s = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
    if ($s) {
        if ($s.Status -eq 'Running') { Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue }
        Set-Service -Name $svc.Name -StartupType Manual -ErrorAction SilentlyContinue
        Write-Ok "$($svc.Desc) -> Manual"
    }
}

Write-Title "7/8 - Aplicando perfil de rendimiento"
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Write-Ok "Plan de energia: Alto rendimiento"

if ($DisableVisualEffects) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord
    Write-Ok "Efectos visuales -> ajustar para mejor rendimiento (puede requerir cerrar sesion)"
}

$mmPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $mmPath -Name "SystemResponsiveness" -Value 0 -Type DWord -ErrorAction SilentlyContinue
$gamesPath = "$mmPath\Tasks\Games"
if (-not (Test-Path $gamesPath)) { New-Item -Path $gamesPath -Force | Out-Null }
Set-ItemProperty -Path $gamesPath -Name "GPU Priority" -Value 8 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -ErrorAction SilentlyContinue
Write-Ok "MMCSS priorizado para juegos/foreground"

Write-Title "8/8 - Resultado final"
Start-Sleep -Seconds 1
$after = Get-RAMStats
$freed = $after.FreeMB - $before.FreeMB
$sw.Stop()

Write-Host ""
Write-Host "  RAM libre antes ..... $($before.FreeMB) MB" -ForegroundColor White
Write-Host "  RAM libre despues ... $($after.FreeMB) MB" -ForegroundColor White
if ($freed -ge 0) {
    Write-Host "  RAM recuperada ...... +$freed MB" -ForegroundColor Green
} else {
    Write-Host "  RAM recuperada ...... $freed MB (el sistema ya reasigno memoria)" -ForegroundColor Yellow
}
Write-Host "  Procesos con RAM liberada: $trimmed" -ForegroundColor White
Write-Host "  Procesos cerrados: $killed" -ForegroundColor White
Write-Host "  Tiempo total: $([math]::Round($sw.Elapsed.TotalSeconds,1)) s" -ForegroundColor White
Write-Sep

Log "RAM antes: $($before.FreeMB) MB | RAM despues: $($after.FreeMB) MB | Recuperado: $freed MB"
Log "Procesos liberados: $trimmed | Procesos cerrados: $killed | Duracion: $([math]::Round($sw.Elapsed.TotalSeconds,1))s"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8
Write-Info "Reporte guardado en: $ReportPath"
Write-Host ""
