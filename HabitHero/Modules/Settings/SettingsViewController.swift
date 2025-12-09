//
//  SettingsViewController.swift
//  HabitHero
//
//  Created by Manoj Suthar on 09/12/25.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: SettingsCoordinator?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        return table
    }()
    
    // MARK: - Data
    private let sections: [(title: String, items: [(icon: String, title: String, color: UIColor)])] = [
        (
            title: "General",
            items: [
                ("bell.fill", "Notifications", .systemBlue),
                ("moon.fill", "Appearance", .systemPurple),
                ("globe", "Language", .systemGreen)
            ]
        ),
        (
            title: "Data",
            items: [
                ("icloud.fill", "Backup & Sync", .systemCyan),
                ("square.and.arrow.up.fill", "Export Data", .systemOrange),
                ("trash.fill", "Clear All Data", .systemRed)
            ]
        ),
        (
            title: "About",
            items: [
                ("info.circle.fill", "About HabitHero", .systemGray),
                ("star.fill", "Rate App", .systemYellow),
                ("envelope.fill", "Send Feedback", .systemBlue)
            ]
        )
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .habitBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    private func handleSettingsTap(section: Int, row: Int) {
        let item = sections[section].items[row]
        
        switch (section, row) {
        case (0, 0): // Notifications
            openAppSettings()
        case (1, 2): // Clear All Data
            showClearDataAlert()
        case (2, 0): // About
            showAboutAlert()
        case (2, 1): // Rate App
            rateApp()
        default:
            showComingSoonAlert(for: item.title)
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showClearDataAlert() {
        let alert = UIAlertController(
            title: "Clear All Data",
            message: "Are you sure you want to delete all habits? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            // TODO: Implement clear all data
            self.showSuccessMessage("All data cleared")
        })
        
        present(alert, animated: true)
    }
    
    private func showAboutAlert() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        
        let alert = UIAlertController(
            title: "HabitHero",
            message: "Version \(version) (\(build))\n\nAn AI-powered habit tracking app to help you build lasting positive routines.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func rateApp() {
        // TODO: Add App Store URL
        showComingSoonAlert(for: "Rate App")
    }
    
    private func showComingSoonAlert(for feature: String) {
        let alert = UIAlertController(
            title: feature,
            message: "This feature is coming soon!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessMessage(_ message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.image = UIImage(systemName: item.icon)
        config.imageProperties.tintColor = item.color
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSettingsTap(section: indexPath.section, row: indexPath.row)
    }
}
