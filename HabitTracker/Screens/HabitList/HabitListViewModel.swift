import Foundation

final class HabitListViewModel {

    enum SortType {
        case byCompletion
        case byStreak
    }

    private(set) var sortType: SortType = .byCompletion

    private let storageKey = "habits_storage"

    private(set) var habits: [Habit] = []

    private var sortedHabits: [Habit] {
        switch sortType {
        case .byCompletion:
            return habits.sorted {
                if $0.isCompleted != $1.isCompleted {
                    return $0.isCompleted == false
                }
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .byStreak:
            return habits.sorted {
                if $0.streak != $1.streak {
                    return $0.streak > $1.streak
                }
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }

    // MARK: - Public API

    func numberOfHabits() -> Int {
        sortedHabits.count
    }

    func habit(at index: Int) -> Habit {
        sortedHabits[index]
    }

    func addHabit(title: String) {
        let habit = Habit(title: title)
        habits.append(habit)
        saveHabits()
    }

    func deleteHabit(at index: Int) {
        let id = sortedHabits[index].id
        habits.removeAll { $0.id == id }
        saveHabits()
    }

    func toggleHabitCompleted(at index: Int) {
        let id = sortedHabits[index].id
        guard let realIndex = habits.firstIndex(where: { $0.id == id }) else { return }

        var habit = habits[realIndex]

        if habit.isCompleted {
            habit.isCompleted = false
            habit.streak = 0
            habit.lastCompletedDate = nil
        } else {
            habit.isCompleted = true
            habit.streak += 1
            habit.lastCompletedDate = Date()
        }

        habits[realIndex] = habit
        saveHabits()
    }

    func updateHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        saveHabits()
    }

    func progress() -> Float {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompleted }.count
        return Float(completed) / Float(habits.count)
    }

    func changeSort(to type: SortType) {
        sortType = type
    }

    // MARK: - Persistence

    func loadHabits() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }

    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
