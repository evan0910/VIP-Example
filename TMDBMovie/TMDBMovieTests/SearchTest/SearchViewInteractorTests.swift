//
//  SearchViewInteractorTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class SearchViewInteractorTests: XCTestCase {
    
    var interactor: SearchViewInteractor?
    let movieWorker = MovieSharedAPIWorkerMock(isSuccess: true)
    let searchWorker = SearchAPIWorkerMock(isSuccess: true)
    let presenter = SearchViewPresenterMock()
    var movieDB: MovieDB?

    override func setUp() {
        interactor = SearchViewInteractor(presenter: presenter,movieWorker: movieWorker,searchWorker: searchWorker)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetMoviesWithResponseSuccess() {
        let expectation = expectation(description: "success get movie list")
        interactor?.getTopRatedMovies() {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        let data = presenter.data.first
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertTrue(data != nil)
        XCTAssertEqual(data?.title, "Saw X")
        XCTAssertEqual(data?.voteAverage, 7.3)
        XCTAssertEqual(data?.voteCount, 379)
        XCTAssertEqual(data?.adult, false)
        XCTAssertEqual(data?.popularity, 2062.741)
        XCTAssertEqual(data?.posterPath, "/aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg")
        XCTAssertEqual(data?.releaseDate, "2023-09-26")
    }
    
    func testGetMoviesWithResponseFailed() {
        let expectation = expectation(description: "failed get movie list")
        movieWorker.isSuccess = false
        interactor?.getTopRatedMovies() {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.presenter.isSuccess)
        XCTAssertEqual(self.presenter.errorMessage, RequestError.invalidURL.customMessage)
    }
    
    func testSearchMovies() {
        let expectation = self.expectation(description: "failed get movie list")
        interactor?.searchMovies(query: "test") {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        let data = presenter.data.first
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertTrue(data != nil)
        XCTAssertEqual(data?.title, "Saw X")
        XCTAssertEqual(data?.voteAverage, 7.3)
        XCTAssertEqual(data?.voteCount, 379)
        XCTAssertEqual(data?.adult, false)
        XCTAssertEqual(data?.popularity, 2062.741)
        XCTAssertEqual(data?.posterPath, "/aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg")
        XCTAssertEqual(data?.releaseDate, "2023-09-26")
    }
    
    func testFailedSearchMovie() {
        searchWorker.isSuccess = false
        let expectation = expectation(description: "failed get movie list")
        movieWorker.isSuccess = false
        interactor?.searchMovies(query: "test") {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.presenter.isSuccess)
        XCTAssertEqual(self.presenter.errorMessage, RequestError.invalidURL.customMessage)
    }
}

