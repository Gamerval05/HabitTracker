import Foundation

// MARK: - Habit Model
struct Habit: Codable {
    // MARK: - Properties
    var id: UUID = UUID()
    let title: String
    var isCompleted: Bool
    var streak: Int
    var lastCompletedDate: Date?

    // MARK: - Initializer
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.streak = 0
        self.lastCompletedDate = nil
    }
}
