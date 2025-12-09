//
//  String+Helpers.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Validation
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isNotEmpty: Bool {
        return !trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - String Manipulation
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var withoutEmojis: String {
        return self.filter { !$0.isEmoji }
    }
    
    // MARK: - Number Formatting
    var asInt: Int? {
        return Int(self)
    }
    
    var asDouble: Double? {
        return Double(self)
    }
    
    // MARK: - URL Helpers
    var asURL: URL? {
        return URL(string: self)
    }
    
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

// MARK: - Character Extension
extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}
