# 📘 NALA-HWSensors v2.0 (`2.0.0-NCSP`) — Multilingual Factsheet, Install Guide & Architecture Handoff
### 🇩🇪 Deutsch · 🇫🇷 Français · 🇮🇹 Italiano · 🇨🇭 Rumantsch · 🇬🇧 English

---

## 🇩🇪 1. DEUTSCH — Factsheet, Installations-Guide & Übergabe-Dossier (Handoff)

### 1.1 Projekt-Zusammenfassung (Factsheet)
- **Produktname:** `NALA-HWSensors v2.0` (`2.0.0-NCSP`)
- **Zielplattformen:**
  1. **macOS (Apple Silicon M1/M2/M3/M4 Max/Ultra & Intel x86_64):** Native `IOHIDEventSystemClient` Die-/SoC-Temperatursensoren (45+ Sensoren ohne Root/Kext), `IOAccelerator` (Metal GPU-Auslastung, Tiler/Renderer, Unified VRAM), `AppleSmartBattery` (Watt, Volt, Ampere, Gesundheit), Menubar-Popover, Dock-Integration & Desktop-Widgets.
  2. **Windows 10/11 (x64 / ARM64):** Tauri v2 + Rust `sysinfo`, WMI, NVIDIA `NVML`, AMD `ADL` & `LibreHardwareMonitor` User-Space Bridge. System-Tray & frei platzierbare Desktop-Gadgets.
  3. **Ubuntu / Linux (22.04 / 24.04 LTS):** `/sys/class/hwmon/*`, `/sys/class/thermal/*`, `nvidia-smi`, `rocm-smi`, `smartctl` NVMe & ZFS Pool-Status. GNOME Top-Bar & Desktop-Widget-Modus.
  4. **NALA-OS (v6.6+ Appliance & Bento Desktop):** Native Integration als frei skalierbares Bento-Cockpit-Widget (`127.0.0.1`) inkl. **Katze-„Nala“-Thermik-Schutz (`Quiet/Eco-Thermal Envelope`)**.
- **Sicherheits-Garantie (`sHeriFF` + `NVIDIA SkillSpector` + `SHA-256`):**
  - **Dreifach-Prüfung (Triple-Check Gate)** vor jedem Git-Push: 0 % persönliche Daten (PII), 0 % lokale Pfade/IPs, 0 % API-Keys, 0 leere Images/DMGs/ISOs.
  - **Kryptografische Skin-Prüfung (`H-A-S-H`):** Jeder Skin in `skins/skins_manifest.json` und jeder Community-Skin (`.nala-skin.json`) wird per `SHA-256` verifiziert und durch `NVIDIA SkillSpector` auf Prompt-Injections, XSS, SSRF und Schadcode geprüft.

### 1.2 Installations-Anleitung (DE)
1. **macOS (Sofort-Start):** Doppelklick auf `Start_NALA_HWSensors_Mac.command` oder im Terminal `python3 macos/nala_hwsensors_daemon.py` starten. Öffnet das Live-Cockpit unter `http://127.0.0.1:8768`.
2. **Tauri v2 Native Build (macOS `.dmg` / Windows `.exe` / Ubuntu `.deb` & `.AppImage`):**
   ```bash
   python3 scripts/nala_hwsensors_sheriff_audit.py --strict
   cargo tauri build
   ```

---

## 🇫🇷 2. FRANÇAIS — Fiche Technique, Guide d'Installation & Dossier de Transfert

### 2.1 Résumé Exécutif (Factsheet)
- **Produit :** `NALA-HWSensors v2.0` (`2.0.0-NCSP`)
- **Plateformes :** macOS (Apple Silicon & Intel, barre de menus, Dock et widgets), Windows 10/11, Ubuntu Linux et NALA-OS.
- **Moteur de Skins & Widgets :** 7 skins signés (`Porsche v4 Cockpit` avec jauge de carburant pour SSD/NVMe et compte-tours CPU/GPU, `Terminator Skynet HUD`, `Umbrella Corporation`, `Matrix Construct`, `DOOM UAC`, `Liquid Glass`, `NALA-OS V6.6`). Tous les widgets sont déplaçables par glisser-déposer (Drag & Drop) et redimensionnables dynamiquement (25 % à 100 %).
- **Sécurité (`sHeriFF` + `NVIDIA SkillSpector` + `SHA-256`) :** Triple vérification automatique contre toute fuite de données personnelles (0 % PII, 0 % clés API, 0 % IP privées) et vérification cryptographique `SHA-256` de chaque skin communautaire contre les injections de prompts et malwares.

### 2.2 Guide d'Installation (FR)
1. **Exécuter l'audit de sécurité :** `python3 scripts/nala_hwsensors_sheriff_audit.py`
2. **Lancer le démon de capteurs :** `python3 macos/nala_hwsensors_daemon.py` (ou `cargo tauri build` pour générer les paquets `.dmg`, `.exe`, `.deb`).

