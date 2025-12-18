import Foundation

final class HabitListViewModel {

    private let storage: HabitStorageProtocol

    enum SortType {
        case byCompletion
        case byStreak
    }

    private(set) var sortType: SortType = .byCompletion

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

    init(storage: HabitStorageProtocol = HabitStorage()) {
        self.storage = storage
        self.habits = storage.loadHabits()
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
        storage.saveHabits(habits)
    }

    func deleteHabit(at index: Int) {
        let id = sortedHabits[index].id
        habits.removeAll { $0.id == id }
        storage.saveHabits(habits)
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
        storage.saveHabits(habits)
    }

    func updateHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        storage.updateHabit(habit)
    }

    func progress() -> Float {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompleted }.count
        return Float(completed) / Float(habits.count)
    }

    func changeSort(to type: SortType) {
        sortType = type
    }
}
