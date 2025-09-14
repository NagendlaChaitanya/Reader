//
//  CoreDataService.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Article Operations
    
    func saveArticles(_ articles: [Article]) {
        // Clear old cached articles
        clearCachedArticles()
        
        for article in articles {
            if article.toCoreDataArticle(context: context) == nil {
                print("Failed to save article: \(article.title)")
            }
        }
        
        saveContext()
    }
    
    func fetchCachedArticles() -> [Article] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Article")
        request.sortDescriptors = [NSSortDescriptor(key: "cachedAt", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.toArticle() }
        } catch {
            print("Error fetching cached articles: \(error)")
            return []
        }
    }
    
    func clearCachedArticles() {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error clearing cached articles: \(error)")
        }
    }
    
    // MARK: - Bookmark Operations
    
    func addBookmark(_ article: Article) {
        if article.toCoreDataBookmark(context: context) == nil {
            print("Failed to add bookmark: \(article.title)")
        } else {
            saveContext()
        }
    }
    
    func removeBookmark(articleId: String) {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: "articleId == %@", articleId)
        
        do {
            let results = try context.fetch(request)
            for bookmark in results {
                context.delete(bookmark)
            }
            saveContext()
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
    
    func fetchBookmarks() -> [Article] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Bookmark")
        request.sortDescriptors = [NSSortDescriptor(key: "bookmarkedAt", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.toArticle() }
        } catch {
            print("Error fetching bookmarks: \(error)")
            return []
        }
    }
    
    func isBookmarked(articleId: String) -> Bool {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: "articleId == %@", articleId)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking bookmark status: \(error)")
            return false
        }
    }
    
    // MARK: - Search Operations
    
    func searchCachedArticles(query: String) -> [Article] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Article")
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", query, query)
        request.sortDescriptors = [NSSortDescriptor(key: "cachedAt", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.toArticle() }
        } catch {
            print("Error searching cached articles: \(error)")
            return []
        }
    }
    
    func searchBookmarks(query: String) -> [Article] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", query, query)
        request.sortDescriptors = [NSSortDescriptor(key: "bookmarkedAt", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.toArticle() }
        } catch {
            print("Error searching bookmarks: \(error)")
            return []
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
