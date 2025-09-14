//
//  BookmarkViewModel.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import Foundation
import Combine

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [Article] = []
    @Published var searchText = ""
    @Published var isSearching = false
    
    private let coreDataService = CoreDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchPublisher()
        loadBookmarks()
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
    
    func loadBookmarks() {
        bookmarks = coreDataService.fetchBookmarks()
    }
    
    private func performSearch(_ query: String) {
        if query.isEmpty {
            isSearching = false
            loadBookmarks()
        } else {
            isSearching = true
            bookmarks = coreDataService.searchBookmarks(query: query)
        }
    }
    
    func removeBookmark(_ article: Article) {
        coreDataService.removeBookmark(articleId: article.id.uuidString)
        loadBookmarks()
    }
    
    func clearSearch() {
        searchText = ""
        isSearching = false
        loadBookmarks()
    }
}
