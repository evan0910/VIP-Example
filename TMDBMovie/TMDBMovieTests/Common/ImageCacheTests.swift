//
//  ImageCacheTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 19/11/23.
//

import XCTest
import UIKit
@testable import TMDBMovie

final class ImageCacheTests: XCTestCase {
    
    let imageCache = ImageDownloader()

    func testImageCache()  {
        imageCache.cache(image: UIImage(named: "noImage")!, forKey: "noImageCache")
        let image = imageCache.image(forKey: "noImageCache")
        XCTAssertNotNil(image)
        XCTAssertEqual(image, UIImage(named: "noImage"))
    }

}
