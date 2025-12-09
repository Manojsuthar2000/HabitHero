//
//  Fonts.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

struct Fonts {
    
    // MARK: - Display Fonts (Large Titles)
    static let displayLarge = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let displayMedium = UIFont.systemFont(ofSize: 28, weight: .bold)
    static let displaySmall = UIFont.systemFont(ofSize: 22, weight: .semibold)
    
    // MARK: - Title Fonts
    static let title1 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let title2 = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let title3 = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    // MARK: - Body Fonts
    static let bodyLarge = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let bodyMedium = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let bodySmall = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    // MARK: - Label Fonts
    static let labelLarge = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let labelMedium = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let labelSmall = UIFont.systemFont(ofSize: 10, weight: .medium)
    
    // MARK: - Caption Fonts
    static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
    
    // MARK: - Button Fonts
    static let buttonLarge = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let buttonMedium = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let buttonSmall = UIFont.systemFont(ofSize: 13, weight: .semibold)
    
    // MARK: - Custom Fonts (if using custom fonts)
    static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // MARK: - Dynamic Type Support
    static func scaledFont(_ font: UIFont, textStyle: UIFont.TextStyle = .body) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        return metrics.scaledFont(for: font)
    }
}

// MARK: - Convenience Extensions
extension UIFont {
    static var habitHeroTitle: UIFont {
        return Fonts.displayMedium
    }
    
    static var habitTitle: UIFont {
        return Fonts.title2
    }
    
    static var habitSubtitle: UIFont {
        return Fonts.bodyMedium
    }
    
    static var habitCaption: UIFont {
        return Fonts.caption1
    }
}
