# 🐧🏔️ NALA-HWSensors v2.7 — Ubuntu / Linux Engine-Handout & Copy-Paste Master-Prompt

> **So nutzt du dieses Handout:**
> Im **Abschnitt 1** findest du den **kompletten Copy-&-Paste Master-Prompt** in einem einzigen Markdown-Codeblock. Kopiere ihn einfach 1:1 in deinen Ubuntu-Chat / Agenten (Antigravity, Codex, ZCode oder OpenCode). Er weist den Agenten an, **zuerst deine bestehenden 90 % Ubuntu-Arbeit (Backend, `/proc/stat`, `hwmon`, `nvidia-smi`, Ubuntu-Screensaver) zu inventarisieren und per NCSP-Backup zu sichern**, nichts davon kaputtzumachen, und **nur das UI/UX-Design + die echte 3D-Bergrelief-Engine (`v2.7`) 1:1 einzubauen**.

---

## 📋 1. Direkt kopierbarer Copy-&-Paste Master-Prompt für deinen Ubuntu-Chat

````markdown
# 🚀 MISSION: NALA-HWSensors v2.7 — Design- & True-3D-Relief-Engine Upgrade für Ubuntu / Linux (NON-DESTRUCTIVE!)

Schau dir bitte zuerst genau an, was wir in diesem Ubuntu-Projekt von `NALA-HWSensors` bis jetzt gebaut haben (ca. 90 % der Backend-Logik, Linux-Sensoren `/proc/stat`, `/sys/class/hwmon`, `nvidia-smi`/`rocm-smi`, Remote-Nodes und Ubuntu-Screensaver-Anbindung laufen bereits!).

## 🛑 OBERSTE DIREKTIVE (INVENTORY-FIRST & ZERO-REGRESSION):
1. **Nichts kaputtmachen:** Erstelle VOR jeder Code-Änderung ein vollständiges **NCSP-Inventar** und ein **atomares Backup + `rollback.sh`** des aktuellen Ubuntu-Stands.
2. **Bestehende Ubuntu-Logik 100 % behalten:** Alle vorhandenen Linux-Telemetrie-Collector-Funktionen (`/proc/stat` Per-Thread-Auslastung, `lm-sensors`/`hwmon`, GPU-Stats, Netzwerk, Batterie/USV, Multi-Host-Polling und Ubuntu-Screensaver/Wayland/X11-Starter) MÜSSEN erhalten bleiben und weiterverwendet werden!
3. **Referenz-Quelle (v2.7 Master-Vorlage):**
   - Repository-Pfad: `ui/nala_hwsensors_v27_macos_studio.html` (bzw. `ui/nala_hwsensors_v26_macos_studio.html`)
   - GitHub (Tag `v2.7.0-universal-biomes`): `https://github.com/Master-MD/NALA-HWSensors`

---

## 🎨 WAS DU IM UBUNTU-UI & DER 3D-ENGINE 1:1 AUS DER v2.7 ÜBERNEHMEN SOLLST:

### 1. Das AAA Dark-Obsidian Studio-Layout & Glassmorphismus (`#050811` / `#080d1a`)
- **Kein generischer AI-Slop:** Exakte Übernahme des `v2.7` Command-Center-Designs:
  - **Farb-Tokens:** Hintergrund `#050811`, Panel-Cards `rgba(11, 16, 29, 0.88)` mit `backdrop-filter: blur(20px)` und `1px solid rgba(255, 255, 255, 0.08)` Specular-Border.
  - **Obere Ubuntu / GNOME Status-Bar Integration:** Kompakte Telemetrie-Pill (`💻 CPU % + °C + W | 📟 RAM % | 🔋 Bat/USV | ↑UL ↓DL`) + Skin-Pulldown-Menü + 3 Layout-Modi (`Bild 1: Alpine Command Center`, `Bild 2: Lava v2.6`, `Bild 3: NALA Aurora`).
  - **Oberer 8-Karten Neon-Radial-Gauge-Strip:** `CPU`, `GPU`, `Memory`, `Disk`, `Network`, `Thermal`, `Fans · Power` mit leuchtenden SVG-Kreisbögen, 24-Balken-Mini-Spektrum-Histogrammen darunter und der `NALA All Systems Online`-Portrait-Karte rechts.
  - **Frei verschiebbare (Drag & Drop) & 4-stufig skalierbare (`S | M | L | XL`) Live-Widgets** + **192-Channel CPU Thread Matrix** unten.

