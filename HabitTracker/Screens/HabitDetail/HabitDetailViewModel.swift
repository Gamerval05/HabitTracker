//
//  HabitDetailViewModel.swift
//  HabitTracker
//
//  Created by Валера on 16.12.2025.
//

import Foundation

final class HabitDetailViewModel {

    // MARK: - Properties
    private var habit: Habit

    // MARK: - Init
    init(habit: Habit) {
        self.habit = habit
    }

    // MARK: - Data for View
    var titleText: String {
        habit.title
    }

    var statusText: String {
        habit.isCompleted ? "Выполнено сегодня" : "Не выполнено"
    }

    var streakText: String {
        "🔥 \(habit.streak) дней"
    }

    // MARK: - Actions
    func toggleCompletion() {
        if habit.isCompleted {
            habit.isCompleted = false
            habit.streak = max(0, habit.streak - 1)
        } else {
            habit.isCompleted = true
            habit.streak += 1
        }
    }

    // MARK: - Output
    func currentHabit() -> Habit {
        habit
    }
}
