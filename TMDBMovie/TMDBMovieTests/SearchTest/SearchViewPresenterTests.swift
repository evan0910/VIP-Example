//
//  SearchViewPresenterTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class SearchViewPresenterTests : XCTestCase, Mockable {
    
    var presenter: SearchViewPresenter?
    var viewControllerMock = SearchViewControllerMock()
    
    override func setUp() {
        presenter = SearchViewPresenter(view: viewControllerMock)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMigrateDataToPopulateInViewController() {
        let data  = loadJSON(filename: "movie", type: TMDBMovie.MovieListModel.Response.self).results
        presenter?.presentSuccessGetMovies(movies: data)
        XCTAssertTrue(viewControllerMock.isSuccess)
        
        let viewModel = viewControllerMock.data.first
        XCTAssertEqual(viewModel?.movieTitle, "Saw X")
        XCTAssertEqual(viewModel?.movieYear, "2023-09-26")
        XCTAssertEqual(viewModel?.movieCover, "https://image.tmdb.org/t/p/w500/aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg")
        XCTAssertEqual(viewModel?.rating, .Neutral)
        XCTAssertEqual(viewModel?.ratingValue, "7.3")
        XCTAssertEqual(viewControllerMock.data.count, 20)
    }
    
    func testFailedGetMovieData() {
        presenter?.presentFailedGetMovies(message: "Wait a few moments and try your request again.")
        XCTAssertEqual(viewControllerMock.errorMessage, "Wait a few moments and try your request again.")
        XCTAssertFalse(viewControllerMock.isSuccess)
    }
    
    func testIsEmptyMovie() {
        presenter?.presentSuccessGetMovies(movies: [])
        XCTAssertTrue(viewControllerMock.isEmptyState)
    }
}
