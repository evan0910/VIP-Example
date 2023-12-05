//
//  DetailTestPresenterTests.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie
import XCTest

final class DetailPresenterTests : XCTestCase, Mockable {
    
    var presenter: DetailViewPresenter?
    var viewControllerMock = DetailViewControllerMock()
    
    override func setUp() {
        presenter = DetailViewPresenter(view: viewControllerMock)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresentDetailData() {
        let data  = loadJSON(filename: "movieDetail", type: TMDBMovie.DetailMovieModel.Response.self)
        presenter?.presentSuccessGetDetail(result: data)
        XCTAssertTrue(viewControllerMock.isSuccess)
        
        let viewModel = viewControllerMock.data
        XCTAssertEqual(viewModel?.movieTitle, "Fight Club (1999)")
        XCTAssertEqual(viewModel?.backdropCover, "https://image.tmdb.org/t/p/w500/hZkgoQYus5vegHoetLkCJzb17zJ.jpg")
        XCTAssertEqual(viewModel?.releaseDate, "1999-10-15")
        XCTAssertEqual(viewModel?.movieCover, "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
        XCTAssertEqual(viewModel?.popularity, 61.416)
        XCTAssertEqual(viewModel?.ratingValue, 26280)
        XCTAssertEqual(viewModel?.rating, 8.4)
        XCTAssertEqual(viewModel?.isAdult, false)
        XCTAssertEqual(viewModel?.synopsis, "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
    }
    
    func testFailedGetMovieData() {
        presenter?.presentFailedGetDetail(message: "Wait a few moments and try your request again.")
        XCTAssertEqual(viewControllerMock.errorMessage, "Wait a few moments and try your request again.")
        XCTAssertFalse(viewControllerMock.isSuccess)
    }
}
