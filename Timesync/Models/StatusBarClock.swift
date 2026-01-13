import Combine
import Foundation

class StatusBarClock: ObservableObject {
    @Published var currentDate: Date = Date()
    private let timeProvider = ClockService.shared

    init() {
        currentDate = timeProvider.currentDate
        cancellable = timeProvider.$currentDate.sink { [weak self] newDate in
            self?.currentDate = newDate
        }
    }

    private var cancellable: AnyCancellable?
}
