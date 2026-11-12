import Cocoa
import ScreenSaver
import WebKit
import Darwin

// ============================================================================
// NALA-HWSensors v2.7 — Native macOS ScreenSaverView (.saver Bundle)
// Universal 2 Binary (arm64 Apple Silicon + x86_64 Intel Mac Pro / MacBook Pro)
// Renders the 60 FPS True-3D Mountain Relief in 360° Planetary Orbit with
// Live Per-Core Mach host_processor_info Telemetry!
// ============================================================================

@objc(NALAHWSensorsScreenSaverView)
final class NALAHWSensorsScreenSaverView: ScreenSaverView {
    private var webView: WKWebView?
    private var prevCoreTicks: [(user: UInt32, sys: UInt32, idle: UInt32, nice: UInt32)] = []
    private var tickCounter: Int = 0

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1.0
        setupWebView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.animationTimeInterval = 1.0
        setupWebView()
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: bounds, configuration: config)
        wv.autoresizingMask = [.width, .height]
        wv.setValue(false, forKey: "drawsBackground")
        addSubview(wv)
        self.webView = wv

        let bundle = Bundle(for: NALAHWSensorsScreenSaverView.self)
        if let htmlPath = bundle.path(forResource: "nala_hwsensors_v26_macos_studio", ofType: "html", inDirectory: "ui") {
            let fileURL = URL(fileURLWithPath: htmlPath)
            var comps = URLComponents(url: fileURL, resolvingAgainstBaseURL: false)
            comps?.queryItems = [
                URLQueryItem(name: "biome", value: "himalaya"),
                URLQueryItem(name: "saver", value: "1"),
                URLQueryItem(name: "orbit", value: "1")
            ]
            if let finalURL = comps?.url {
                wv.loadFileURL(finalURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
            } else {
                wv.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
            }
        }
    }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        webView?.frame = NSRect(origin: .zero, size: newSize)
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        tickCounter += 1
        let (avgLoad, perCore) = readMachPerCoreCPULoad()
        guard let wv = webView, !perCore.isEmpty else { return }
        let coresJS = perCore.map { String(format: "%.1f", $0) }.joined(separator: ",")
        let js = """
        if (window.updateFromNativeTelemetry) {
            window.updateFromNativeTelemetry({
                cpuLoad: \(String(format: "%.1f", avgLoad)),
                coreLoads: [\(coresJS)],
                logicalCores: \(perCore.count),
                arch: "\(currentArchName())"
            });
        }
        """
        wv.evaluateJavaScript(js, completionHandler: nil)
    }

    override var hasConfigureSheet: Bool {
        return false
    }

    override var configureSheet: NSWindow? {
        return nil
    }

    private func currentArchName() -> String {
        #if arch(arm64)
        return "arm64 (Apple Silicon)"
        #elseif arch(x86_64)
        return "x86_64 (Intel Mac)"
        #else
        return "Universal"
        #endif
    }

    private func readMachPerCoreCPULoad() -> (Double, [Double]) {
        var numCPUsU: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCpuInfo: mach_msg_type_number_t = 0

        let kr = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &numCPUsU,
            &cpuInfo,
            &numCpuInfo
        )
        guard kr == KERN_SUCCESS, let info = cpuInfo else {
            return (34.0, [])
        }
        defer {
            let deallocSize = vm_size_t(numCpuInfo) * vm_size_t(MemoryLayout<integer_t>.stride)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: info), deallocSize)
        }

        let count = Int(numCPUsU)
        var loads: [Double] = []
        loads.reserveCapacity(count)
        var newTicks: [(user: UInt32, sys: UInt32, idle: UInt32, nice: UInt32)] = []
        newTicks.reserveCapacity(count)

        var sumLoad = 0.0
        for i in 0..<count {
            let base = Int(CPU_STATE_MAX) * i
            let user = UInt32(bitPattern: info[base + Int(CPU_STATE_USER)])
            let sys  = UInt32(bitPattern: info[base + Int(CPU_STATE_SYSTEM)])
            let idle = UInt32(bitPattern: info[base + Int(CPU_STATE_IDLE)])
            let nice = UInt32(bitPattern: info[base + Int(CPU_STATE_NICE)])
            newTicks.append((user, sys, idle, nice))

            if i < prevCoreTicks.count {
                let prev = prevCoreTicks[i]
                let dUser = user &- prev.user
                let dSys  = sys  &- prev.sys
                let dIdle = idle &- prev.idle
                let dNice = nice &- prev.nice
                let total = dUser &+ dSys &+ dIdle &+ dNice
                let busy  = dUser &+ dSys &+ dNice
                let pct = total > 0 ? (Double(busy) / Double(total)) * 100.0 : 12.0
                let clamped = min(100.0, max(1.0, pct))
                loads.append(clamped)
                sumLoad += clamped
            } else {
                loads.append(25.0)
                sumLoad += 25.0
            }
        }
        prevCoreTicks = newTicks
        let avg = count > 0 ? (sumLoad / Double(count)) : 28.0
        return (avg, loads)
    }
}
