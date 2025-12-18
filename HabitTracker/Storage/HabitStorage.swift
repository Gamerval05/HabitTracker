import Foundation

protocol HabitStorageProtocol {
    func loadHabits() -> [Habit]
    func saveHabits(_ habits: [Habit])
    func updateHabit(_ habit: Habit)
}

final class HabitStorage: HabitStorageProtocol {

    private let storageKey = "habits_storage_key"

    func loadHabits() -> [Habit] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let habits = try? JSONDecoder().decode([Habit].self, from: data)
        else {
            return []
        }
        return habits
    }

    func saveHabits(_ habits: [Habit]) {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func updateHabit(_ habit: Habit) {
        var habits = loadHabits()
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        saveHabits(habits)
    }
}
