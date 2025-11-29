//
//  HabitListViewModel.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation
import Combine

final class HabitListViewModel {
    
    // MARK: - Properties
    @Published var habits: [Habit] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let habitRepository: HabitRepository
    private var cancellables = Set<AnyCancellable>()
    
    var currentStreak: Int {
        habits.filter { $0.isCompleted }.max { $0.streak < $1.streak }?.streak ?? 0
    }
    
    var todayProgress: Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompleted }.count
        return Double(completed) / Double(habits.count)
    }
    
    // MARK: - Init
    init(habitRepository: HabitRepository = HabitRepository()) {
        self.habitRepository = habitRepository
        setupBindings()
    }
    
    // MARK: - Methods
    private func setupBindings() {
        NotificationCenter.default
            .publisher(for: .habitAdded)
            .sink { [weak self] _ in
                self?.fetchHabits()
            }
            .store(in: &cancellables)
    }
    
    func fetchHabits() {
        isLoading = true
        
        Task {
            do {
                let fetchedHabits = try await habitRepository.fetchAllHabits()
                await MainActor.run {
                    self.habits = fetchedHabits
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func toggleHabitCompletion(at index: Int) {
        guard index < habits.count else { return }
        
        var habit = habits[index]
        habit = Habit(
            id: habit.id,
            title: habit.title,
            category: habit.category,
            frequency: habit.frequency,
            reminderTime: habit.reminderTime,
            notes: habit.notes,
            streak: habit.isCompleted ? habit.streak : habit.streak + 1,
            lastCompletedDate: habit.isCompleted ? nil : Date(),
            createdDate: habit.createdDate,
            isCompleted: !habit.isCompleted
        )
        
        Task {
            do {
                try await habitRepository.updateHabit(habit)
                await MainActor.run {
                    self.habits[index] = habit
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func deleteHabit(at index: Int) {
        guard index < habits.count else { return }
        let habit = habits[index]
        
        Task {
            do {
                try await habitRepository.deleteHabit(habit)
                await MainActor.run {
                    self.habits.remove(at: index)
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let habitAdded = Notification.Name("habitAdded")
    static let habitUpdated = Notification.Name("habitUpdated")
    static let habitDeleted = Notification.Name("habitDeleted")
}
