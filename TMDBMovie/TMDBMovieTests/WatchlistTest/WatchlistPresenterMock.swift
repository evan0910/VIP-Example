//
//  WatchlistPresenterMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie

class WatchlistPresenterMock: IWatchlistPresenter {
    
    var isSuccess: Bool = false
    var errorMessage: String = ""
    var data:[TMDBMovie.MovieDB] = []
    
    func presentSuccessGetWatchlist(movies: [TMDBMovie.MovieDB]) {
        isSuccess = true
        data = movies
    }
    
    func presentFailedOrEmptyWatchlist() {
        isSuccess = false
    }
}

