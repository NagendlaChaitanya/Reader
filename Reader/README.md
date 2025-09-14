# Reader - iOS News App

A modern iOS news reader app built with UIKit, featuring offline support, bookmarking, and clean architecture.

## Features

### ✅ Core Features
- **Fetch Articles**: Fetches news articles using NewsAPI.org
- **Offline Caching**: Stores articles locally using Core Data for offline viewing
- **Pull-to-Refresh**: Refresh article list with UIRefreshControl
- **Search Articles**: Search through article titles and descriptions
- **Bookmark Articles**: Save articles for later reading
- **Bookmarks Tab**: Dedicated view for saved articles

### ✅ Architecture & Design
- **MVVM Pattern**: Clean separation of concerns with ViewModels
- **Combine Framework**: Reactive programming for data binding
- **Core Data**: Local data persistence for offline support
- **Auto Layout**: Adaptive UI that works on all device sizes
- **Light/Dark Mode**: Automatic support for system appearance

### ✅ Technical Implementation
- **URLSession**: Native networking for API calls
- **Image Caching**: Custom image loading and caching service
- **Error Handling**: Comprehensive error handling and user feedback
- **Memory Management**: Proper memory management and cell reuse
- **Accessibility**: VoiceOver support and dynamic type

## Project Structure

```
Reader/
├── Models/
│   └── Article.swift                 # Article data model and Core Data extensions
├── Services/
│   ├── NewsAPIService.swift         # API service for fetching news
│   ├── CoreDataService.swift        # Core Data operations
│   └── ImageService.swift           # Image loading and caching
├── ViewModels/
│   ├── ArticleListViewModel.swift   # News list view model
│   └── BookmarkViewModel.swift      # Bookmarks view model
├── Views/
│   ├── ArticleListViewController.swift    # Main news list
│   ├── ArticleDetailViewController.swift  # Article detail view
│   ├── BookmarkViewController.swift       # Bookmarks list
│   ├── MainTabBarController.swift         # Tab bar navigation
│   ├── SettingsViewController.swift       # App settings
│   └── ArticleTableViewCell.swift         # Custom table view cell
└── Reader.xcdatamodeld/             # Core Data model
```

## Setup Instructions

### 1. API Key Configuration
1. Get a free API key from [NewsAPI.org](https://newsapi.org/)
2. Open `Reader/Services/NewsAPIService.swift`
3. Replace `YOUR_API_KEY_HERE` with your actual API key

### 2. Build and Run
1. Open `Reader.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

## Usage

### News Tab
- View latest news articles
- Pull down to refresh
- Search for specific articles
- Tap articles to read full content
- Bookmark articles for later

### Bookmarks Tab
- View all saved articles
- Search through bookmarks
- Swipe to delete bookmarks
- Tap to read full content

### Settings Tab
- Clear image cache
- Clear all app data
- System appearance settings

## Technical Details

### Architecture
- **MVVM**: ViewModels handle business logic and data binding
- **Combine**: Reactive programming for UI updates
- **Core Data**: Local persistence with Article and Bookmark entities
- **URLSession**: Native networking with async/await

### Offline Support
- Articles are automatically cached when fetched
- App works offline using cached data
- Bookmarks persist across app launches
- Image cache for offline image viewing

### Performance
- Lazy loading of images
- Memory-efficient table view cells
- Proper cell reuse and memory management
- Background image loading

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Dependencies

This project uses only native iOS frameworks:
- UIKit
- Foundation
- Core Data
- Combine
- SafariServices

No third-party libraries are required.

## API Usage

The app uses the NewsAPI.org service:
- Free tier: 1000 requests per day
- No authentication required for development
- Supports multiple countries and languages

## Future Enhancements

- [ ] Push notifications for breaking news
- [ ] Article categories and filtering
- [ ] Reading progress tracking
- [ ] Article sharing functionality
- [ ] Custom news sources
- [ ] Widget support
- [ ] Apple Watch companion app

## License

This project is for educational purposes. Please respect the NewsAPI.org terms of service when using their API.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues or questions, please create an issue in the repository.
