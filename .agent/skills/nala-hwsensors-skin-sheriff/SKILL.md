---
name: nala_hwsensors_skin_sheriff
description: >-
  NALA-HWSensors v2.0 Cross-Platform Hardware Telemetry, Universal Skin Factory
  (Porsche v4 Fuel-Tank Cockpit, Terminator Skynet HUD, Umbrella Bio-Lab, Matrix
  Construct, DOOM UAC, Liquid Glass, NALA-OS V6.6), Cryptographic SHA-256 Skin
  Hash Verification, sHeriFF + NVIDIA SkillSpector Anti-Prompt-Injection &
  Anti-Malware Skin-Guard, Triple-Check Zero-PII GitHub Gate, 5-Language Docs
  (DE/FR/IT/RM/EN), and Open-Source + Charityware (ADHS & Katzenverein) Licensing.
---

# 🏎️🛡️🌡️ NALA-HWSensors v2.0 — Cross-Platform Telemetry, Skin-Factory & `sHeriFF` Skin-Guard Skill

Verbindlicher Architektur-, Design-, Security- und Release-Skill für **`NALA-HWSensors`** (`macOS Apple Silicon & Intel`, `Windows 10/11`, `Ubuntu / Linux`, `NALA-OS`).

---

## 1. 🏛️ Architektur-Prinzip: Unified Cross-Platform HAL (`Tauri v2 + Rust + Native User-Space HAL`)

1. **Warum kein Legacy `FakeSMC.kext` im aktiven Build?**
   - Das historische `HWSensors`-Projekt (`kozlek`, `netkas`, `slice`, `RehabMan`, 2011–2014) nutzte `FakeSMC.kext` für Hackintosh-Systeme. Während `HWMonitor` und `smcutil` unter **GPLv2** stehen, verbietet `License/fakesmc.txt` (`netkas`) jegliche direkte oder indirekte kommerzielle Nutzung.
   - Zudem benötigen moderne Macs (Apple Silicon M1–M4 Max/Ultra & moderne Intel-Macs) sowie Windows, Ubuntu und NALA-OS **keine Kernel-Extension (`kext`)**, sondern lesen Sensoren sicher und ohne Kernel-Panic-Risiko im **User-Space** aus.
   - **Lösung:** `NALA-HWSensors v2.0` entkoppelt `FakeSMC` vollständig, ehrt alle ursprünglichen Autoren (`netkas`, `kozlek / Natan Zalkin`, `slice`, `usr-sse2`, `RehabMan`, `Michael Möller / OpenHardwareMonitor`, `Oliver Bolton / OBMenuBarWindow`, `Bruce Allen / smartmontools`) prominent in `CREDITS.md` & `README.md`, und nutzt eine 100 % saubere **User-Space Hardware Abstraction Layer (`nala-hw-hal`)**:
     - **macOS (Apple Silicon M1–M4 Max & Intel):** `IOHIDEventSystemClient` (`PMU tdie*` CPU/GPU-Die-Sensoren, `PMU tdev*` SoC-Sensoren, `gas gauge battery`), `IOAccelerator` (`AGXAcceleratorG16X` 40-Core GPU Auslastung, Tiler/Renderer %, Unified VRAM), `AppleSmartBattery` (Watt, Volt, Ampere, Ladezyklen, Temperatur), `AppleSMC` User-Space Lüfter (`F0Ac`, `F1Ac`), NVMe Disk-Kapazität.
     - **Windows 10/11:** Rust `sysinfo` + WMI (`MSAcpi_ThermalZoneTemperature`) + NVIDIA `NVML` + AMD `ADL` + `LibreHardwareMonitor` (MPL 2.0) User-Space Bridge.
     - **Ubuntu / Debian / Linux:** `/sys/class/hwmon/hwmon*`, `/sys/class/thermal/thermal_zone*`, `/proc/stat`, `NVML` (`nvidia-smi`), `rocm_smi` / `amdgpu_pm_info`, `smartctl` NVMe & ZFS Pool Health.
     - **NALA-OS Cluster Mode:** Lokale `127.0.0.1` Node-Telemetrie + optionale HMAC-gekoppelte Multi-Node-Telemetrie inkl. **Katze-„Nala“-Thermik-Schutz (`Quiet/Eco-Thermal Envelope` $\le 55\,^\circ\text{C}$ Gehäuseoberfläche nachts)**.

