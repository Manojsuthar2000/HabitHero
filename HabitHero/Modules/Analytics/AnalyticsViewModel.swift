//
//  AnalyticsViewModel.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import Foundation
import Combine

final class AnalyticsViewModel {
    
    // MARK: - Published Properties
    @Published var habits: [Habit] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Dependencies
    private let habitRepository: HabitRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    /// Total number of habits
    var totalHabits: Int {
        habits.count
    }
    
    /// Number of habits completed today
    var completedToday: Int {
        habits.filter { $0.isCompleted }.count
    }
    
    /// Today's completion percentage (0-100)
    var completionRate: Int {
        guard totalHabits > 0 else { return 0 }
        return Int((Double(completedToday) / Double(totalHabits)) * 100)
    }
    
    /// Best streak across all habits
    var bestStreak: Int {
        habits.map { $0.streak }.max() ?? 0
    }
    
    /// Current active streak (habits completed today)
    var currentStreak: Int {
        let completedHabits = habits.filter { $0.isCompleted }
        return completedHabits.map { $0.streak }.max() ?? 0
    }
    
    /// Total completions across all habits
    var totalCompletions: Int {
        habits.reduce(0) { $0 + $1.streak }
    }
    
    /// Category breakdown with completion stats
    var categoryStats: [CategoryStat] {
        var stats: [HabitCategory: (total: Int, completed: Int, totalStreak: Int)] = [:]
        
        for habit in habits {
            let current = stats[habit.category] ?? (0, 0, 0)
            stats[habit.category] = (
                current.total + 1,
                current.completed + (habit.isCompleted ? 1 : 0),
                current.totalStreak + habit.streak
            )
        }
        
        return stats.map { category, data in
            CategoryStat(
                category: category,
                totalHabits: data.total,
                completedToday: data.completed,
                totalStreak: data.totalStreak
            )
        }.sorted { $0.totalHabits > $1.totalHabits }
    }
    
    /// Weekly data for chart (last 7 days)
    var weeklyData: [DayData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<7).reversed().map { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else {
                return DayData(date: today, completedCount: 0, totalCount: habits.count)
            }
            
            // For simplicity, we'll use today's total as baseline
            // In a real app, you'd track historical data
            let isToday = daysAgo == 0
            let completedCount = isToday ? completedToday : estimateCompletions(for: date)
            
            return DayData(
                date: date,
                completedCount: completedCount,
                totalCount: max(habits.count, 1)
            )
        }
    }
    
    /// Top performing habits by streak
    var topHabits: [Habit] {
        habits.sorted { $0.streak > $1.streak }.prefix(5).map { $0 }
    }
    
    /// Habits that need attention (not completed today)
    var habitsNeedingAttention: [Habit] {
        habits.filter { !$0.isCompleted }
    }
    
    // MARK: - Init
    init(habitRepository: HabitRepository = HabitRepository()) {
        self.habitRepository = habitRepository
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Listen for habit changes
        NotificationCenter.default.publisher(for: .habitAdded)
            .merge(with: NotificationCenter.default.publisher(for: .habitUpdated))
            .merge(with: NotificationCenter.default.publisher(for: .habitDeleted))
            .sink { [weak self] _ in
                self?.fetchHabits()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
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
    
    // MARK: - Helpers
    private func estimateCompletions(for date: Date) -> Int {
        // Estimate past completions based on streaks
        // This is a simplified estimation - in production you'd store historical data
        let calendar = Calendar.current
        let daysAgo = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        var estimated = 0
        for habit in habits {
            if habit.streak > daysAgo {
                estimated += 1
            }
        }
        return estimated
    }
}

// MARK: - Supporting Models

struct CategoryStat {
    let category: HabitCategory
    let totalHabits: Int
    let completedToday: Int
    let totalStreak: Int
    
    var completionRate: Double {
        guard totalHabits > 0 else { return 0 }
        return Double(completedToday) / Double(totalHabits)
    }
    
    var averageStreak: Double {
        guard totalHabits > 0 else { return 0 }
        return Double(totalStreak) / Double(totalHabits)
    }
}

struct DayData {
    let date: Date
    let completedCount: Int
    let totalCount: Int
    
    var completionRate: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}
