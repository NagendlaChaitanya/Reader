//
//  NewsAPIService.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import Foundation

class NewsAPIService {
    static let shared = NewsAPIService()
    
    private let baseURL = "https://newsapi.org/v2"
    private let apiKey = "559a18be5646487f8e8d5e8d88edba76" // Replace with your actual API key
    
    private init() {}
    
    func fetchTopHeadlines(country: String = "us", page: Int = 1, pageSize: Int = 20) async throws -> [Article] {
        let urlString = "\(baseURL)/top-headlines?country=\(country)&page=\(page)&pageSize=\(pageSize)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
        return articleResponse.articles
    }
    
    func searchArticles(query: String, page: Int = 1, pageSize: Int = 20) async throws -> [Article] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/everything?q=\(encodedQuery)&page=\(page)&pageSize=\(pageSize)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
        return articleResponse.articles
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}
