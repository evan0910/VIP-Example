//
//  SearchAPIWorker.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import Foundation

protocol ISearchAPIWorker: AnyObject {
    func searchMovie(request: MovieListModel.SearchRequest, _ completion: @escaping (Result<MovieListModel.Response, RequestError>) -> Void) async
}

class SearchAPIWorker: ISearchAPIWorker {
    
    private let api: IAPIServices
    
    init(api: IAPIServices = APIServices.share) {
        self.api = api
    }
    
    func searchMovie(request: MovieListModel.SearchRequest, _ completion: @escaping (Result<MovieListModel.Response, RequestError>) -> Void) async {
        guard let parameters = request.parameters else {
            completion(.failure(.invalidURL))
            return
        }
        let result = await api.sendRequest(endpoint: SearchEndpoint.searchMovie(parameters: parameters), responseModel: MovieListModel.Response.self)
        completion(result)
    }
}