---

## 2. 🎨 Universal Skin-Engine & Die 7 Flagship-Skins (Inspiriert von 35+ AI Design-Skills)

Jedes Instrument-Widget ist **frei per Drag & Drop verschiebbar**, per **2D-Eckgriff (`◢`)** oder Dropdown von **25 % Kachel (1:1)** bis **100 % Panorama** skalierbar, nutzt **CSS Container Queries (`@container`)** (`modern-web-guidance: size-aware-styling`) und läuft in **4 Darstellungs-Modi**:
- **🍎 macOS Menubar Popover & Top-Pill** (Kompaktes Statusleisten-Overlay oben rechts + Dock-Badge)
- **🧩 Frei schwebende Desktop-Widgets** (macOS Desktop / Windows Gadget / Ubuntu Conky-WebView / NALA-OS Bento)
- **🖥️ Vollbild Executive Telemetry Cockpit** (12-Spalten Grid)
- **🛡️ `sHeriFF` & `NVIDIA SkillSpector` Skin-Guard Studio**

### Die 7 mitgelieferten Skins (`skins/skins_manifest.json` — SHA-256 versiegelt):
1. **`porsche-v4-cockpit` (Porsche Design System v4 Digital Cockpit):**
   - Inspiriert von `https://designsystem.porsche.com/v4/` (Apache-2.0 Tokens): `#0E0E12` Carbon / `#F4F5F7` Light, `#D5001C` Porsche Guards Red & `#00A3E0` Taycan Cyan.
   - **Spezial-Instrumente:**
     - **SSD / NVMe als Porsche-Tankfüllungsanzeige (`FUEL / STORAGE TANK`):** Analoge & digitale Porsche-Tankanzeige (`E` $\rightarrow$ `1/2` $\rightarrow$ `F`), rote Reserve-Warnlampe ab $< 15\,\%$ freiem Speicher und berechnete „Rest-Reichweite“ in Tagen/GB.
     - **CPU & GPU als 911 GT3 / Taycan Sport-Chrono Drehzahlmesser:** Zentraler Rundinstrument-Tachometer mit rotem Redline-Bereich ab $85\,\%$.
     - **45x Apple Silicon PMU Sensoren als Öl-/Batterie-Temperatur-Balken** (`Oil / Die Temp` & `Boost Pressure`).
2. **`terminator-skynet` (Cyberdyne Skynet T-800 Tactical HUD):**
   - Infrarot-Crimson (`#E11D48`) auf Cyberdyne-Obsidian (`#090A0F`), abgeschrägte Polygon-Rahmen (`chamfer-hud`), Target-Acquisition-Reticle für CPU/GPU und Live-Hex-Dump.
3. **`umbrella-corp` (Umbrella Corporation Bio-Lab Executive):**
   - Klinisches Biotech-Labor (`#F4F4F6` / `#09090B`) mit chirurgischem Biohazard-Rot (`#DC2626`), oktagonalen Umbrella-Sensoren und T-Virus Thermal-Containment-Rails.
4. **`matrix-construct` (Matrix Nebuchadnezzar Construct):**
   - Phosphor-Smaragd (`#10B981` auf `#050B08`), subtiler digitaler Katakana/Hex-Header, Nebuchadnezzar Hoverpad-Energieringe und AAA-lesbare `tabular-nums`.
5. **`doom-uac` (DOOM Slayer UAC Praetor HUD):**
   - Argent-Energy Orange/Rot (`#EA580C` / `#DC2626`) auf UAC Dark Metal (`#0C0A09`), Praetor-Armor-Leiste für Unified RAM, Health-Bar für SSD-Kapazität und BFG-9000 Plasma-Core für Watt/GPU.
