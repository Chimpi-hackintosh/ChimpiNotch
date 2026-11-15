import AppKit
import SwiftUI

@main
struct ChimpiNotchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            Text("ChimpiNotch").padding(24)
        }
    }
}

struct Browser: Identifiable {
    let name: String
    let id: String

    static let known: [Browser] = [
        Browser(name: "Chrome", id: "com.google.Chrome"),
        Browser(name: "Safari", id: "com.apple.Safari"),
        Browser(name: "Firefox", id: "org.mozilla.firefox"),
        Browser(name: "Microsoft Edge", id: "com.microsoft.edgemac"),
        Browser(name: "Brave", id: "com.brave.Browser"),
        Browser(name: "Opera", id: "com.operasoftware.Opera"),
        Browser(name: "Arc", id: "company.thebrowser.Browser")
    ]

    static var installed: [Browser] {
        known.filter {
            NSWorkspace.shared.urlForApplication(withBundleIdentifier: $0.id) != nil
        }
    }
}

enum Launcher {
    static func open(_ bundleID: String, fallback: String? = nil) {
        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID)
            ?? fallback.map { URL(fileURLWithPath: $0) }
        guard let url = url, FileManager.default.fileExists(atPath: url.path) else {
            alert("Aplicativo não encontrado")
            return
        }
        NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration()) {
            _, error in
            if let error = error {
                DispatchQueue.main.async { alert(error.localizedDescription) }
            }
        }
    }

    static func alert(_ description: String) {
        let dialog = NSAlert()
        dialog.messageText = "ChimpiNotch"
        dialog.informativeText = description
        dialog.runModal()
    }
}

struct NotchBar: View {
    var body: some View {
        HStack(spacing: 0) {
            Menu {
                ForEach(Browser.installed) { browser in
                    Button(browser.name) { Launcher.open(browser.id) }
                }
            } label: {
                Label("Chrome / navegadores", systemImage: "globe")
                    .frame(width: 215, height: 50)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            divider
            Button {
                Launcher.open("com.apple.AddressBook",
                    fallback: "/System/Applications/Contacts.app")
            } label: {
                Label("Contatos", systemImage: "person.crop.circle")
                    .frame(width: 112, height: 50)
            }
            .buttonStyle(.plain)
            divider
            Button {
                Launcher.open("com.apple.PhotoBooth",
                    fallback: "/System/Applications/Photo Booth.app")
            } label: {
                Label("Câmera", systemImage: "camera.fill")
                    .frame(width: 110, height: 50)
            }
            .buttonStyle(.plain)
        }
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.white)
        .frame(width: 458, height: 52)
        .background(RoundedRectangle(cornerRadius: 23)
            .fill(Color(red: 0.055, green: 0.063, blue: 0.080).opacity(0.97)))
        .overlay(RoundedRectangle(cornerRadius: 23)
            .strokeBorder(Color.white.opacity(0.17)))
        .frame(width: 480, height: 68)
        .accessibilityLabel("ChimpiNotch: navegadores, contatos e câmera")
    }

    private var divider: some View {
        Rectangle().fill(Color.white.opacity(0.23))
            .frame(width: 1, height: 23)
    }
}

final class NotchPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: NSPanel?
    private var status: NSStatusItem?
    private let panelSize = NSSize(width: 480, height: 68)

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        let window = NotchPanel(
            contentRect: NSRect(origin: .zero, size: panelSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered, defer: false)
        window.title = "ChimpiNotch"
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .statusBar
        window.hidesOnDeactivate = false
        window.isMovableByWindowBackground = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.contentView = NSHostingView(rootView: NotchBar())
        panel = window
        center()
        window.orderFrontRegardless()
        setupMenu()
        SupportNotice.check()
        NotificationCenter.default.addObserver(
            self, selector: #selector(recenter),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil)
    }

    private func setupMenu() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.image = NSImage(
            systemSymbolName: "rectangle.topthird.inset.filled",
            accessibilityDescription: "ChimpiNotch")
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Mostrar / esconder",
                                action: #selector(toggle), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Centralizar",
                                action: #selector(recenter), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Sair",
                                action: #selector(quit), keyEquivalent: "q"))
        for entry in menu.items { entry.target = self }
        item.menu = menu
        status = item
    }

    private func center() {
        guard let panel = panel,
              let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        let safe = screen.safeAreaInsets.top
        let top: CGFloat = safe > 30 ? safe + 6 : 6
        panel.setFrameOrigin(NSPoint(
            x: screen.frame.midX - panelSize.width / 2,
            y: screen.frame.maxY - top - panelSize.height))
    }

    @objc private func toggle() {
        guard let panel = panel else { return }
        if panel.isVisible { panel.orderOut(nil) }
        else { panel.orderFrontRegardless() }
    }

    @objc private func recenter() {
        center()
        panel?.orderFrontRegardless()
    }

    @objc private func quit() { NSApp.terminate(nil) }
}