---

## 🇮🇹 3. ITALIANO — Scheda Tecnica, Guida all'Installazione & Dossier di Consegna

### 3.1 Sintesi del Progetto (Factsheet)
- **Prodotto :** `NALA-HWSensors v2.0` (`2.0.0-NCSP`)
- **Piattaforme :** macOS (Apple Silicon M1–M4 Max & Intel, MenuBar, Dock e Widget Desktop), Windows 10/11, Ubuntu Linux e NALA-OS.
- **Skin Engine & Widget Dinamici :** 7 skin ufficiali firmati con hash `SHA-256` (incluso il cockpit `Porsche Design System v4` con indicatore del livello carburante per SSD/NVMe e tachimetro per CPU/GPU, `Terminator Skynet`, `Umbrella Corp`, `Matrix`, `DOOM`, `Liquid Glass`). Tutti i widget sono trascinabili (Drag & Drop) e ridimensionabili (25 %–100 %).
- **Sicurezza (`sHeriFF` + `NVIDIA SkillSpector` + `SHA-256`) :** Triplo controllo prima di ogni Git push (0 % dati personali, 0 % chiavi API, 0 % immagini `.dmg`/`.iso` vuote) e scansione anti-malware/anti-prompt-injection per le skin della community.

### 3.2 Guida all'Installazione (IT)
1. **Verifica di sicurezza :** `python3 scripts/nala_hwsensors_sheriff_audit.py`
2. **Avvio immediato :** `python3 macos/nala_hwsensors_daemon.py` oppure compilazione nativa Tauri v2 (`cargo tauri build`).

---

## 🇨🇭 4. RUMANTSCH — Fegliet d'Infurmaziun, Guida d'Installaziun & Surdada

### 4.1 Survista dal Project (Factsheet)
- **Product :** `NALA-HWSensors v2.0` (`2.0.0-NCSP`)
- **Plattafurmas :** macOS (Apple Silicon & Intel cun Menubar, Dock e Widgets), Windows 10/11, Ubuntu Linux e NALA-OS.
- **Design & Skins :** 7 skins uffizials cun controlla da hash `SHA-256` (`Porsche v4 Cockpit` cun indicatur da tanc per la platta dira SSD/NVMe, `Terminator Skynet`, `Umbrella Corp`, `Matrix`, `DOOM`, `Liquid Glass`, `NALA-OS V6.6`). Tut ils widgets pon vegnir spustads per Drag & Drop e scalads dinamicamain (25 %–100 %).
- **Segirezza (`sHeriFF` + `NVIDIA SkillSpector`) :** Tripla controlla avant mintga upload sin GitHub (0 % datas persunalas, 0 % API-Keys, 0 % datotecas `.dmg`/`.iso` vidas) e protecziun cunter malware e prompt-injections en skins da la communitad.

### 4.2 Installaziun (RM)
1. **Audit da segirezza :** `python3 scripts/nala_hwsensors_sheriff_audit.py`
2. **Start sin macOS :** `python3 macos/nala_hwsensors_daemon.py` u `Start_NALA_HWSensors_Mac.command`.

---

## 🇬🇧 5. ENGLISH — Factsheet, Installation Guide & Architecture Handoff

### 5.1 Executive Summary (Factsheet)
- **Product:** `NALA-HWSensors v2.0` (`2.0.0-NCSP`)
- **Platforms:** macOS (Apple Silicon M1–M4 Max & Intel — Menubar, Dock, Desktop Widgets), Windows 10/11, Ubuntu Linux, and NALA-OS.
- **Skin Engine & Draggable Widgets:** 7 SHA-256 verified skins (`Porsche v4 Digital Cockpit` featuring an automotive SSD/NVMe Fuel Tank Gauge & Sport-Chrono Tachometer, `Terminator Skynet HUD`, `Umbrella Bio-Lab`, `Matrix Construct`, `DOOM UAC`, `Liquid Glass`, `NALA-OS V6.6`). Every widget supports Drag & Drop reordering and 2D resizing (25% to 100%).
- **Zero-Trust Security (`sHeriFF` + `NVIDIA SkillSpector` + `SHA-256`):** Mandatory Triple-Check Gate before every Git push (0% PII, 0% private paths/IPs, 0% API keys, 0 empty `.dmg`/`.iso` artifacts) plus declarative-only community skin validation.

### 5.2 Installation Guide (EN)
1. **Run Pre-Flight Security & Hash Audit:** `python3 scripts/nala_hwsensors_sheriff_audit.py`
2. **Launch Live Sensor Daemon & Cockpit:** `python3 macos/nala_hwsensors_daemon.py` (or build native bundles via `cargo tauri build`).
