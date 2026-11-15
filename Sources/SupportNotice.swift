import AppKit
import Foundation

enum SupportNotice {
    static let app = "ChimpiNotch"
    static let policyURL = URL(string: "https://raw.githubusercontent.com/Chimpi-hackintosh/ChimpiBlender-Online/main/support-policy.json")!
    static let tableURL = URL(string: "https://chimpi-hackintosh.github.io/ChimpiBlender-Online/support.html")!
    static let cutoff = ISO8601DateFormatter().date(from: "2026-11-04T00:00:00Z")!

    static func version(_ raw: String) -> [Int]? {
        guard raw.count <= 100, raw.range(of: "^v?[0-9]+\\.[0-9]+\\.[0-9]+(?:[-+][A-Za-z0-9.-]+)?$", options: .regularExpression) != nil else { return nil }
        let core = raw.trimmingCharacters(in: CharacterSet(charactersIn: "v")).components(separatedBy: CharacterSet(charactersIn: "-+"))[0]
        let values = core.split(separator: ".").compactMap { Int($0) }
        return values.count == 3 ? values : nil
    }

    static func older(_ current: String, than minimum: String) -> Bool {
        guard let left = version(current), let right = version(minimum) else { return false }
        return left.lexicographicallyPrecedes(right)
    }

    static func official(_ raw: String) -> URL? {
        guard let url = URL(string: raw), url.scheme == "https", url.host == "github.com",
              url.user == nil, url.password == nil, url.port == nil, url.query == nil, url.fragment == nil,
              url.pathComponents.count >= 3, url.pathComponents[1] == "Chimpi-hackintosh", url.pathComponents[2] == app else { return nil }
        return url
    }

    static func entry(_ policy: [String: Any]) -> [String: Any]? {
        guard policy["schema"] as? Int == 1, let apps = policy["apps"] as? [String: Any],
              let value = apps[app] as? [String: Any], value["repo"] as? String == app,
              let minimum = value["minimum"] as? String, version(minimum) != nil,
              let url = value["url"] as? String, official(url) != nil else { return nil }
        return value
    }

    static func load(_ name: String) -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url), let value = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return value
    }

    static func check() {
        guard ProcessInfo.processInfo.environment["CHIMPI_SUPPORT_CHECK"] != "0",
              let bundled = load("support-policy"), let fallback = entry(bundled),
              let current = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let messages = load("support-messages") as? [String: [String: String]] else { return }
        var request = URLRequest(url: policyURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 4)
        request.setValue("Chimpi-support-check/1", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { data, response, _ in
            var selected = fallback
            if let data = data, data.count <= 262144,
               let response = response as? HTTPURLResponse, response.statusCode == 200, response.url?.host == policyURL.host,
               let remote = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidate = entry(remote), let minimum = candidate["minimum"] as? String,
               !older(minimum, than: fallback["minimum"] as! String) { selected = candidate }
            guard let minimum = selected["minimum"] as? String, older(current, than: minimum),
                  let raw = selected["url"] as? String, let url = official(raw) else { return }
            let values = selected
            DispatchQueue.main.async {
                let language = (Locale.preferredLanguages.first ?? "en").replacingOccurrences(of: "_", with: "-").components(separatedBy: "-")[0]
                let tr = messages["en", default: [:]].merging(messages[language, default: [:]]) { _, translated in translated }
                let phase = Date() >= cutoff ? "after" : "before"
                let variables = ["app": "ChimpiNotch", "current": current, "minimum": minimum, "latest": values["tag"] as? String ?? minimum]
                func format(_ key: String) -> String {
                    variables.reduce(tr[key, default: key]) { $0.replacingOccurrences(of: "{\($1.key)}", with: $1.value) }
                }
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.messageText = format(phase)
                alert.informativeText = [format("body_" + phase), format("risk"), format("versions")].joined(separator: "\n\n")
                alert.addButton(withTitle: format("update"))
                alert.addButton(withTitle: format("later"))
                alert.addButton(withTitle: format("table"))
                NSApp.activate(ignoringOtherApps: true)
                switch alert.runModal() {
                case .alertFirstButtonReturn: NSWorkspace.shared.open(url)
                case .alertThirdButtonReturn: NSWorkspace.shared.open(tableURL)
                default: break
                }
            }
        }.resume()
    }
}
