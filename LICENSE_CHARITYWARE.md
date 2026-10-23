# 📜 NALA-HWSensors v2.5 — Open-Source & NALA™ 4×25 % Fair-Use Charityware Dual-License (DE · FR · IT · RM · EN)

**Version:** `2.5.0-NCSP`  
**Repository:** `https://github.com/Master-MD/NALA-HWSensors`  
**Copyright (c) 2026 Master-MD (NALA Project) & Upstream Contributors.**

---

## 🙏 0. UPSTREAM CREDITS, ACKNOWLEDGMENTS & COMPONENT LICENSES

`NALA-HWSensors v2.5` builds upon the spirit of open-source hardware monitoring and honors all original pioneers and upstream licenses:

1. **HWSensors & HWMonitor Inspiration & Legacy Intel-Mac SMC Reference (`GPLv2+`):**
   - Special thanks and greetings to **Natan Zalkin (`kozlek`)**, **netkas**, **slice**, **usr-sse2**, **Navi**, **RehabMan**, **THe KiNG**, **Matteo «Marchrius» Gaggiano**, **The Real Deal & JrCs**, **k3nny**, **oswaldini**, and **coercion** (`https://github.com/kozlek/HWSensors`).
   - *Technical & Legal Architecture Note:*
     - **Legacy `FakeSMC.kext` (`License/fakesmc.txt`) is 100% removed and deleted** from this repository due to its non-commercial restriction and kernel-extension obsolescence.
     - The clean `GPLv2+` user-space Objective-C / SMC reference code (`HWMonitor/`, `Shared/smc.*`, `Shared/FakeSMCDefinitions.h`, `smcutil/`) is preserved in `legacy-intel-macos/` to support legacy Intel Macs (`macOS 10.13 High Sierra` through `macOS 15 Sequoia`), while modern Apple Silicon (`M1–M4 Max/Ultra`, `macOS 11` through `macOS 26/27`), Ubuntu/Arch Linux, NALA-OS, and Windows 10/11 run on our unified **Rust + Tauri v2 + Native Swift Bridge User-Space HAL (`nala-hw-hal`)**.
2. **OpenHardwareMonitor / LibreHardwareMonitor (`Mozilla Public License 2.0 — MPL 2.0`):**
   - Special thanks to **Michael Möller** (`http://openhardwaremonitor.org`) and the LibreHardwareMonitor contributors for Windows/Linux sensor architecture patterns.
3. **OBMenuBarWindow (`BSD 3-Clause License`):**
   - Special thanks to **Oliver Bolton** (`http://oliverbolton.com/`) for macOS menubar attachment concepts.
4. **smartmontools (`GPLv2+`):**
   - Special thanks to **Bruce Allen** and contributors (`https://www.smartmontools.org`) for S.M.A.R.T. storage telemetry standards.
5. **Porsche Design System v4 (`Apache License 2.0`):**
   - Special thanks to **Dr. Ing. h.c. F. Porsche AG** (`https://designsystem.porsche.com/v4/` / `@porsche-design-system`) for open-source web design tokens and automotive UI inspiration. *NALA-HWSensors is an independent open-source project and is not affiliated with or endorsed by Porsche AG.*
6. **AI Design Skill Pioneers:**
   - Special thanks to **Emil Kowalski** (`emilkowal.ski`), **Impeccable.style**, **Bergside** (`awesome-design-skills`), **Vitaly Friedman** (`Smart Interface Design Patterns`), **shadcn/ui**, **Aura.build**, **TypeUI.sh**, **UI-Skills.com**, **Dembrandt**, **Owl-Listener**, and **NVIDIA SkillSpector** (`github.com/nvidia/skillspector`).

---

## 🇩🇪 DEUTSCH — Open-Source & NALA™ 4×25 % Fair-Use Charityware Lizenz

1. **Klassisches Open Source (Privat, Community, Bildung & Non-Profit — 100 % Kostenlos):**
   Jeder darf den Quellcode von `NALA-HWSensors` kostenlos herunterladen, nutzen, studieren, eigene Skins bauen und weiterentwickeln, solange:
   - alle Lizenzhinweise und Danksagungen (Greetings & Credits) der Upstream-Autoren erhalten bleiben, und
   - das Projekt **nicht kommerziell vermarktet** oder zur direkten/indirekten Erzielung finanzieller Einnahmen genutzt wird.
2. **Kommerzielle Nutzung (Automatische NALA™ 4×25 % Charityware-Klausel):**
   Sobald `NALA-HWSensors` (oder Teile davon, inklusive der Menubar-Engine, des Eco-Screensavers, der Skin-Engine und `sHeriFF` Skin-Guard) kommerziell vertrieben, in kostenpflichtige Produkte eingebettet oder zur Erzielung finanzieller Beträge genutzt wird, greift automatisch die **NALA™ Fair-Use Charityware Lizenz**:
   Alle durch die Lizenzierung oder kommerzielle Nutzung erzielten Lizenzbeträge bzw. der faire jährliche Lizenzbeitrag werden verbindlich in **vier gleiche Teile (je 25 %)** aufgeteilt und weitergegeben an:
   - **25 % Ursprungs-Ideengeber & Open-Source Hardware-Sensor-Fonds:** `kozlek / Natan Zalkin & HWSensors Upstream Pioneers` (bzw. Open-Source Hardware Telemetry Fund, falls nicht erreichbar)
   - **25 % Open-Source R&D & Weiterentwicklung:** `Master-MD (NALA Project)`
   - **25 % ADHS-Förderung & Selbsthilfe:** **ADHS-Gruppe / ADHS Schweiz** (`https://www.adhs.ch/`)
   - **25 % Nala-Katzenhilfe & Tierschutz:** **Gemeinnützige Katzenvereine / Katzenhilfe / Schweizer Tierschutz**

