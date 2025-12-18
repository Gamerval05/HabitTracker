//
//  HabitDetailViewModel.swift
//  HabitTracker
//
//  Created by Валера on 16.12.2025.
//

import Foundation

final class HabitDetailViewModel {

    private var habit: Habit
    private let storage: HabitStorageProtocol

    var onHabitUpdated: ((Habit) -> Void)?

    init(habit: Habit, storage: HabitStorageProtocol = HabitStorage()) {
        self.habit = habit
        self.storage = storage
    }

    var titleText: String {
        habit.title
    }

    var statusText: String {
        habit.isCompleted ? "Выполнено сегодня" : "Не выполнено"
    }

    var streakText: String {
        "🔥 \(habit.streak) дней"
    }

    func toggleCompletion() {
        habit.isCompleted.toggle()
        habit.streak = habit.isCompleted ? habit.streak + 1 : max(0, habit.streak - 1)
        storage.updateHabit(habit)
        onHabitUpdated?(habit)
    }
}
