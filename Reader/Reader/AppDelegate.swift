//
//  AppDelegate.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Core Data
        _ = persistentContainer
        
        // Apply saved appearance mode
        applySavedAppearanceMode()
        
        return true
    }
    
    private func applySavedAppearanceMode() {
        let appearanceModeKey = "AppearanceMode"
        let savedMode = UserDefaults.standard.string(forKey: appearanceModeKey)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                switch savedMode {
                case "light":
                    window.overrideUserInterfaceStyle = .light
                case "dark":
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        print("Creating NSPersistentContainer with programmatic model")
        
        // Create the managed object model programmatically
        let model = NSManagedObjectModel()
        
        // Create Article entity
        let articleEntity = NSEntityDescription()
        articleEntity.name = "Article"
        articleEntity.managedObjectClassName = "Article"
        
        // Add attributes to Article entity
        let articleAttributes: [String: NSAttributeDescription] = [
            "author": {
                let attr = NSAttributeDescription()
                attr.name = "author"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "content": {
                let attr = NSAttributeDescription()
                attr.name = "content"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "descriptionText": {
                let attr = NSAttributeDescription()
                attr.name = "descriptionText"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "publishedAt": {
                let attr = NSAttributeDescription()
                attr.name = "publishedAt"
                attr.attributeType = .dateAttributeType
                attr.isOptional = true
                return attr
            }(),
            "sourceName": {
                let attr = NSAttributeDescription()
                attr.name = "sourceName"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "title": {
                let attr = NSAttributeDescription()
                attr.name = "title"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "url": {
                let attr = NSAttributeDescription()
                attr.name = "url"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "urlToImage": {
                let attr = NSAttributeDescription()
                attr.name = "urlToImage"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "cachedAt": {
                let attr = NSAttributeDescription()
                attr.name = "cachedAt"
                attr.attributeType = .dateAttributeType
                attr.isOptional = true
                return attr
            }()
        ]
        
        articleEntity.properties = Array(articleAttributes.values)
        
        // Create Bookmark entity
        let bookmarkEntity = NSEntityDescription()
        bookmarkEntity.name = "Bookmark"
        bookmarkEntity.managedObjectClassName = "Bookmark"
        
        // Add attributes to Bookmark entity
        let bookmarkAttributes: [String: NSAttributeDescription] = [
            "articleId": {
                let attr = NSAttributeDescription()
                attr.name = "articleId"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "author": {
                let attr = NSAttributeDescription()
                attr.name = "author"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "content": {
                let attr = NSAttributeDescription()
                attr.name = "content"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "descriptionText": {
                let attr = NSAttributeDescription()
                attr.name = "descriptionText"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "publishedAt": {
                let attr = NSAttributeDescription()
                attr.name = "publishedAt"
                attr.attributeType = .dateAttributeType
                attr.isOptional = true
                return attr
            }(),
            "sourceName": {
                let attr = NSAttributeDescription()
                attr.name = "sourceName"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "title": {
                let attr = NSAttributeDescription()
                attr.name = "title"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "url": {
                let attr = NSAttributeDescription()
                attr.name = "url"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "urlToImage": {
                let attr = NSAttributeDescription()
                attr.name = "urlToImage"
                attr.attributeType = .stringAttributeType
                attr.isOptional = true
                return attr
            }(),
            "bookmarkedAt": {
                let attr = NSAttributeDescription()
                attr.name = "bookmarkedAt"
                attr.attributeType = .dateAttributeType
                attr.isOptional = true
                return attr
            }()
        ]
        
        bookmarkEntity.properties = Array(bookmarkAttributes.values)
        
        // Set the entities in the model
        model.entities = [articleEntity, bookmarkEntity]
        
        // Create the persistent container with the programmatic model
        let container = NSPersistentContainer(name: "Reader", managedObjectModel: model)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("Core Data loaded successfully")
                print("Available entities: \(container.managedObjectModel.entities.map { $0.name ?? "Unknown" })")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

