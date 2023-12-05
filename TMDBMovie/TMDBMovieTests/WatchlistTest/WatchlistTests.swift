//
//  WatchlistTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class WatchlistTests: XCTestCase {
    
    var interactor: WatchlistInteractor?
    let presenter = WatchlistPresenterMock()
    var movieDB: [MovieDB] = []

    override func setUp() {
        interactor = WatchlistInteractor(presenter: presenter)
        setupLocalData()
    }
    
    override func tearDown() {
        super.tearDown()
        removeLocalData()
    }
    
    func setupLocalData() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let movieDB1 = MovieDB(context: context)
        movieDB1.id = Int32(9991)
        movieDB1.releaseDate = Date()
        movieDB1.genre = "Horror"
        movieDB1.popularity = 100
        movieDB1.voteAverage = 8
        movieDB1.overview = "LoremIpsumOdor"
        movieDB1.posterPath = "cover.jpg"
        movieDB1.info = "info"
        movieDB1.title = "DTestAJA"
        
        let movieDB2 = MovieDB(context: context)
        movieDB2.id = Int32(9992)
        movieDB2.releaseDate = Date()
        movieDB2.genre = "Horror"
        movieDB2.popularity = 200
        movieDB2.voteAverage = 7
        movieDB2.overview = "LoremIpsumOdor"
        movieDB2.posterPath = "cover.jpg"
        movieDB2.info = "info"
        movieDB2.title = "ATestAJA"
        
        let movieDB3 = MovieDB(context: context)
        movieDB3.id = Int32(9993)
        movieDB3.releaseDate = Date()
        movieDB3.genre = "Horror"
        movieDB3.popularity = 130
        movieDB3.voteAverage = 5
        movieDB3.overview = "LoremIpsumOdor"
        movieDB3.posterPath = "cover.jpg"
        movieDB3.info = "info"
        movieDB3.title = "BTestAJA"
        
        movieDB.append(movieDB1)
        movieDB.append(movieDB2)
        movieDB.append(movieDB3)

        
        try? context.save()

    }
    
    func removeLocalData() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,movieDB.count > 0 else { return }
        for object in movieDB {
            context.delete(object)
        }
        try? context.save()
    }
    
    func testGetSavedMovie() {
        interactor?.getWatchlist()
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertTrue(presenter.data.count > 0)
    }
    
    func testGetMovieByID() {
        let movie = interactor?.getDataByID(id: 9991)
        XCTAssertEqual(movie?.title, "DTestAJA")
        XCTAssertEqual(movie?.info, "info")
        XCTAssertEqual(movie?.posterPath, "cover.jpg")
        XCTAssertEqual(movie?.overview, "LoremIpsumOdor")
        XCTAssertEqual(movie?.voteAverage, 8)
        XCTAssertEqual(movie?.popularity, 100)
        XCTAssertEqual(movie?.genre,"Horror")
    }
    
    func testRemoveLocalData() {
        interactor?.removeItemInWatchlist(id: 9993)
        let movie = interactor?.getDataByID(id: 9993)
        XCTAssertTrue(movie == nil)
    }
    
    func testSortByName() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return  }
        let localData = (try? context.fetch(MovieDB.fetchRequest())) ?? []
        let sortedData = interactor?.sortDataBy(.titleAsc, data: localData)
        XCTAssertEqual(sortedData?.first?.title, "ATestAJA")
        XCTAssertEqual(sortedData?[safe: 1]?.title, "BTestAJA")
        XCTAssertEqual(sortedData?[safe: 2]?.title, "DTestAJA")

    }
    
    func testSortByPopularity() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return  }
        let localData = (try? context.fetch(MovieDB.fetchRequest())) ?? []
        let sortedData = interactor?.sortDataBy(.popularityAsc, data: localData)
        XCTAssertEqual(sortedData?.first?.title, "DTestAJA")
        XCTAssertEqual(sortedData?[safe: 1]?.title, "BTestAJA")
        XCTAssertEqual(sortedData?[safe: 2]?.title, "ATestAJA")
    }
    
    func testSortByRating() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return  }
        let localData = (try? context.fetch(MovieDB.fetchRequest())) ?? []
        let sortedData = interactor?.sortDataBy(.ratingAsc, data: localData)
        XCTAssertEqual(sortedData?.first?.title, "BTestAJA")
        XCTAssertEqual(sortedData?[safe: 1]?.title, "ATestAJA")
        XCTAssertEqual(sortedData?[safe: 2]?.title, "DTestAJA")
    }
}