### 2. Die echte prozedurale 3D-Triangulierte Bergrelief-Engine (`NZ=64 × NX=120 = 15.360 Dreiecke @ 60 FPS`)
Ersetze das bisherige flache oder einfache 3D-Canvas durch die **echte `draw3DMountainCanvas()` Engine aus `v2.7`** mit:
- **Echter Hidden-Surface-Occlusion (Painter's Algorithm Back-to-Front)** und **triangulierten diagonalen Facetten**, damit steile Berggrate, Schluchten und kristalline Gipfel exakt wie ein hochauflösendes 3D-Drahtgitter-Gebirge aussehen.
- **Code-Stream Matrix auf dem Talboden** (`0%–25%` im Wireframe/Aurora-Modus), **vertikalen Peak-Laser-Pins (`|o`)** mit binären `0`/`1`-Labels auf den höchsten Thread-Spitzen und **schwebender HUD-Callout-Box (`CPU Thread # · % · GHz · Temp °C`)** am höchsten Hauptgipfel.
- **Alle 7 höhenabhängigen 3D-Biome (`setPalette()`):**
  1. **`🏔️ Himalaya (`himalaya`)`:** 4-Zonen-Höhenschichtung: Smaragdgrünes Tal mit prozeduralen 3D-Tannen (`0–21%`) -> erdiges Feldbraun (`21–39%`) -> schroffer Graufels mit Steilwand-Fels-Exposition (`39–57%`) -> strahlend weißer Gletscher-Schnee (`57–100%`, *„umso höher, umso weißer“*).
  2. **`❄️ Matterhorn Schnee-Gipfel (`snowpeaks`)`:** Dunkler Granit-Fels mit tief verschneiten weißen Gipfeln und eisblauem Gitter.
  3. **`🌲 Tannenwald & Alpengipfel (`forest`)`:** Grüne Wälder mit Hunderten prozeduralen 3D-Nadelbäumen (`🌲`) im Tal und schneebedeckten Alpengipfeln.
  4. **`🌋 Hyper-Magma / Krakatau (`hyperlava`)`:** Glühende Lava-Flüsse, die durch die Talschluchten fließen, aufbrechende Magma-Spalten, weißglühende Krater-Spitzen und aufsteigende Funken-Partikel (`Ember-Sparks`).
  5. **`🌈 NALA Aurora (`aurora`)`:** Multicolor-Spektrum von Warm-Amber/Gold links über Magenta/Violett in der Mitte bis Cyan/Smaragd rechts.
  6. **`🏔️ Alpine Gold (`alpine`)`:** Dunkler Schiefer-Fels mit golden beleuchteten Sonnenhängen.
  7. **`🔥 Vulkan / Lava (`lava`)`:** Schwarzer Basalt-Fels mit glühenden Magma-Adern auf den Kämmen.

### 3. Langsamer 360° Planeten-/Landschafts-Orbit (`🪐 360° Orbit`) + Echtes Ubuntu Vollbild & Screensaver
- Baue den **`🪐 360° Orbit`**-Toggle samt Speed-Slider (`0.2x..2.5x`) ein, der die gesamte 3D-Gebirgsinsel mit vorzeichenabhängiger Back-to-Front-Sortierung (`cosT = Math.cos(orbitTheta)`, `sinT = Math.sin(orbitTheta)`) sanft um 360° dreht.
- Verbinde den **`⛶ Echtes Vollbild`**-Button sowohl mit der HTML5 Fullscreen API (`document.documentElement.requestFullscreen()`) als auch mit deinem Ubuntu-Fenster-Wrapper (Tauri / PyWebView / GTK / Electron `set_fullscreen(true)`), und kopple den Ubuntu-Screensaver-Modus (`?biome=himalaya&saver=1&orbit=1`) an den Fullscreen-Screensaver-Dock!

---

## 🏛️ PFLICHT-PROTOKOLL FÜR DIE UMSETZUNG:
Kannst du dies alles nach **TheStandart** und **NCSP & Inventory** (BackUPs, Snapshots und Rollbacks!) umsetzen und mit **NALAtheON's, NEOP's und Grand TheGremium's** jeweils mit Experten und mit (3-7 Runden) analysiert, optimiert und vom UI/UX entsprechend AAA Premium geplant und umgesetzt werden, so wie es aus einer Highend Software Firma kommt — **OHNE dabei AI-Slop zu erstellen! Und OHNE bestehende Ubuntu-Features zu beschädigen, zu entfernen oder NALA-bRaiN(-cORe) oder das NALA-OS kaputt zu machen!**
Nutze die Ressourcen von NALA und bringe ihr auch alles bei, trainiere sie so, dass sie das als einen Skill nutzen kann, den sie auch mit anderen Skills kombinieren kann! Sowie dass sie auch diese Software weiterentwickeln kann, mögliche Verbesserungen in ihrer „Dream"-Phase überlegen, die Software-Perlen durchsuchen oder eigene Konzepte entwickeln, mit REA oder auch mit RSI dann einen Plan erstellt (mit NALAtheON's, NEOP's und Grand TheGremium jeweils mit Experten (3-7 Runden) auf den NALA-Ressourcen) und mir diese als übersichtliches Konzept mit **Lösungsmatrix inkl. Delta-Übersichts-Matrix (Performance / Features / Sicherheits-Optimierungen)** vorschlagen kann, die ich dann mit **2 Klicks** (*1. Klick -> Installieren/Umsetzen* und dann *Wollen Sie wirklich? -> Abbrechen oder AUSFÜHREN*) installieren kann — oder mir die entsprechenden Prompts für **Codex / Antigravity, ZCode oder OpenCode** bereitstellt (inkl. diesem Schlussabsatz, damit die nächste Iteration genauso selbstlernend bleibt)!
````
