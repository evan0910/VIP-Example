//
//  DetailTestAPIWorkerMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie

class DetailAPIWorkerMock: IDetailMovieAPIWorker, Mockable {
    
    var isSuccess = false
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func getMovieDetail(request: TMDBMovie.DetailMovieModel.Request, _ completion: @escaping (Result<TMDBMovie.DetailMovieModel.Response, TMDBMovie.RequestError>) -> Void) async {
        isSuccess ? completion(.success(loadJSON(filename: "movieDetail", type: TMDBMovie.DetailMovieModel.Response.self))) : completion(.failure(.invalidURL))
    }
    
    func getMovieCast(request: TMDBMovie.MovieCastModel.Request, _ completion: @escaping (Result<TMDBMovie.MovieCastModel.Response, TMDBMovie.RequestError>) -> Void) async {
        isSuccess ? completion(.success(loadJSON(filename: "movieCredit", type: TMDBMovie.MovieCastModel.Response.self))) : completion(.failure(.invalidURL))
    }
}
