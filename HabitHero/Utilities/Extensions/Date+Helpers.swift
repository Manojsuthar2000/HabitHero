//
//  Date+Helpers.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation

extension Date {
    
    // MARK: - Date Components
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var endOfWeek: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfWeek) ?? self
    }
    
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    // MARK: - Date Comparison
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isSameWeek(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    
    func isSameMonth(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    func isToday() -> Bool {
        return isSameDay(as: Date())
    }
    
    func isYesterday() -> Bool {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return isSameDay(as: yesterday)
    }
    
    func isTomorrow() -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return isSameDay(as: tomorrow)
    }
    
    var isInPast: Bool {
        return self < Date()
    }
    
    var isInFuture: Bool {
        return self > Date()
    }
    
    // MARK: - Date Arithmetic
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func adding(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self) ?? self
    }
    
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
        return abs(components.day ?? 0)
    }
    
    // MARK: - Formatting
    func formatted(as format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    var relativeDateString: String {
        if isToday() {
            return "Today"
        } else if isYesterday() {
            return "Yesterday"
        } else if isTomorrow() {
            return "Tomorrow"
        } else {
            return dateString
        }
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    // MARK: - Week Days
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    var shortWeekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    // MARK: - Habit Specific
    func isWithinStreak(lastCompletedDate: Date?) -> Bool {
        guard let lastDate = lastCompletedDate else { return false }
        let daysBetween = self.daysBetween(lastDate)
        return daysBetween <= 1
    }
    
    static func datesInRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = currentDate.adding(days: 1)
        }
        
        return dates
    }
}

// MARK: - Date Format Enum
enum DateFormat: String {
    case full = "EEEE, MMMM d, yyyy"
    case long = "MMMM d, yyyy"
    case medium = "MMM d, yyyy"
    case short = "MM/dd/yy"
    case time = "h:mm a"
    case time24 = "HH:mm"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case yearMonthDay = "yyyy-MM-dd"
    case monthDay = "MMM d"
    case dayMonth = "d MMM"
    case monthYear = "MMMM yyyy"
}
