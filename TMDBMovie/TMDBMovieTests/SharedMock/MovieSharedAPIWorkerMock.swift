//
//  MovieSharedAPIWorkerMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation
@testable import TMDBMovie

class MovieSharedAPIWorkerMock: IMovieSharedAPIWorker, Mockable {
    
    var isSuccess = false
    var isAPICalled = false
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func getMovieList(type: TMDBMovie.MovieType, request: TMDBMovie.MovieListModel.Request, _ completion: @escaping (Result<TMDBMovie.MovieListModel.Response, TMDBMovie.RequestError>) -> Void) async {
        isAPICalled = true 
        isSuccess ? completion(.success(loadJSON(filename: "movie", type: TMDBMovie.MovieListModel.Response.self))) : completion(.failure(.invalidURL))
    }
}