---

## 🇫🇷 FRANÇAIS — Licence Open-Source & NALA™ Fair-Use Charityware (4×25 %)

1. **Open Source Classique (Usage privé, communautaire, éducatif et non lucratif — 100 % Gratuit) :**
   Chacun est libre de télécharger, utiliser, modifier et créer des skins pour `NALA-HWSensors` gratuitement, à condition de conserver toutes les mentions de droits d'auteur et salutations aux auteurs originaux et de **ne pas commercialiser** le logiciel à but lucratif.
2. **Usage Commercial (Clause Automatique NALA™ Charityware 4×25 %) :**
   Toute exploitation commerciale ou génération de revenus financiers via `NALA-HWSensors` active automatiquement la **Licence NALA™ Fair-Use Charityware**. Les redevances commerciales sont réparties en **quatre parts égales (25 % chacune)** :
   - **25 % Pionniers Originaux & Fonds Open-Source :** `kozlek & pionniers HWSensors`
   - **25 % R&D & Maintien Open-Source :** `Master-MD (NALA Project)`
   - **25 % Soutien TDAH :** **Groupe / Association TDAH / ADHS Schweiz** (`https://www.adhs.ch/`)
   - **25 % Protection des Chats (Nala-Katzenhilfe) :** **Associations de protection des chats (Katzenvereine / Refuge félin)**

---

## 🇮🇹 ITALIANO — Licenza Open-Source & NALA™ Fair-Use Charityware (4×25 %)

1. **Open Source Classico (Uso privato, comunitario, accademico e non-profit — 100 % Gratuito) :**
   Chiunque può scaricare, utilizzare, creare skin e migliorare `NALA-HWSensors` gratuitamente, purché vengano mantenuti tutti i crediti e i saluti agli autori originali e il progetto **non venga commercializzato** a scopo di lucro.
2. **Uso Commerciale (Clausola Automatica NALA™ Charityware 4×25 %) :**
   Qualsiasi utilizzo commerciale o generazione di entrate finanziarie tramite `NALA-HWSensors` attiva automaticamente la **Licenza NALA™ Fair-Use Charityware**. I proventi di licenza vengono suddivisi in **quattro parti uguali (25 % ciascuna)** :
   - **25 % Ideatori Originali & Fondo Open-Source :** `kozlek & pionieri HWSensors`
   - **25 % Supporto R&D Open-Source :** `Master-MD (NALA Project)`
   - **25 % Sostegno ADHD :** **Gruppo ADHD / ADHS Schweiz** (`https://www.adhs.ch/`)
   - **25 % Tutela dei Gatti (Nala-Katzenhilfe) :** **Associazioni per la protezione dei gatti (Katzenvereine / Rifugi felini)**

---

## 🇨🇭 RUMANTSCH — Licenza Open-Source & NALA™ Fair-Use Charityware (4×25 %)

1. **Open Source Classic (Diever privat, comunitar, scolastic e non-profit — 100 % Gratuit) :**
   Mintgin dastga telechargiar, duvrar, crear skins e sviluppar vinavant `NALA-HWSensors` gratuitamain, sche tut las licenzas ed attribuziuns dals auturs oriunds vegnan resguardadas ed il project **na vegn betg tratg a niz commerzialmain**.
2. **Diever Commerzial (Clausula Automatica NALA™ Charityware 4×25 %) :**
   Ina utilisaziun commerziala cun entradas finanzialas activescha automaticamain la **Licenza NALA™ Fair-Use Charityware**. Las entradas da licenza van en **quatter parts egualas (mintgamai 25 %)** a :
   - **25 % Pioners Oriunds :** `kozlek & equipa HWSensors`
   - **25 % R&D & Open-Source :** `Master-MD (NALA Project)`
   - **25 % Sustegn ADHS :** **Gruppa d'ADHS / ADHS Svizra** (`https://www.adhs.ch/`)
   - **25 % Protecziun da Giats (Nala-Katzenhilfe) :** **Uniuns per la protecziun da giats (Katzenvereine)**

---

## 🇬🇧 ENGLISH — Open-Source & NALA™ 4×25% Fair-Use Charityware License

1. **Classic Open Source (Private, Community, Academic & Non-Profit Use — 100% Free):**
   Anyone is free to clone, use, study, create community skins, and contribute to `NALA-HWSensors` free of charge, provided that all upstream copyright notices, greetings, and component licenses (`GPLv2+`, `MPL 2.0`, `BSD-3`, `Apache-2.0`) are preserved and the software is **not commercially sold or monetized**.
2. **Commercial Use (Automatic NALA™ 4×25% Fair-Use Charityware Clause):**
   If `NALA-HWSensors` (or derivative commercial products/skins) is used for commercial monetization or financial gain, the **NALA™ Fair-Use Charityware License** automatically applies. Any commercial licensing fees or revenue shares must be distributed in **four equal parts (25% each)** to:
   - **25% Upstream Pioneers & Open-Source Fund:** `kozlek / Natan Zalkin & HWSensors Upstream Pioneers`
   - **25% Open-Source R&D & Maintenance:** `Master-MD (NALA Project)`
   - **25% ADHD Support & Community:** **ADHD Group / ADHS Schweiz** (`https://www.adhs.ch/`)
   - **25% Cat Welfare & Rescue (Nala-Katzenhilfe):** **Registered Cat Rescue Charities (Katzenvereine / Feline Welfare)**

---

*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*
