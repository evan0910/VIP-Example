//
//  SearchViewControllerMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation

@testable import TMDBMovie

class SearchViewControllerMock: ISearchViewController {
    
    var isSuccess: Bool = false
    var isEmptyState: Bool = false
    var data: [TMDBMovie.MovieListModel.MoviesViewModel] = []
    var errorMessage = ""
    
    func displaySuccessGetMovies(movies: [TMDBMovie.MovieListModel.MoviesViewModel]) {
        data = movies
        isSuccess = true
    }
    
    func displayFailedGetMovies(message: String) {
        isSuccess = false
        errorMessage = message
    }
    
    func displayEmptyState() {
        isEmptyState = true 
    }
    
}
