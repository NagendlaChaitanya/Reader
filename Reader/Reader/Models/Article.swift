//
//  Article.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import Foundation
import CoreData

struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable, Identifiable, Hashable {
    let id = UUID()
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var publishedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: publishedAt)
    }
    
    var formattedDate: String {
        guard let date = publishedDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

struct ArticleSource: Codable, Hashable {
    let id: String?
    let name: String
}

// MARK: - Core Data Extensions
extension Article {
    func toCoreDataArticle(context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = NSEntityDescription.entity(forEntityName: "Article", in: context)!
        let article = NSManagedObject(entity: entity, insertInto: context)
        article.setValue(source.name, forKey: "sourceName")
        article.setValue(author, forKey: "author")
        article.setValue(title, forKey: "title")
        article.setValue(description, forKey: "descriptionText")
        article.setValue(url, forKey: "url")
        article.setValue(urlToImage, forKey: "urlToImage")
        article.setValue(publishedDate, forKey: "publishedAt")
        article.setValue(content, forKey: "content")
        article.setValue(Date(), forKey: "cachedAt")
        return article
    }
    
    func toCoreDataBookmark(context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context)!
        let bookmark = NSManagedObject(entity: entity, insertInto: context)
        bookmark.setValue(id.uuidString, forKey: "articleId")
        bookmark.setValue(source.name, forKey: "sourceName")
        bookmark.setValue(author, forKey: "author")
        bookmark.setValue(title, forKey: "title")
        bookmark.setValue(description, forKey: "descriptionText")
        bookmark.setValue(url, forKey: "url")
        bookmark.setValue(urlToImage, forKey: "urlToImage")
        bookmark.setValue(publishedDate, forKey: "publishedAt")
        bookmark.setValue(content, forKey: "content")
        bookmark.setValue(Date(), forKey: "bookmarkedAt")
        return bookmark
    }
}

extension NSManagedObject {
    func toArticle() -> Article? {
        guard let sourceName = value(forKey: "sourceName") as? String,
              let title = value(forKey: "title") as? String,
              let url = value(forKey: "url") as? String else {
            return nil
        }
        
        let source = ArticleSource(id: nil, name: sourceName)
        let author = value(forKey: "author") as? String
        let description = value(forKey: "descriptionText") as? String
        let urlToImage = value(forKey: "urlToImage") as? String
        let content = value(forKey: "content") as? String
        
        let publishedAt: String
        if let date = value(forKey: "publishedAt") as? Date {
            let formatter = ISO8601DateFormatter()
            publishedAt = formatter.string(from: date)
        } else {
            publishedAt = ""
        }
        
        return Article(
            source: source,
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            publishedAt: publishedAt,
            content: content
        )
    }
}
