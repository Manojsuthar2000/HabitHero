//
//  UIColor+Theme.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit

extension UIColor {
    
    // MARK: - Primary Colors
    static var habitPrimary: UIColor {
        return Colors.primary
    }
    
    static var habitSecondary: UIColor {
        return Colors.secondary
    }
    
    static var habitAccent: UIColor {
        return Colors.accent
    }
    
    // MARK: - Background Colors
    static var habitBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.1, alpha: 1.0)
                : UIColor.systemBackground
        }
    }
    
    static var habitSecondaryBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.15, alpha: 1.0)
                : UIColor.secondarySystemBackground
        }
    }
    
    static var habitCardBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.2, alpha: 1.0)
                : UIColor.white
        }
    }
    
    // MARK: - Text Colors
    static var habitTextPrimary: UIColor {
        return UIColor.label
    }
    
    static var habitTextSecondary: UIColor {
        return UIColor.secondaryLabel
    }
    
    static var habitTextTertiary: UIColor {
        return UIColor.tertiaryLabel
    }
    
    // MARK: - Status Colors
    static var habitSuccess: UIColor {
        return UIColor.systemGreen
    }
    
    static var habitWarning: UIColor {
        return UIColor.systemOrange
    }
    
    static var habitError: UIColor {
        return UIColor.systemRed
    }
    
    static var habitInfo: UIColor {
        return UIColor.systemBlue
    }
    
    // MARK: - Category Colors
    static var categoryHealth: UIColor {
        return UIColor.systemPink
    }
    
    static var categoryFitness: UIColor {
        return UIColor.systemOrange
    }
    
    static var categoryProductivity: UIColor {
        return UIColor.systemBlue
    }
    
    static var categoryLearning: UIColor {
        return UIColor.systemPurple
    }
    
    static var categoryMindfulness: UIColor {
        return UIColor.systemGreen
    }
    
    static var categorySocial: UIColor {
        return UIColor.systemTeal
    }
    
    static var categoryCreativity: UIColor {
        return UIColor.systemIndigo
    }
    
    static var categoryOther: UIColor {
        return UIColor.systemGray
    }
    
    // MARK: - Gradient Colors
    static var habitGradientStart: UIColor {
        return Colors.primary
    }
    
    static var habitGradientEnd: UIColor {
        return Colors.secondary
    }
    
    // MARK: - Helper Methods
    
    /// Creates a color from hex string
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Returns lighter version of the color
    func lighter(by percentage: CGFloat = 0.3) -> UIColor {
        return adjustBrightness(by: abs(percentage))
    }
    
    /// Returns darker version of the color
    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        return adjustBrightness(by: -abs(percentage))
    }
    
    private func adjustBrightness(by percentage: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let newBrightness = max(min(brightness + percentage, 1.0), 0.0)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    
    /// Returns color with adjusted alpha
    func withAlpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
    
    /// Returns hex string representation
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "#%06x", rgb)
    }
}

// MARK: - Gradient Helper
extension UIView {
    
    /// Adds gradient layer to view
    func addGradient(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        
        // Remove existing gradient if any
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - HabitCategory Color Extension
extension HabitCategory {
    var color: UIColor {
        switch self {
        case .health:
            return .categoryHealth
        case .fitness:
            return .categoryFitness
        case .productivity:
            return .categoryProductivity
        case .learning:
            return .categoryLearning
        case .mindfulness:
            return .categoryMindfulness
        case .social:
            return .categorySocial
        case .creativity:
            return .categoryCreativity
        case .other:
            return .categoryOther
        }
    }
}
