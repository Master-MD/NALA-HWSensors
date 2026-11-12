import Cocoa
import WebKit
import IOKit.ps
import Security
import Darwin

// ============================================================================
// NALA-HWSensors v2.7 — 100% Native Universal macOS (arm64 + x86_64) App
// Real Per-Core CPU Threads (host_processor_info) · Native Fullscreen Space ·
// 1-Click .saver Installer · Zero Kexts · Zero Root Daemons · Keychain Vault
// ============================================================================

final class KeychainVault {
    static let service = "org.mastermd.nala-hwsensors.remotes"

    static func saveRemoteHost(alias: String, endpointAndTokenJSON: String) -> Bool {
        guard let data = endpointAndTokenJSON.data(using: .utf8) else { return false }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: alias
        ]
        SecItemDelete(query as CFDictionary)
        var addQuery = query
        addQuery[kSecValueData as String] = data
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        return status == errSecSuccess
    }
}

struct MacLiveTelemetry {
    var cpuPercent: Int = 24
    var coreLoads: [Int] = []
    var logicalCores: Int = ProcessInfo.processInfo.activeProcessorCount
    var archLabel: String = {
        #if arch(arm64)
        return "MacBook Pro (Apple Silicon arm64)"
        #elseif arch(x86_64)
        return "Mac Pro / MacBook Pro (Intel x86_64)"
        #else
        return "Mac (Universal)"
        #endif
    }()
    var ramPercent: Int = 54
    var ramUsedGB: Double = 32.0
    var ramTotalGB: Double = 64.0
    var batteryPercent: Int = 100
    var isCharging: Bool = true
    var tempCelsius: Int = 48
    var netUpKBps: Int = 24
    var netDownKBps: Int = 86
}

final class LocalMacHardwareReader {
    private var prevNetIn: UInt64 = 0
    private var prevNetOut: UInt64 = 0
    private var prevTime: TimeInterval = Date().timeIntervalSince1970
    private var prevCpuTicks: [(user: Int32, sys: Int32, idle: Int32, nice: Int32)] = []

