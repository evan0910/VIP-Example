//
//  MovieSharedAPIWorker.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 08/11/23.
//

import Foundation

protocol IMovieSharedAPIWorker: AnyObject {
    func getMovieList(type: MovieType, request: MovieListModel.Request, _ completion: @escaping (Result<MovieListModel.Response, RequestError>) -> Void) async
}

class MovieSharedAPIWorker: IMovieSharedAPIWorker {
    
    private let api: IAPIServices
    
    init(api: IAPIServices = APIServices.share) {
        self.api = api
    }

    func getMovieList(type: MovieType, request: MovieListModel.Request, _ completion: @escaping (Result<MovieListModel.Response, RequestError>) -> Void) async {
        guard let parameters = request.parameters else {
            completion(.failure(.invalidURL))
            return
        }
        let result = await api.sendRequest(endpoint: type.getEndpoint(parameters: parameters), responseModel: MovieListModel.Response.self)
        completion(result)
    }
}
