//
//  BookmarkViewController.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit
import Combine

class BookmarkViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    private let emptyStateImageView = UIImageView()
    
    // MARK: - Properties
    private let viewModel = BookmarkViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadBookmarks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBookmarks()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Bookmarks"
        
        setupTableView()
        setupSearchController()
        setupEmptyStateView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search bookmarks..."
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        
        // Empty state image
        emptyStateImageView.image = UIImage(systemName: "bookmark")
        emptyStateImageView.tintColor = .systemGray3
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(emptyStateImageView)
        
        // Empty state label
        emptyStateLabel.text = "No bookmarks yet\nTap the bookmark icon on any article to save it here"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Table view
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty state view
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            // Empty state image
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Empty state label
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$bookmarks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                self?.tableView.reloadData()
                self?.updateEmptyState(bookmarks.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    private func updateEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}

// MARK: - UITableViewDataSource
extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.bookmarks[indexPath.row]
        cell.configure(with: article, isBookmarked: true)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = viewModel.bookmarks[indexPath.row]
        let detailVC = ArticleDetailViewController(article: article)
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = viewModel.bookmarks[indexPath.row]
            viewModel.removeBookmark(article)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}

// MARK: - UISearchResultsUpdating
extension BookmarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

// MARK: - UISearchBarDelegate
extension BookmarkViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearSearch()
    }
}

// MARK: - ArticleTableViewCellDelegate
extension BookmarkViewController: ArticleTableViewCellDelegate {
    func didTapBookmarkButton(for article: Article) {
        viewModel.removeBookmark(article)
    }
}
