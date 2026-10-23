# 🏎️🛡️🌡️ NALA-HWSensors v2.0 (`2.0.0-NCSP`)
### Cross-Platform Hardware Telemetry, Porsche v4 / Sci-Fi / Liquid-Glass Skin Engine & `sHeriFF` + `NVIDIA SkillSpector` SHA-256 Skin-Guard
**Platforms:** `macOS (Apple Silicon M1–M4 Max & Intel)` · `Windows 10/11` · `Ubuntu / Linux` · `NALA-OS`  
**Languages:** 🇩🇪 Deutsch · 🇫🇷 Français · 🇮🇹 Italiano · 🇨🇭 Rumantsch · 🇬🇧 English  
**Repository:** [https://github.com/Master-MD/NALA-HWSensors](https://github.com/Master-MD/NALA-HWSensors)

---

## 🙏 Credits, Upstream Pioneers & Honors

`NALA-HWSensors v2.0` is inspired by the legendary **HWSensors / HWMonitor** project and modern automotive & sci-fi UI engineering. We gratefully acknowledge and honor:
- **Natan Zalkin (`kozlek`)**, **netkas**, **slice**, **usr-sse2**, **Navi**, **RehabMan**, **THe KiNG**, **Matteo «Marchrius» Gaggiano**, **The Real Deal & JrCs**, **k3nny**, **oswaldini**, and **coercion** for the original `HWSensors` & `HWMonitor` architecture (`GPLv2+`). *(Note: Legacy `FakeSMC.kext` non-commercial kernel extensions are completely decoupled and not used; v2.0 uses 100% safe User-Space APIs).*
- **Michael Möller** (`OpenHardwareMonitor`, `MPL 2.0`) & the `LibreHardwareMonitor` team.
- **Oliver Bolton** (`OBMenuBarWindow`, `BSD 3-Clause`) for macOS menubar attachment concepts.
- **Bruce Allen** (`smartmontools`, `GPLv2+`) for NVMe/SSD S.M.A.R.T. health telemetry standards.
- **Porsche Design System v4** (`https://designsystem.porsche.com/v4/`, `Apache-2.0`) for open-source design tokens that inspired our **Porsche Digital Cockpit & SSD Fuel-Tank Gauge** skin *(independent open-source tribute, not affiliated with Porsche AG)*.
- **28+ Curated AI Design Skill Pioneers:** `Emil Kowalski (emilkowal.ski)`, `Impeccable.style`, `Bergside (awesome-design-skills)`, `Vitaly Friedman (Smart Interface Design Patterns)`, `shadcn/ui`, `Aura.build`, `TypeUI.sh`, `UI-Skills.com`, `Dembrandt`, `Owl-Listener`, `AgenticSkills.io`, `LazySkills.sh`, `Figma AI Skills`, `SkillsLLM`, `Uxcel`, `Stanford d.school`, and **NVIDIA SkillSpector** (`github.com/nvidia/skillspector`).

---

## 🎨 7 Flagship Skins (Cryptographically Signed via `SHA-256`)

| Skin ID | Name | Visual DNA & Special Instruments |
| :--- | :--- | :--- |
| **`porsche-v4-cockpit`** | **Porsche v4 Digital Cockpit** | `#0E0E12` Carbon / `#D5001C` Guards Red · **NVMe/SSD as Porsche Fuel Tank Gauge (`Tankfüllungsanzeige` E $\rightarrow$ 1/2 $\rightarrow$ F + Reserve LED)** · **911 GT3 / Taycan Sport-Chrono Tachometer** for CPU/GPU · **Oil/Coolant Thermal Rails** |
| **`terminator-skynet`** | **Terminator / Cyberdyne Skynet HUD** | `#090A0F` Steel / `#E11D48` Infrared Crimson · Chamfered Polygon HUD frames · T-800 Target-Acquisition Reticle · Live Hex Memory Stream |
| **`umbrella-corp`** | **Umbrella Corporation Bio-Lab** | `#F4F4F6` Clinical White / `#DC2626` Biohazard Red · Octagonal Umbrella Telemetry Ring · T-Virus Thermal Containment Rails |
| **`matrix-construct`** | **Matrix Nebuchadnezzar Construct** | `#050B08` Terminal / `#10B981` Phosphor Emerald · Subtle Construct Header · Hoverpad Core Rings · AAA Tabular Monospace |
| **`doom-uac`** | **DOOM Slayer UAC Praetor HUD** | `#0C0A09` UAC Metal / `#EA580C` Argent Orange · **Praetor Suit Armor Bar** for RAM · **Health Bar** for SSD · **BFG-9000 Plasma Core** for Watts/GPU |
| **`liquid-glass`** | **Apple Cupertino / Lucian Liquid Glass** | Translucent Frosted Glass (`backdrop-filter: blur(24px)`) · 24px Soft Capsules · `impeccable.style` 1px Hairlines & `emilkowal.ski` Spring Physics |
| **`nala-os-v66`** | **NALA-OS V6.6 Telemetry Pro** | `#06090F` Obsidian / `#06B6D4` Cyan · Honeycomb Memory Map · 3-Ring + 16-Core Equalizer · 80-LED Mesh Matrix |

---

## 🛡️ Zero-Trust Security: `sHeriFF` + `NVIDIA SkillSpector` + `SHA-256` Skin-Guard

Community skins (`.nala-skin.json`) are protected by a **4-Layer Security Architecture**:
1. **Declarative-Only Skin Schema:** Skins contain only hex colors, typography tokens, layout presets, and static SVG paths. **Zero `<script>`, zero JS execution, zero `eval()`, zero external `url(http...)` calls.**
2. **Cryptographic `SHA-256` Hash Verification (`H-A-S-H` Gate):** Every skin is verified against its canonical `sha256` checksum before loading. Tampered skins are immediately blocked (`HASH_MISMATCH_BLOCKED`).
3. **`NVIDIA SkillSpector` Anti-Prompt-Injection Scanner:** Inspects all skin metadata, labels, and SVG descriptions for hidden LLM prompt injections, shell payloads (`curl`, `wget`, `rm -rf`), or zero-width steganography.
4. **Triple-Check Pre-Push Gate (`scripts/nala_hwsensors_sheriff_audit.py`):** Guarantees **0% PII, 0% private IPs/paths, 0% API keys, 100% valid SHA-256 skin hashes, and 0 empty binaries (`.dmg`/`.iso`/`.exe`)** before any Git push.

---

## 🌍 5-Language Quick Overview (DE · FR · IT · RM · EN)

- 🇩🇪 **Deutsch:** Plattformübergreifendes Hardware-Sensor-Cockpit, Menubar-App & Desktop-Widgets für macOS (Apple Silicon M1–M4 Max & Intel), Windows, Ubuntu und NALA-OS. Vollständig skinbar (Porsche Tankanzeige, Terminator, Umbrella, Matrix, DOOM, Liquid Glass) mit lokalem `sHeriFF` + `NVIDIA SkillSpector` SHA-256 Schutz.
- 🇫🇷 **Français :** Cockpit de télémétrie matérielle multiplateforme, barre de menus et widgets de bureau pour macOS, Windows, Ubuntu et NALA-OS. Skins interchangeables avec vérification cryptographique `SHA-256` et protection `sHeriFF` + `NVIDIA SkillSpector`.
- 🇮🇹 **Italiano :** Cockpit di telemetria hardware multipiattaforma, barra dei menu e widget desktop per macOS, Windows, Ubuntu e NALA-OS. Skin personalizzabili con controllo hash `SHA-256` e sicurezza `sHeriFF` + `NVIDIA SkillSpector`.
- 🇨🇭 **Rumantsch :** Cockpit da telemetria da hardware per macOS, Windows, Ubuntu e NALA-OS cun widgets da desktop, skins (Porsche, Terminator, Matrix, DOOM, Glass) e controlla da segirezza `SHA-256` (`sHeriFF` + `NVIDIA SkillSpector`).
- 🇬🇧 **English:** Cross-platform hardware telemetry cockpit, menubar app, and draggable/resizable desktop widgets for macOS, Windows, Ubuntu, and NALA-OS. Features SHA-256 verified skins and `sHeriFF` + `NVIDIA SkillSpector` anti-malware/anti-prompt-injection protection.

---

## 🚀 Quickstart (macOS / Cross-Platform)

```bash
# 1. Run Triple-Check Security, Zero-PII & SHA-256 Skin-Guard Audit:
python3 scripts/nala_hwsensors_sheriff_audit.py

# 2. Launch Live macOS Hardware Sensor Daemon & Interactive Cockpit (127.0.0.1:8768):
python3 macos/nala_hwsensors_daemon.py
# Or double-click: Start_NALA_HWSensors_Mac.command
```

---

## ✨ What's New in the v2.5 AI Studio Cockpit (`ui/index.html`)

- **Compact Skin Pulldown Menu (`<select>`):** Space-saving dropdown in both the macOS Menubar and Cockpit Header for instant switching between all 10 skins (`FuseLab Spatial 3D`, `🏎️ Porsche v4 Open Light`, `🏁 Porsche GT3 Dark`, `Dark Pro`, `Terminator Skynet HUD`, `Umbrella Corp Bio-Lab`, `Matrix Construct`, `DOOM UAC Tactical`, `Impeccable & Emil Craft`, `Aura & TypeUI Swiss`).
- **True 2D Corner-Drag Scaling (`◢`) + `[ − ]` / `[ + ]` / `[ T ]`:** Butter-smooth 2D resizing from `68×30px` Nano Pills up to `1380×340px` wide studio panels.
- **Drag & Drop Reordering (`⠿`):** Drag and drop any of the 7 Instrument Cards (`INST-01` .. `INST-07`) or any macOS Menubar item to customize your layout.
- **1-Click Card Drill-Down & Quick-Scale Inspector (`[ 🔍 ]`):** Click on any instrument card to inspect hardware details and apply 1-click size presets (`Nano 95×38`, `Kompakt 220×68`, `Standard 445×118`, `Full-Width 920×165`).
- **Animated Live Telemetry Stock-Ticker Banner (`30px`):** Smooth `requestAnimationFrame` marquee with hover-to-pause, speed slider (`0.2x` – `3.5x`), `[ − ]`, `[ ⏸ ]`, `[ + ]` buttons, `[ ! ] Alert` test trigger, and `[ ⚙ Ticker ]` message manager + `.CSV` export.
