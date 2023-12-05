//
//  DetailTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class DetailMovieTests: XCTestCase {
    
    var interactor: DetailViewInteractor?
    let worker = DetailAPIWorkerMock(isSuccess: true)
    let presenter = DetailViewPresenterMock()
    var movieDB: MovieDB?

    override func setUp() {
        interactor = DetailViewInteractor(apiWorker: worker, presenter: presenter)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSucceedGetMovieDetails() {
        let expectation = expectation(description: "success get movie detail")
        interactor?.getMovieDetailByID(9) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertNotNil(presenter.detail)
        XCTAssertEqual(presenter.detail?.title, "Fight Club")
        XCTAssertEqual(presenter.detail?.backdropPath, "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg")
        XCTAssertEqual(presenter.detail?.releaseDate, "1999-10-15")
        XCTAssertEqual(presenter.detail?.posterPath, "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
        XCTAssertEqual(presenter.detail?.popularity, 61.416)
        XCTAssertEqual(presenter.detail?.voteCount, 26280)
        XCTAssertEqual(presenter.detail?.voteAverage, 8.433)
        XCTAssertEqual(presenter.detail?.adult, false)
        XCTAssertEqual(presenter.detail?.overview, "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
    }
    
    func testFailedGetDetailMovie() {
        let expectation = expectation(description: "failed get movie detail")
        worker.isSuccess = false
        interactor?.getMovieDetailByID(9) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.presenter.isSuccess)
        XCTAssertEqual(self.presenter.errorMessage, RequestError.invalidURL.customMessage)
    }
    
    func testGetCastList() {
        let expectation = expectation(description: "success get movie cast")
        interactor?.getMovieCastByID(9) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertTrue(presenter.isSuccess)
        XCTAssertNotNil(presenter.cast)
        
        let cast = presenter.cast?.cast?.first
        XCTAssertEqual(cast?.character, "The Narrator")
        XCTAssertEqual(cast?.name, "Edward Norton")
        XCTAssertEqual(cast?.id, 819)
        XCTAssertEqual(cast?.profilePath, "/8nytsqL59SFJTVYVrN72k6qkGgJ.jpg")

    }
    
    func testFailedGetCast() {
        let expectation = expectation(description: "failed get movie cast")
        worker.isSuccess = false
        interactor?.getMovieCastByID(9) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertFalse(self.presenter.isSuccess)
        XCTAssertEqual(self.presenter.errorMessage, RequestError.invalidURL.customMessage)
    }
    
    func testCreateReadAndDeleteMovieFromLocalStorage() {
        let movie = DetailMovieModel.DetailMovieViewModel(id: 090909, movieTitle: "TestMovie", rating: 6.7, ratingValue: 8888, movieYear: "1994", movieCover: "/cover.jpg", backdropCover: "/backdrop.jpg", isWatched: true, synopsis: "LoremIpsumOdor", genres: "Horror,Comedy", tagline: "LoremIpsum", runtime: "2h 3m", releaseDate: "1994", isAdult: false, popularity: 2322)
        interactor?.addItemToWatchlist(item: movie)
        
        let movieData = interactor?.getDataByID(id: 090909)
        XCTAssertNotNil(movieData)
        XCTAssertEqual(movieData?.id, 090909)
        XCTAssertEqual(movieData?.title, "TestMovie")
        XCTAssertEqual(movieData?.voteAverage, 6.7)
        XCTAssertEqual(movieData?.posterPath, "/cover.jpg")
        XCTAssertEqual(movieData?.overview, "LoremIpsumOdor")
        XCTAssertEqual(movieData?.popularity, 2322)
        XCTAssertEqual(movieData?.genre, "Horror,Comedy")
        
        interactor?.removeItemInWatchlist(id: 090909)
        XCTAssertNil(self.interactor?.getDataByID(id: 090909))

    }
    
    
}
