//
//  SearchHomePresenter.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation
@testable import TMDBMovie

class SearchViewPresenterMock: ISearchViewPresenter {

    var isSuccess: Bool = false
    var errorMessage: String = ""
    var data:[TMDBMovie.MovieListModel.Movie] = []
    
    func presentSuccessGetMovies(movies: [TMDBMovie.MovieListModel.Movie]) {
        isSuccess = true
        data = movies
    }
    
    func presentFailedGetMovies(message: String) {
        isSuccess = false
        errorMessage = message
    }
}
