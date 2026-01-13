import AppKit
import Combine
import Foundation
import OSLog
import ServiceManagement

extension Logger {
    static let preferences = Logger(subsystem: "com.dolmios.timesync", category: "AppPreferences")
}

class AppPreferences: ObservableObject {
    static let shared = AppPreferences()

    @Published var use24HourTime: Bool {
        didSet {
            UserDefaults.standard.set(use24HourTime, forKey: "use24HourTime")
        }
    }

    @Published var launchOnLogin: Bool {
        didSet {
            setLaunchOnLogin(launchOnLogin)
        }
    }

    private init() {
        self.use24HourTime = UserDefaults.standard.object(forKey: "use24HourTime") as? Bool ?? true

        let launchOnLoginValue: Bool
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            launchOnLoginValue = service.status == .enabled
        } else {
            launchOnLoginValue = false
        }
        self.launchOnLogin = launchOnLoginValue
    }

    private func setLaunchOnLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            do {
                if enabled {
                    try service.register()
                } else {
                    try service.unregister()
                }
            } catch {
                Logger.preferences.error(
                    "Failed to \(enabled ? "register" : "unregister") launch on login: \(error.localizedDescription)"
                )
            }
        }
    }
}