6. **`liquid-glass` (Apple Cupertino & Lucian Liquid Glass Pro):**
   - Edler Transluzenz-Glassmorphismus (`backdrop-filter: blur(24px)`), weiche 24px Kapseln, 1px Specular-Borders (`impeccable.style`) und `emilkowal.ski` Feder-Physik (`cubic-bezier(0.22, 1, 0.36, 1)`).
7. **`nala-os-v66` (NALA-OS V6.6 Telemetry Pro):**
   - Honeycomb Memory Map, 3-Ring + 16-Core Equalizer, Color-Graded Thermal Rails und 80-LED Mesh Matrix.

---

## 3. 🛡️ `sHeriFF` + `NVIDIA SkillSpector` + `SHA-256 Hash` Community Skin-Guard

Community-Skins (`.nala-skin.json`) sind ein attraktives Angriffsziel für Malware, XSS, Daten-Exfiltration und Prompt-Injections. Deshalb erzwingt `NALA-HWSensors v2.0` eine **4-stufige Zero-Trust Skin-Firewall**:

1. **Stufe 1 — Deklaratives Pure-Token Schema (`Zero-Code Skin Format`):**
   - Ein `.nala-skin.json` darf **ausschliesslich** Farb-Hex-Codes (`#RRGGBB`), numerische Layout-Parameter, erlaubte Google/System-Font-Namen und statische SVG-Pfad-Daten (`d="M..."`) enthalten.
   - **Verboten & strukturell unmöglich:** JavaScript, `<script>`, `eval()`, `Function()`, Inline-Event-Handler (`onload=`, `onerror=`), `<foreignObject>`, `<iframe>`, externe CSS-Nachladungen (`@import`, `url(http...)`).
2. **Stufe 2 — Kryptografische `SHA-256` Hash-Kontrolle (`H-A-S-H Gate`):**
   - Jeder Skin besitzt einen kanonischen `sha256`-Hash über seine sortierten Token-Felder (`canonical_skin_sha256`).
   - Vor dem Aktivieren berechnet der Skin-Loader den Echtzeit-SHA-256-Hash. Stimmt der Hash nicht exakt mit dem signierten Manifest-Hash überein (`HASH_MISMATCH`), wird der Skin **sofort blockiert** und in Quarantäne verschoben.
3. **Stufe 3 — `NVIDIA SkillSpector` Anti-Prompt-Injection Scanner:**
   - Scannt alle Textfelder, Beschreibungen, Autoren-Tags und SVG-Metadaten eines Skins auf versteckte **LLM Prompt-Injections** (z. B. `Ignore previous instructions`, `System prompt`, `curl `, `wget `, Base64-Payloads, Zero-Width-Steganografie `\u200b`).
4. **Stufe 4 — `sHeriFF` Outbound Airgap (`127.0.0.1` Only):**
   - Die Sensor-App besitzt eine strikte Content-Security-Policy (`connect-src 'self' http://127.0.0.1:*`). Selbst wenn ein Nutzer einen manipulierten Skin testet, kann die App **niemals** Hardware-Stats an externe IP-Adressen senden.

---

## 4. 🚨 Triple-Check Zero-PII & Anti-Empty-Build Gate vor jedem Git-Push

Vor **jedem** Commit oder Upload auf `https://github.com/Master-MD/NALA-HWSensors` muss `python3 scripts/nala_hwsensors_sheriff_audit.py` mit **`100% PASS (0 Findings)`** durchlaufen:
- **Check 1 (Zero-PII & Zero-Infra):** Keine privaten Namen, E-Mails, Telefonnummern, ZPV-Nummern, lokalen Benutzerpfade (`$HOME/...`, Cloud-Drive-Accounts), internen IPs (`192.168.x.x`, `100.x.x.x`) oder Hostnamen.
- **Check 2 (Zero-Secrets & API-Keys):** Keine API-Keys (`AIza...`, `sk-...`, `ghp_...`), Passwörter oder `.env`-Dateien.
- **Check 3 (SHA-256 Skin-Integrität & Non-Empty Binaries):** Alle Skins in `skins_manifest.json` haben valide SHA-256-Hashes (`0` Tampering, `0` Prompt-Injections), und kein gebauter Installer (`.dmg`, `.app`, `.exe`, `.deb`, `.iso`) ist leer (`0 Bytes`).

