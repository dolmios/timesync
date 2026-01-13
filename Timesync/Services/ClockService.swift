import Foundation

/// Shared time provider for consistent time updates across the app
class ClockService: ObservableObject {
    static let shared = ClockService()

    @Published var currentDate: Date = Date()
    private var timer: Timer?
    private var isActive = true

    init() {
        startTimer()
    }

    /// Pause time updates (for when menu bar is closed)
    func pause() {
        isActive = false
    }

    /// Resume time updates (for when menu bar is opened)
    func resume() {
        isActive = true
        currentDate = Date()
    }

    private func startTimer() {
        timer = Timer(timeInterval: AppConstants.timerInterval, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self, self.isActive else { return }
                self.currentDate = Date()
            }
        }
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    deinit {
        timer?.invalidate()
    }
}
