//
//  AppDelegate.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize CoreData
        CoreDataStack.shared.setupCoreData()
        
        // Setup Notifications
        NotificationManager.shared.requestAuthorization()
        
        // Setup appearance
        setupAppearance()
        
        // Register for background tasks
        registerBackgroundTasks()
        
        return true
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = Colors.primary
        UITabBar.appearance().tintColor = Colors.primary
    }
    
    private func registerBackgroundTasks() {
        // Register background tasks for midnight habit reset
        // BGTaskScheduler implementation
    }
}
