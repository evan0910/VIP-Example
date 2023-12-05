//
//  HomeViewPresenterMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation
@testable import TMDBMovie

class HomeViewPresenterMock: IHomeViewPresenter {
    
    var isSuccess: Bool = false
    var errorMessage: String = ""
    var data:[TMDBMovie.MovieListModel.MoviesViewModel] = []
    
    func presentFailedGetMovies(message: String) {
        isSuccess = false
        errorMessage = message
    }
    
    func presentSuccessGetMovies(movies: [TMDBMovie.MovieListModel.MoviesViewModel], isLoadMore: Bool) {
        isSuccess = true
        data = movies
    }
}
