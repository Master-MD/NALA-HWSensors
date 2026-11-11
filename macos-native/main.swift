import AppKit
import WebKit
import Darwin

final class Monitor {
    private var previous: (UInt64, UInt64)?
    func cpu() -> Double? {
        var info = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &info) { p in
            p.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return nil }
        let t = info.cpu_ticks
        let idle = UInt64(t.2)
        let total = UInt64(t.0) + UInt64(t.1) + idle + UInt64(t.3)
        defer { previous = (total, idle) }
        guard let old = previous, total > old.0, idle >= old.1 else { return nil }
        return 100 * (1 - Double(idle - old.1) / Double(total - old.0))
    }
    func memory() -> (Double, Double)? {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &stats) { p in
            p.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return nil }
        let pages = UInt64(stats.active_count) + UInt64(stats.wire_count) + UInt64(stats.compressor_page_count)
        return (Double(pages) * Double(vm_kernel_page_size) / 1_073_741_824, Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824)
    }
    func disk() -> Double? {
        var fs = statfs()
        guard statfs("/", &fs) == 0, fs.f_blocks > 0 else { return nil }
        return Double(fs.f_bavail) / Double(fs.f_blocks) * 100
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
    let monitor = Monitor()
    var item: NSStatusItem!
    var widgets: [String: NSStatusItem] = [:]
    let widgetNames = ["CPU", "RAM", "Disk"]
    var timer: Timer?
    var studio: NSWindow?
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Launch Services can start separate copies (for example from a mounted DMG).
        if let id = Bundle.main.bundleIdentifier,
           NSRunningApplication.runningApplications(withBundleIdentifier: id).contains(where: { $0.processIdentifier != ProcessInfo.processInfo.processIdentifier }) {
            NSApp.terminate(nil)
            return
        }
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.autosaveName = NSStatusItem.AutosaveName("NALA-HWSensors.anchor")
        item.button?.title = "◈"
        for name in widgetNames where UserDefaults.standard.object(forKey: "widget." + name) == nil {
            UserDefaults.standard.set(name != "Disk", forKey: "widget." + name)
        }
        rebuildWidgets()
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in self?.update() }
    }
    func rebuildWidgets() {
        for name in widgetNames {
            let enabled = UserDefaults.standard.bool(forKey: "widget." + name)
            if enabled && widgets[name] == nil {
                let status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                status.autosaveName = NSStatusItem.AutosaveName("NALA-HWSensors." + name)
                widgets[name] = status
            } else if !enabled, let status = widgets.removeValue(forKey: name) {
                NSStatusBar.system.removeStatusItem(status)
            }
        }
        let menu = NSMenu()
        menu.addItem(withTitle: "Dieser Mac · Livewerte", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        for name in widgetNames {
            let entry = NSMenuItem(title: name + " anzeigen", action: #selector(toggleWidget(_:)), keyEquivalent: "")
            entry.target = self
            entry.representedObject = name
            entry.state = UserDefaults.standard.bool(forKey: "widget." + name) ? .on : .off
            menu.addItem(entry)
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Studio öffnen (Demo)", action: #selector(openStudio), keyEquivalent: "")
        menu.addItem(withTitle: "Beenden", action: #selector(quit), keyEquivalent: "q")
        item.menu = menu
        // Separate menus are required because an NSMenu can have only one owner.
        for status in widgets.values { status.menu = menu.copy() as? NSMenu }
    }
    @objc func toggleWidget(_ sender: NSMenuItem) {
        guard let name = sender.representedObject as? String else { return }
        let key = "widget." + name
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
        rebuildWidgets()
        update()
    }
    func update() {
        let cpu = monitor.cpu().map { String(format: "%.0f%%", $0) } ?? "—"
        let ram = monitor.memory().map { String(format: "%.1f / %.0f GB", $0.0, $0.1) } ?? "—"
        let disk = monitor.disk().map { String(format: "%.0f%% frei", $0) } ?? "—"
        widgets["CPU"]?.button?.title = "CPU " + cpu
        widgets["RAM"]?.button?.title = "RAM " + ram
        widgets["Disk"]?.button?.title = "SSD " + disk
        item.menu?.item(at: 0)?.title = "CPU " + cpu + " · RAM " + ram + " · SSD " + disk
        for status in widgets.values { status.menu?.item(at: 0)?.title = item.menu?.item(at: 0)?.title ?? "Dieser Mac" }
    }
    @objc func openStudio() {
        if let studio = studio { studio.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true); return }
        guard let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "ui") else { return }
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        let web = WKWebView(frame: .zero, configuration: configuration)
        web.navigationDelegate = self
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1100, height: 760), styleMask: [.titled, .closable, .resizable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "NALA Studio — demo data"
        window.contentView = web
        window.isReleasedWhenClosed = false
        studio = window
        web.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        window.center(); window.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true)
    }
    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = action.request.url, url.isFileURL, let base = Bundle.main.resourceURL?.appendingPathComponent("ui").standardizedFileURL.path, url.standardizedFileURL.path.hasPrefix(base + "/") else { decisionHandler(.cancel); return }
        decisionHandler(.allow)
    }
    @objc func quit() { NSApp.terminate(nil) }
}
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
