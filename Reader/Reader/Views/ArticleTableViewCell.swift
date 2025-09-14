//
//  ArticleTableViewCell.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit

protocol ArticleTableViewCellDelegate: AnyObject {
    func didTapBookmarkButton(for article: Article)
}

class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"
    
    weak var delegate: ArticleTableViewCellDelegate?
    private var article: Article?
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sourceLabel = UILabel()
    private let dateLabel = UILabel()
    private let bookmarkButton = UIButton(type: .system)
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Thumbnail image view
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.backgroundColor = .systemGray5
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(thumbnailImageView)
        
        // Title label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Description label
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        // Source label
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        sourceLabel.textColor = .tertiaryLabel
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sourceLabel)
        
        // Date label
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        // Bookmark button
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        bookmarkButton.tintColor = .systemBlue
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bookmarkButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Thumbnail image view
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Bookmark button
            bookmarkButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            bookmarkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -8),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Source label
            sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            sourceLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            sourceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // Date label
            dateLabel.centerYAnchor.constraint(equalTo: sourceLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: sourceLabel.trailingAnchor, constant: 8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with article: Article, isBookmarked: Bool) {
        self.article = article
        
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source.name
        dateLabel.text = article.formattedDate
        bookmarkButton.isSelected = isBookmarked
        
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
    
    // MARK: - Actions
    @objc private func bookmarkButtonTapped() {
        guard let article = article else { return }
        delegate?.didTapBookmarkButton(for: article)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        sourceLabel.text = nil
        dateLabel.text = nil
        bookmarkButton.isSelected = false
        article = nil
    }
}
