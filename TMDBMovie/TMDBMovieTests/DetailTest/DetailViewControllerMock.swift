//
//  DetailViewControllerMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie

class DetailViewControllerMock: IDetailViewController {
    
    var isSuccess: Bool = false
    var data: TMDBMovie.DetailMovieModel.DetailMovieViewModel?
    var castData: [TMDBMovie.MovieCastModel.MovieCastViewModel] = []
    var errorMessage = ""
    
    func displaySuccessGetDetailMovie(viewModel: TMDBMovie.DetailMovieModel.DetailMovieViewModel) {
        isSuccess = true
        data = viewModel
    }
    
    func displaySuccessGetCast(viewModel: [TMDBMovie.MovieCastModel.MovieCastViewModel]) {
        isSuccess = true
        castData = viewModel
    }
    
    func displayFailedToGetData(message: String) {
        isSuccess = false
        errorMessage = message
    }
    
    
}