    func sample() -> MacLiveTelemetry {
        var t = MacLiveTelemetry()
        t.logicalCores = ProcessInfo.processInfo.activeProcessorCount

        // 1. Real Per-Core CPU Thread Load via Mach host_processor_info (Works on arm64 & Intel x86_64!)
        var numCPUsU: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCpuInfo: mach_msg_type_number_t = 0
        let kr = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo)
        if kr == KERN_SUCCESS, let info = cpuInfo {
            let n = Int(numCPUsU)
            var currentTicks: [(user: Int32, sys: Int32, idle: Int32, nice: Int32)] = []
            var loads: [Int] = []
            var sumLoad = 0

            for i in 0..<n {
                let base = i * Int(CPU_STATE_MAX)
                let user = info[base + Int(CPU_STATE_USER)]
                let sys  = info[base + Int(CPU_STATE_SYSTEM)]
                let idle = info[base + Int(CPU_STATE_IDLE)]
                let nice = info[base + Int(CPU_STATE_NICE)]
                currentTicks.append((user, sys, idle, nice))

                if i < prevCpuTicks.count {
                    let p = prevCpuTicks[i]
                    let dUser = max(0, user - p.user)
                    let dSys  = max(0, sys - p.sys)
                    let dIdle = max(0, idle - p.idle)
                    let dNice = max(0, nice - p.nice)
                    let total = dUser + dSys + dIdle + dNice
                    let busy  = dUser + dSys + dNice
                    let pct   = total > 0 ? Int((Double(busy) / Double(total)) * 100.0) : 15
                    let clamped = min(99, max(4, pct))
                    loads.append(clamped)
                    sumLoad += clamped
                } else {
                    loads.append(24)
                    sumLoad += 24
                }
            }
            prevCpuTicks = currentTicks
            t.coreLoads = loads
            if n > 0 {
                t.cpuPercent = min(99, max(4, sumLoad / n))
            }

            let deallocSize = vm_size_t(numCpuInfo) * vm_size_t(MemoryLayout<integer_t>.size)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: info), deallocSize)
        }

        // 2. RAM via host_statistics64 (User-Space Mach call)
        let totalBytes = ProcessInfo.processInfo.physicalMemory
        t.ramTotalGB = Double(totalBytes) / (1024 * 1024 * 1024)
        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        let hostPort = mach_host_self()
        let kernReturn = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &count)
            }
        }
        if kernReturn == KERN_SUCCESS {
            let pageSize = UInt64(vm_kernel_page_size)
            let usedBytes = UInt64(vmStats.active_count + vmStats.wire_count + vmStats.compressor_page_count) * pageSize
            t.ramUsedGB = Double(usedBytes) / (1024 * 1024 * 1024)
            t.ramPercent = min(99, max(5, Int((Double(usedBytes) / Double(totalBytes)) * 100.0)))
        }

        // 3. Battery via IOPowerSources (User-Space IOKit; graceful 100% AC fallback on Mac Pro Desktop)
        if let blob = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
           let list = IOPSCopyPowerSourcesList(blob)?.takeRetainedValue() as? [CFTypeRef],
           let first = list.first,
           let desc = IOPSGetPowerSourceDescription(blob, first)?.takeUnretainedValue() as? [String: Any] {
            if let cap = desc[kIOPSCurrentCapacityKey as String] as? Int {
                t.batteryPercent = cap
            }
            if let state = desc[kIOPSPowerSourceStateKey as String] as? String {
                t.isCharging = (state == kIOPSACPowerValue)
            }
        }

        // 4. Network Up/Down Throughput via getifaddrs (User-Space BSD socket stats)
        var ifaddrPtr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddrPtr) == 0, let firstAddr = ifaddrPtr {
            var totalIn: UInt64 = 0
            var totalOut: UInt64 = 0
            var ptr: UnsafeMutablePointer<ifaddrs>? = firstAddr
            while let current = ptr {
                let name = String(cString: current.pointee.ifa_name)
                if name.hasPrefix("en") || name.hasPrefix("utun"),
                   let data = current.pointee.ifa_data?.assumingMemoryBound(to: if_data.self) {
                    totalIn += UInt64(data.pointee.ifi_ibytes)
                    totalOut += UInt64(data.pointee.ifi_obytes)
                }
                ptr = current.pointee.ifa_next
            }
            freeifaddrs(firstAddr)
            let now = Date().timeIntervalSince1970
            let dt = max(0.5, now - prevTime)
            if prevNetIn > 0 && totalIn >= prevNetIn && totalOut >= prevNetOut {
                t.netDownKBps = Int(Double(totalIn - prevNetIn) / 1024.0 / dt)
                t.netUpKBps = Int(Double(totalOut - prevNetOut) / 1024.0 / dt)
            }
            prevNetIn = totalIn
            prevNetOut = totalOut
            prevTime = now
        }

        // 5. Thermal State + CPU Load correlation
        let baseTemp: Int
        switch ProcessInfo.processInfo.thermalState {
        case .nominal:  baseTemp = 44
        case .fair:     baseTemp = 56
        case .serious:  baseTemp = 72
        case .critical: baseTemp = 88
        @unknown default: baseTemp = 48
        }
        t.tempCelsius = min(96, baseTemp + Int(Double(t.cpuPercent) * 0.22))

        return t
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, WKScriptMessageHandler, NSWindowDelegate {
    private var statusItem: NSStatusItem!
    private var studioWindow: NSWindow?
    private var webView: WKWebView?
    private var timer: Timer?
    private let reader = LocalMacHardwareReader()
    private var compactMenuMode = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.autosaveName = "NALAHWSensorsV27StatusItem"
        updateStatusBarAndWebView()

        let menu = NSMenu()
        let headerItem = NSMenuItem(title: "🐈‍⬛ NALA-HWSensors v2.7 (Universal macOS arm64 + Intel)", action: nil, keyEquivalent: "")
        headerItem.isEnabled = false
        menu.addItem(headerItem)
        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "🎛️ Performance Command Center & 3D Relief öffnen", action: #selector(openStudioWindow), keyEquivalent: "d"))
        menu.addItem(NSMenuItem(title: "🏔️ Himalaya Biom (Grün → Braun → Fels → Schnee)", action: #selector(openHimalayaBiome), keyEquivalent: "h"))
        menu.addItem(NSMenuItem(title: "🖥️ 360° 3D Performance Relief Screensaver (Vollbild)", action: #selector(startScreensaverMode), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "⛶ Echtes macOS Vollbild umschalten", action: #selector(toggleWindowFullscreen), keyEquivalent: "f"))
        menu.addItem(NSMenuItem(title: "💾 macOS .saver Bildschirmschoner installieren", action: #selector(installSaverBundle), keyEquivalent: "i"))
        menu.addItem(NSMenuItem(title: "🔄 Menu-Bar Stil umschalten (Capsule ↔ Kompakt)", action: #selector(toggleMenuStyle), keyEquivalent: "m"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "🌙 Dream / REA / RSI 2-Klick Cockpit öffnen", action: #selector(openDreamCockpit), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Beenden (0 Daemons / 0 Rückstände)", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu

        timer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { [weak self] _ in
            self?.updateStatusBarAndWebView()
        }

        openStudioWindow()
    }

    private func updateStatusBarAndWebView() {
        let s = reader.sample()
        if let btn = statusItem.button {
            if compactMenuMode {
                btn.title = "💻\(s.cpuPercent)% 🔋\(s.batteryPercent)%"
            } else {
                btn.title = "💻 \(s.cpuPercent)% \(s.tempCelsius)°C | 📟 \(s.ramPercent)% | 🔋 \(s.batteryPercent)% | ↑\(s.netUpKBps)K ↓\(s.netDownKBps)K"
            }
            btn.font = NSFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .semibold)
        }

        if let wv = webView {
            let coresJSON = s.coreLoads.map(String.init).joined(separator: ",")
            let js = """
            if (window.updateNativeTelemetry) {
                window.updateNativeTelemetry({
                    cpuPercent: \(s.cpuPercent),
                    tempCelsius: \(s.tempCelsius),
                    ramPercent: \(s.ramPercent),
                    batteryPercent: \(s.batteryPercent),
                    netUpKBps: \(s.netUpKBps),
                    netDownKBps: \(s.netDownKBps),
                    logicalCores: \(s.logicalCores),
                    archLabel: "\(s.archLabel)",
                    coreLoads: [\(coresJSON)]
                });
            }
            """
            wv.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    @objc private func toggleMenuStyle() {
        compactMenuMode.toggle()
        updateStatusBarAndWebView()
    }

    @objc private func openStudioWindow() {
        ensureStudioWindowLoaded()
        NSApp.setActivationPolicy(.regular)
        studioWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func openHimalayaBiome() {
        openStudioWindow()
        webView?.evaluateJavaScript("if(window.setPalette) window.setPalette('himalaya');", completionHandler: nil)
    }

    @objc private func startScreensaverMode() {
        openStudioWindow()
        webView?.evaluateJavaScript("if(window.openScreensaver) window.openScreensaver(true);", completionHandler: nil)
    }

    @objc private func toggleWindowFullscreen() {
        ensureStudioWindowLoaded()
        guard let win = studioWindow else { return }
        NSApp.setActivationPolicy(.regular)
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        win.toggleFullScreen(nil)
    }

    private func enterWindowFullscreen() {
        ensureStudioWindowLoaded()
        guard let win = studioWindow else { return }
        NSApp.setActivationPolicy(.regular)
        win.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        if !win.styleMask.contains(.fullScreen) {
            win.toggleFullScreen(nil)
        }
    }

    private func exitWindowFullscreen() {
        guard let win = studioWindow else { return }
        if win.styleMask.contains(.fullScreen) {
            win.toggleFullScreen(nil)
        }
    }

    @objc private func installSaverBundle() {
        let fm = FileManager.default
        let userSaversDir = fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Screen Savers", isDirectory: true)
        try? fm.createDirectory(at: userSaversDir, withIntermediateDirectories: true)
        let destURL = userSaversDir.appendingPathComponent("NALA-HWSensors.saver", isDirectory: true)

        if let bundledSaver = Bundle.main.url(forResource: "NALA-HWSensors", withExtension: "saver") {
            try? fm.removeItem(at: destURL)
            try? fm.copyItem(at: bundledSaver, to: destURL)
        }
        NSWorkspace.shared.activateFileViewerSelecting([destURL])
    }

    @objc private func openDreamCockpit() {
        openStudioWindow()
        webView?.evaluateJavaScript("if(window.switchPresetLayout) window.switchPresetLayout('dream');", completionHandler: nil)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "nalaNative",
              let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }

        switch action {
        case "toggleFullscreen":
            toggleWindowFullscreen()
        case "enterFullscreen":
            enterWindowFullscreen()
        case "exitFullscreen":
            exitWindowFullscreen()
        case "installScreenSaver":
            installSaverBundle()
        default:
            break
        }
    }

    private func ensureStudioWindowLoaded() {
        if studioWindow != nil { return }
        let rect = NSRect(x: 0, y: 0, width: 1520, height: 940)
        let win = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        win.title = "NALA-HWSensors v2.7 — Universal macOS Performance Command Center & 360° 3D Relief"
        win.collectionBehavior = [.fullScreenPrimary, .managed, .fullScreenAllowsTiling]
        win.center()
        win.isReleasedWhenClosed = false
        win.delegate = self

        let cfg = WKWebViewConfiguration()
        cfg.userContentController.add(self, name: "nalaNative")
        cfg.preferences.setValue(true, forKey: "fullScreenEnabled")
        if #available(macOS 12.3, *) {
            cfg.preferences.isElementFullscreenEnabled = true
        }

        let wv = WKWebView(frame: rect, configuration: cfg)
        wv.autoresizingMask = [.width, .height]

        if let htmlURL = Bundle.main.url(forResource: "nala_hwsensors_v26_macos_studio", withExtension: "html", subdirectory: "ui") {
            wv.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        }
        win.contentView = wv
        self.webView = wv
        self.studioWindow = win
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
