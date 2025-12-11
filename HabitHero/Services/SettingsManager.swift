//
//  SettingsManager.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit

// MARK: - Appearance Mode
enum AppearanceMode: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
    
    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

// MARK: - Settings Manager
final class SettingsManager {
    
    // MARK: - Singleton
    static let shared = SettingsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let appearanceMode = "appearanceMode"
        static let notificationsEnabled = "notificationsEnabled"
        static let hapticFeedbackEnabled = "hapticFeedbackEnabled"
    }
    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    
    // MARK: - Appearance
    var appearanceMode: AppearanceMode {
        get {
            let rawValue = defaults.integer(forKey: Keys.appearanceMode)
            return AppearanceMode(rawValue: rawValue) ?? .system
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.appearanceMode)
            applyAppearance(newValue)
            NotificationCenter.default.post(name: .appearanceDidChange, object: newValue)
        }
    }
    
    // MARK: - Notifications
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }
    
    // MARK: - Haptic Feedback
    var hapticFeedbackEnabled: Bool {
        get {
            // Default to true if not set
            if defaults.object(forKey: Keys.hapticFeedbackEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.hapticFeedbackEnabled)
        }
        set { defaults.set(newValue, forKey: Keys.hapticFeedbackEnabled) }
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Apply Appearance
    func applyAppearance(_ mode: AppearanceMode? = nil) {
        let modeToApply = mode ?? appearanceMode
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            for window in windowScene.windows {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.overrideUserInterfaceStyle = modeToApply.userInterfaceStyle
                }
            }
        }
    }
    
    // MARK: - Setup on Launch
    func setupOnLaunch() {
        applyAppearance()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let appearanceDidChange = Notification.Name("appearanceDidChange")
}
