//
//  AddHabitViewModel.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation
import Combine

final class AddHabitViewModel {
    
    // MARK: - Published Properties
    @Published var habitName: String = ""
    @Published var selectedCategory: HabitCategory = .other
    @Published var selectedFrequency: HabitFrequency = .daily
    @Published var reminderTime: Date?
    @Published var notes: String = ""
    @Published var isReminderEnabled: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var aiSuggestion: String?
    @Published var isLoadingAISuggestion: Bool = false
    
    // MARK: - Validation
    @Published var nameError: String?
    
    var isFormValid: Bool {
        return !habitName.trimmed.isEmpty && habitName.trimmed.count >= 3
    }
    
    // MARK: - Dependencies
    private let habitRepository: HabitRepository
    private let aiService: OpenAIService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        habitRepository: HabitRepository = HabitRepository(),
        aiService: OpenAIService = .shared
    ) {
        self.habitRepository = habitRepository
        self.aiService = aiService
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Clear name error when user types
        $habitName
            .sink { [weak self] _ in
                self?.nameError = nil
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Validation
    func validateForm() -> Bool {
        guard !habitName.trimmed.isEmpty else {
            nameError = "Habit name is required"
            return false
        }
        
        guard habitName.trimmed.count >= 3 else {
            nameError = "Habit name must be at least 3 characters"
            return false
        }
        
        guard habitName.trimmed.count <= 50 else {
            nameError = "Habit name must be less than 50 characters"
            return false
        }
        
        nameError = nil
        return true
    }
    
    // MARK: - Save Habit
    func saveHabit() async throws {
        guard validateForm() else {
            throw AddHabitError.invalidForm
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let habit = Habit(
            title: habitName.trimmed,
            category: selectedCategory,
            frequency: selectedFrequency,
            reminderTime: isReminderEnabled ? reminderTime : nil,
            notes: notes.trimmed.isEmpty ? nil : notes.trimmed,
            streak: 0,
            lastCompletedDate: nil,
            createdDate: Date(),
            isCompleted: false
        )
        
        try await habitRepository.saveHabit(habit)
        
        // Schedule notification if enabled
        if isReminderEnabled, let reminderTime = reminderTime {
            NotificationManager.shared.scheduleHabitReminder(for: habit)
        }
    }
    
    // MARK: - AI Suggestions
    func getAISuggestion(for goal: String) async {
        guard !goal.trimmed.isEmpty else { return }
        
        isLoadingAISuggestion = true
        aiSuggestion = nil
        
        do {
            let suggestion = try await aiService.generateHabitSuggestion(for: goal)
            await MainActor.run {
                self.aiSuggestion = suggestion
                self.isLoadingAISuggestion = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoadingAISuggestion = false
            }
        }
    }
    
    // MARK: - Quick Suggestions
    func getQuickSuggestions() -> [QuickSuggestion] {
        return [
            QuickSuggestion(
                title: "Morning Walk",
                category: .fitness,
                icon: "figure.walk",
                description: "Start your day with a 20-minute walk"
            ),
            QuickSuggestion(
                title: "Read 20 Pages",
                category: .learning,
                icon: "book.fill",
                description: "Develop a daily reading habit"
            ),
            QuickSuggestion(
                title: "Meditate",
                category: .mindfulness,
                icon: "leaf.fill",
                description: "Practice mindfulness for 10 minutes"
            ),
            QuickSuggestion(
                title: "Drink Water",
                category: .health,
                icon: "drop.fill",
                description: "Stay hydrated throughout the day"
            ),
            QuickSuggestion(
                title: "Journal",
                category: .creativity,
                icon: "pencil",
                description: "Write your thoughts daily"
            ),
            QuickSuggestion(
                title: "Exercise",
                category: .fitness,
                icon: "figure.run",
                description: "30 minutes of physical activity"
            )
        ]
    }
    
    // MARK: - Apply Suggestion
    func applyQuickSuggestion(_ suggestion: QuickSuggestion) {
        habitName = suggestion.title
        selectedCategory = suggestion.category
        notes = suggestion.description
    }
    
    // MARK: - Reset Form
    func resetForm() {
        habitName = ""
        selectedCategory = .other
        selectedFrequency = .daily
        reminderTime = nil
        notes = ""
        isReminderEnabled = false
        nameError = nil
        aiSuggestion = nil
    }
}

// MARK: - Supporting Models
struct QuickSuggestion {
    let title: String
    let category: HabitCategory
    let icon: String
    let description: String
}

// MARK: - Errors
enum AddHabitError: LocalizedError {
    case invalidForm
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Please fill in all required fields correctly"
        case .saveFailed:
            return "Failed to save habit. Please try again."
        }
    }
}
