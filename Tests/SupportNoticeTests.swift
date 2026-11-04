import Foundation

@main
enum Tests {
    static func main() {
        precondition(SupportNotice.older("1.0.3", than: "1.0.4"))
        precondition(!SupportNotice.older("1.0.4", than: "1.0.4"))
        precondition(!SupportNotice.older("1.10.0", than: "1.9.0"))
        precondition(!SupportNotice.older("unknown", than: "1.0.4"))
        precondition(SupportNotice.version("1.0.4-build-8") == [1, 0, 4])
        precondition(SupportNotice.official("https://evil.test/") == nil)
        precondition(SupportNotice.official("https://github.com/other/ChimpiNotch") == nil)
        precondition(SupportNotice.official("https://github.com/Chimpi-hackintosh/ChimpiNotch/releases/tag/v1.0.4") != nil)
        precondition(SupportNotice.cutoff == ISO8601DateFormatter().date(from: "2026-11-04T00:00:00Z"))
        print("9 support notice checks passed")
    }
}
