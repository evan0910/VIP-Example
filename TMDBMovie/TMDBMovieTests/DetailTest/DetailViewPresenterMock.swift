//
//  DetailTestPresenterMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie

class DetailViewPresenterMock: IDetailViewPresenter {
   
    var isSuccess: Bool = false
    var errorMessage: String = ""
    var detail: TMDBMovie.DetailMovieModel.Response?
    var cast: TMDBMovie.MovieCastModel.Response?
    
    func presentSuccessGetDetail(result: TMDBMovie.DetailMovieModel.Response) {
        isSuccess = true
        detail = result
    }
    
    func presentFailedGetDetail(message: String) {
        isSuccess = false
        errorMessage = message
    }
    
    func presentSuccessGetCast(result: TMDBMovie.MovieCastModel.Response) {
        isSuccess = true
        cast = result
    }
    
    func presentFailedGetCast(message: String) {
        isSuccess = false
        errorMessage = message
    }
}
