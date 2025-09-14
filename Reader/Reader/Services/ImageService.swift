//
//  ImageService.swift
//  Reader
//
//  Created by Venkata.n on 14/09/25.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    
    private let cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Check cache first
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // Load from network
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the image
            self?.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
