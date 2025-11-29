//
//  HabitRepository.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import CoreData

final class HabitRepository {
    
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - CRUD Operations
    func fetchAllHabits() async throws -> [Habit] {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        
        let count = try coreDataStack.context.count(for: request)
        
        // If no habits, return sample data
        if count == 0 {
            return [
                Habit(
                    title: "Morning Walk 🏃‍♂️",
                    category: .fitness,
                    frequency: .daily,
                    streak: 5,
                    isCompleted: false
                ),
                Habit(
                    title: "Read 20 Pages 📚",
                    category: .learning,
                    frequency: .daily,
                    streak: 3,
                    isCompleted: true
                ),
                Habit(
                    title: "Meditate 🧘‍♂️",
                    category: .mindfulness,
                    frequency: .daily,
                    streak: 10,
                    isCompleted: false
                ),
                Habit(
                    title: "Drink Water 💧",
                    category: .health,
                    frequency: .daily,
                    streak: 7,
                    isCompleted: true
                )
            ]
        }
        
        let entities = try coreDataStack.context.fetch(request)
        return entities.compactMap { $0.toModel() }
    }
    
    func fetchTodayHabits() async throws -> [Habit] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "lastCompletedDate >= %@", startOfDay as NSDate)
        
        let entities = try coreDataStack.context.fetch(request)
        return entities.compactMap { $0.toModel() }
    }
    
    func saveHabit(_ habit: Habit) async throws {
        let entity = HabitEntity(context: coreDataStack.context)
        entity.update(from: habit)
        try coreDataStack.save()
        
        NotificationCenter.default.post(name: .habitAdded, object: nil)
    }
    
    func updateHabit(_ habit: Habit) async throws {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)
        
        guard let entity = try coreDataStack.context.fetch(request).first else {
            throw RepositoryError.habitNotFound
        }
        
        entity.update(from: habit)
        try coreDataStack.save()
        
        NotificationCenter.default.post(name: .habitUpdated, object: nil)
    }
    
    func deleteHabit(_ habit: Habit) async throws {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)
        
        guard let entity = try coreDataStack.context.fetch(request).first else {
            throw RepositoryError.habitNotFound
        }
        
        coreDataStack.delete(entity)
        try coreDataStack.save()
        
        NotificationCenter.default.post(name: .habitDeleted, object: nil)
    }
}

// MARK: - Errors
enum RepositoryError: LocalizedError {
    case habitNotFound
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .habitNotFound:
            return "Habit not found"
        case .saveFailed:
            return "Failed to save habit"
        }
    }
}

// MARK: - HabitEntity Extension
extension HabitEntity {
    func toModel() -> Habit? {
        guard let id = self.id,
              let title = self.title,
              let categoryString = self.category,
              let category = HabitCategory(rawValue: categoryString),
              let frequencyString = self.frequency,
              let frequency = HabitFrequency(rawValue: frequencyString),
              let createdDate = self.createdDate else {
            return nil
        }
        
        return Habit(
            id: id,
            title: title,
            category: category,
            frequency: frequency,
            reminderTime: self.reminderTime,
            notes: self.notes,
            streak: Int(self.streak),
            lastCompletedDate: self.lastCompletedDate,
            createdDate: createdDate,
            isCompleted: self.isCompleted
        )
    }
    
    func update(from habit: Habit) {
        self.id = habit.id
        self.title = habit.title
        self.category = habit.category.rawValue
        self.frequency = habit.frequency.rawValue
        self.reminderTime = habit.reminderTime
        self.notes = habit.notes
        self.streak = Int32(habit.streak)
        self.lastCompletedDate = habit.lastCompletedDate
        self.createdDate = habit.createdDate
        self.isCompleted = habit.isCompleted
    }
}
