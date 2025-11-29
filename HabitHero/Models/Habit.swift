//
//  Habit.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation

struct Habit: Codable {
    let id: UUID
    let title: String
    let category: HabitCategory
    let frequency: HabitFrequency
    let reminderTime: Date?
    let notes: String?
    let streak: Int
    let lastCompletedDate: Date?
    let createdDate: Date
    let isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        category: HabitCategory,
        frequency: HabitFrequency = .daily,
        reminderTime: Date? = nil,
        notes: String? = nil,
        streak: Int = 0,
        lastCompletedDate: Date? = nil,
        createdDate: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.frequency = frequency
        self.reminderTime = reminderTime
        self.notes = notes
        self.streak = streak
        self.lastCompletedDate = lastCompletedDate
        self.createdDate = createdDate
        self.isCompleted = isCompleted
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case health = "Health"
    case fitness = "Fitness"
    case productivity = "Productivity"
    case learning = "Learning"
    case mindfulness = "Mindfulness"
    case social = "Social"
    case creativity = "Creativity"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .fitness: return "figure.run"
        case .productivity: return "checkmark.circle.fill"
        case .learning: return "book.fill"
        case .mindfulness: return "leaf.fill"
        case .social: return "person.2.fill"
        case .creativity: return "paintbrush.fill"
        case .other: return "star.fill"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"
}
