//
//  HomeViewInteractorTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class HomeViewInteractorTests : XCTestCase {
    
    var interactor: HomeViewInteractor?
    let worker = MovieSharedAPIWorkerMock(isSuccess: true)
    let presenter = HomeViewPresenterMock()
    var movieDB: MovieDB?

    override func setUp() {
        interactor = HomeViewInteractor(presenter: presenter,worker: worker)
        setupLocalData()
    }
    
    override func tearDown() {
        super.tearDown()
        removeLocalData()
    }
    
    func setupLocalData() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        movieDB = MovieDB(context: context)
        movieDB?.id = Int32(99999)
        movieDB?.releaseDate = Date()
        movieDB?.genre = "Horror"
        movieDB?.popularity = 200
        movieDB?.voteAverage = 200
        movieDB?.overview = "LoremIpsumOdor"
        movieDB?.posterPath = "cover.jpg"
        movieDB?.info = "info"
        try? context.save()
    }
    
    func removeLocalData() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,let movieDB else { return }
        context.delete(movieDB)
        try? context.save()
    }
    
    func testGetMoviesWithResponseSuccess() {
        let expectation = self.expectation(description: "success get movie list")
        interactor?.getMovieWithType(.topRated, isLoadMore: false) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        let data = presenter.data.first
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertTrue(data != nil)
        XCTAssertEqual(interactor?.totalPages, 110)
        XCTAssertEqual(interactor?.page, 2)
        XCTAssertEqual(data?.movieTitle, "Saw X")
        XCTAssertEqual(data?.rating, .Neutral)
        XCTAssertEqual(data?.movieCover, "https://image.tmdb.org/t/p/w500/aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg")
        XCTAssertEqual(data?.movieYear, "2023-09-26")
        XCTAssertEqual(data?.isWatched, false)
    }
    
    func testGetMoviesWithResponseFailed() {
        let expectation = self.expectation(description: "failed get movie list")
        worker.isSuccess = false
        interactor?.getMovieWithType(.topRated, isLoadMore: false) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.presenter.isSuccess)
        XCTAssertEqual(self.presenter.errorMessage, RequestError.invalidURL.customMessage)
    }
    
    func testGetMovieLocalData() {
        let localData = interactor?.getLocalData() ?? []
        XCTAssertFalse(localData.isEmpty)
    }
    
    func testFailedToLoadMoreIsLastPage() {
        interactor?.page = 110
        interactor?.totalPages = 110
        worker.isSuccess = true
        interactor?.getMovieWithType(.topRated, isLoadMore: true)
        XCTAssertFalse(worker.isAPICalled)
        XCTAssertFalse(presenter.isSuccess)
        XCTAssertEqual(presenter.errorMessage, "")
    }
    
    func testIsDataExist() {
        XCTAssertTrue(interactor?.isDataExistByID(99999) ?? false)
        XCTAssertFalse(interactor?.isDataExistByID(2222) ?? false)
    }
}
