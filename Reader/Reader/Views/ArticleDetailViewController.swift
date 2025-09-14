//
//  ArticleDetailViewController.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit
import SafariServices

class ArticleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let article: Article
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sourceDateStackView = UIStackView()
    private let sourceLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let readMoreButton = UIButton(type: .system)
    private let bookmarkButton = UIBarButtonItem()
    
    // MARK: - Initialization
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureContent()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Article"
        
        // Navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        bookmarkButton.target = self
        bookmarkButton.action = #selector(bookmarkButtonTapped)
        updateBookmarkButton()
        navigationItem.rightBarButtonItem = bookmarkButton
        
        // Scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Thumbnail image view
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .systemGray5
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailImageView)
        
        // Title label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Source and date container
        sourceDateStackView.axis = .horizontal
        sourceDateStackView.distribution = .fill
        sourceDateStackView.spacing = 8
        sourceDateStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sourceDateStackView)
        
        // Source label
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        sourceLabel.textColor = .secondaryLabel
        sourceDateStackView.addArrangedSubview(sourceLabel)
        
        // Date label
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
        sourceDateStackView.addArrangedSubview(dateLabel)
        
        // Content label
        contentLabel.font = UIFont.preferredFont(forTextStyle: .body)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .label
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        // Read more button
        readMoreButton.setTitle("Read Full Article", for: .normal)
        readMoreButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        readMoreButton.backgroundColor = .systemBlue
        readMoreButton.setTitleColor(.white, for: .normal)
        readMoreButton.layer.cornerRadius = 8
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(readMoreButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Thumbnail image view
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Source and date stack view
            sourceDateStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            sourceDateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sourceDateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Content label
            contentLabel.topAnchor.constraint(equalTo: sourceDateStackView.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Read more button
            readMoreButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 24),
            readMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            readMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            readMoreButton.heightAnchor.constraint(equalToConstant: 50),
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureContent() {
        titleLabel.text = article.title
        sourceLabel.text = article.source.name
        dateLabel.text = article.formattedDate
        contentLabel.text = article.content ?? article.description
        
        // Load image
        if let imageURL = article.urlToImage {
            ImageService.shared.loadImage(from: imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = image ?? UIImage(systemName: "photo")
                }
            }
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func updateBookmarkButton() {
        let isBookmarked = CoreDataService.shared.isBookmarked(articleId: article.id.uuidString)
        bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func bookmarkButtonTapped() {
        let articleId = article.id.uuidString
        
        if CoreDataService.shared.isBookmarked(articleId: articleId) {
            CoreDataService.shared.removeBookmark(articleId: articleId)
        } else {
            CoreDataService.shared.addBookmark(article)
        }
        
        updateBookmarkButton()
    }
    
    @objc private func readMoreButtonTapped() {
        guard let url = URL(string: article.url) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
