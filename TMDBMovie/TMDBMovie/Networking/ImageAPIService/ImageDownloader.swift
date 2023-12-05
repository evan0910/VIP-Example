//
//  ImageDownloader.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 25/10/23.
//

import Foundation
import UIKit

final  class ImageDownloader {
    
    private let cache = NSCache<NSString, ImageCache>()
    static var share = ImageDownloader()

    func cache(image: UIImage, forKey key: String) {
      let cacheImage = ImageCache()
      cacheImage.image = image
      cache.setObject(cacheImage, forKey: key as NSString)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)?.image
    }

    func clearCache() {
      cache.removeAllObjects()
    }

    func downloadImage(fromURL url: URL,completion: @escaping (Result<UIImage,Error>) -> Void) {
        if let image = image(forKey: url.absoluteString) {
            completion(.success(image))
            return
        }

      URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
          guard let self , let data = data, let image = UIImage(data: data), error == nil else {
              completion(.failure(RequestError.unknown))
              return
          }
          self.cache(image: image, forKey: url.absoluteString)
          completion(.success(image))
      }.resume()
    }
}

class ImageCache: NSObject , NSDiscardableContent {
    public var image: UIImage!
    func endContentAccess() {}
    func discardContentIfPossible() {}
    func beginContentAccess() -> Bool { return true }
    func isContentDiscarded() -> Bool { return false }
}