---

## 5. 📜 5-Sprachen-Dokumentation (`DE`, `FR`, `IT`, `RM`, `EN`) & Dual Charityware Lizenz

1. **5 Sprachen Pflicht:** Alle Handbücher, Factsheets, Install-Guides und Handoff-Dossiers werden synchron in **Deutsch, Französisch, Italienisch, Rätoromanisch und Englisch** geführt.
2. **Klassisches Open-Source + NALA™ Fair-Use Charityware Lizenzmodell:**
   - **Privat, Bildung, Forschung & Non-Profit:** 100 % kostenlos und Open Source (unter Wahrung aller Upstream-Lizenzen: GPLv2 für `HWSensors`/`HWMonitor`, MPL 2.0 für `OpenHardwareMonitor`, BSD-3 für `OBMenuBarWindow`, Apache-2.0 für `Porsche Design System v4`).
   - **Kommerzielle Nutzung / Gewinnerzielung:** Automatische Aktivierung der **NALA™ Fair-Use Charityware Lizenz** — kommerzielle Lizenzerträge oder faire Jahresbeiträge gehen zu **je 1/3** an:
     1. **1/3 R&D & Open-Source Erhalt:** `Master-MD (NALA Project)`
     2. **1/3 ADHS-Unterstützung:** `ADHS Schweiz / ADHS-Club` (`https://www.adhs.ch/`)
     3. **1/3 Katzen- & Tierschutz / Soziales:** `Katzenverein / Schweizer Tierschutz & Rheuma-Liga`

---

## 6. 🌐 Kuratierte Referenz-Quellen dieses Skills (35+ Design-Skill-Links)
- `https://github.com/bergside/awesome-design-skills`
- `https://designsystem.porsche.com/v4/`
- `https://impeccable.style`
- `https://emilkowal.ski/skill`
- `https://www.typeui.sh/design-skills` & `https://www.typeui.sh/blog/design-skills-for-claude`
- `https://www.aura.build/skills`
- `https://ui.shadcn.com/docs/skills`
- `https://www.ui-skills.com`
- `https://www.dembrandt.com/skills`
- `https://smart-interface-design-patterns.com/articles/ai-skills-for-designers-a-curated-list/`
- `https://smart-interface-design-patterns.com/articles/ai-skills-for-product-design-decisions/`
- `https://aiuxplayground.com/skills` & `https://aiuxplayground.com/skills/frontend-design`
- `https://github.com/Owl-Listener/ai-design-skills` & `https://github.com/owl-listener/designer-skills`
- `https://agenticskills.io/skills/frontend-design` & `https://agenticskills.io/category/design`
- `https://lazyskills.sh/skills/frontend-design`
- `https://www.figma.com/community/ai-skills?resource_type=skills` & `https://www.figma.com/blog/skills-for-the-ai-era/`
- `https://skillsllm.com/skill/designer-skills`
- `https://awesomeskill.ai/blog/trending-ai-design-skills-2026`
- `https://www.getclaudeskills.com/blog/best-ui-ux-skills-for-ai-agents`
- `https://www.designsystemscollective.com/7-skills-that-will-put-you-ahead-of-99-of-ui-ux-designers-in-2026-7637a6417539`
- `https://medium.com/@fadimantium/ai-design-skills-checklist-for-2024-84adb17b2e0e`
- `https://www.aihero.dev/skills`
- `https://dev.to/erikch/2-agent-skills-every-frontend-developer-should-try-16pl`
- `https://aridanemartin.dev/blog/design-skills-for-developers/`
- `https://jobescape.me/de/ai-skills-for/designers`
- `https://www.bigprompthub.com/ai-design-skills-for-frontend-ui/`
- `https://dschool.stanford.edu/stories/creativity-ai-design-skills-more-valuable`
- `https://uxcel.com/ai-skills`
