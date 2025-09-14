//
//  ArticleListViewModel.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import Foundation
import Combine

@MainActor
class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var isSearching = false
    
    private let newsAPIService = NewsAPIService.shared
    private let coreDataService = CoreDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchPublisher()
        loadCachedArticles()
    }
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }
    
    func loadArticles() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedArticles = try await newsAPIService.fetchTopHeadlines()
                await MainActor.run {
                    self.articles = fetchedArticles
                    self.isLoading = false
                    // Cache articles for offline use
                    self.coreDataService.saveArticles(fetchedArticles)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    // Load cached articles if available
                    self.loadCachedArticles()
                }
            }
        }
    }
    
    func refreshArticles() {
        loadArticles()
    }
    
    private func loadCachedArticles() {
        articles = coreDataService.fetchCachedArticles()
    }
    
    private func performSearch(_ query: String) {
        if query.isEmpty {
            isSearching = false
            loadCachedArticles()
        } else {
            isSearching = true
            searchArticles(query: query)
        }
    }
    
    func searchArticles(query: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let searchResults = try await newsAPIService.searchArticles(query: query)
                await MainActor.run {
                    self.articles = searchResults
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    // Fallback to cached search
                    self.articles = self.coreDataService.searchCachedArticles(query: query)
                }
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        isSearching = false
        loadCachedArticles()
    }
    
    func toggleBookmark(for article: Article) {
        let articleId = article.id.uuidString
        
        if coreDataService.isBookmarked(articleId: articleId) {
            coreDataService.removeBookmark(articleId: articleId)
        } else {
            coreDataService.addBookmark(article)
        }
    }
    
    func isBookmarked(_ article: Article) -> Bool {
        return coreDataService.isBookmarked(articleId: article.id.uuidString)
    }
}
