import AppKit
import Combine
import OSLog
import SwiftUI

@main
struct TimesyncApp: App {
    @StateObject private var timezoneSelection = TimezoneSelection()
    @StateObject private var preferences = AppPreferences.shared
    @StateObject private var statusBarClock = StatusBarClock()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            WindowContentView()
                .environmentObject(timezoneSelection)
                .environmentObject(preferences)
        } label: {
            StatusBarView()
                .environmentObject(timezoneSelection)
                .environmentObject(statusBarClock)
                .environmentObject(preferences)
        }
        .menuBarExtraStyle(.window)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupLaunchOnLogin()
        hideDockIcon()
    }

    private func setupLaunchOnLogin() {
        if !AppPreferences.shared.launchOnLogin {
            AppPreferences.shared.launchOnLogin = true
        }
    }

    private func hideDockIcon() {
        NSApp.setActivationPolicy(.accessory)
    }
}
