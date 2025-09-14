//
//  SettingsViewController.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let appearanceModeKey = "AppearanceMode"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubtitleCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Appearance"
        case 1:
            return "Data"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell = UITableViewCell(style: .value1, reuseIdentifier: "SubtitleCell")
                cell.textLabel?.text = "Appearance"
                cell.detailTextLabel?.text = getCurrentAppearanceMode()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.textColor = .label
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Clear Image Cache"
                cell.textLabel?.textColor = .systemRed
                cell.detailTextLabel?.text = nil
                cell.accessoryType = .none
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Clear All Data"
            cell.textLabel?.textColor = .systemRed
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .none
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                showAppearanceOptions()
            case 1:
                clearImageCache()
            default:
                break
            }
        case 1:
            clearAllData()
        default:
            break
        }
    }
    
    // MARK: - Appearance Methods
    
    private func getCurrentAppearanceMode() -> String {
        let savedMode = UserDefaults.standard.string(forKey: appearanceModeKey)
        switch savedMode {
        case "light":
            return "Light"
        case "dark":
            return "Dark"
        default:
            return "System"
        }
    }
    
    private func showAppearanceOptions() {
        let alert = UIAlertController(
            title: "Choose Appearance",
            message: "Select your preferred appearance mode",
            preferredStyle: .actionSheet
        )
        
        // Light mode
        alert.addAction(UIAlertAction(title: "Light", style: .default) { _ in
            self.setAppearanceMode("light")
        })
        
        // Dark mode
        alert.addAction(UIAlertAction(title: "Dark", style: .default) { _ in
            self.setAppearanceMode("dark")
        })
        
        // System mode
        alert.addAction(UIAlertAction(title: "System", style: .default) { _ in
            self.setAppearanceMode("system")
        })
        
        // Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    private func setAppearanceMode(_ mode: String) {
        UserDefaults.standard.set(mode, forKey: appearanceModeKey)
        
        switch mode {
        case "light":
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        case "dark":
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        case "system":
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        default:
            break
        }
        
        // Update the table view to show the new selection
        tableView.reloadData()
    }
    
    private func clearImageCache() {
        ImageService.shared.clearCache()
        
        let alert = UIAlertController(
            title: "Cache Cleared",
            message: "Image cache has been cleared successfully.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func clearAllData() {
        let alert = UIAlertController(
            title: "Clear All Data",
            message: "This will remove all cached articles and bookmarks. This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            CoreDataService.shared.clearCachedArticles()
            ImageService.shared.clearCache()
            
            let successAlert = UIAlertController(
                title: "Data Cleared",
                message: "All data has been cleared successfully.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
}
