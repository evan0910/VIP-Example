//
//  SearchAPIWorkerMock.swift
//  TMDBMovieTests
//
//  Created by Evan Eka Laksana on 08/11/23.
//

@testable import TMDBMovie

class SearchAPIWorkerMock: ISearchAPIWorker, Mockable {
    
    var isSuccess = false
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func searchMovie(request: TMDBMovie.MovieListModel.SearchRequest, _ completion: @escaping (Result<TMDBMovie.MovieListModel.Response, TMDBMovie.RequestError>) -> Void) async {
        isSuccess ? completion(.success(loadJSON(filename: "movie", type: TMDBMovie.MovieListModel.Response.self))) : completion(.failure(.invalidURL))
    }
}
