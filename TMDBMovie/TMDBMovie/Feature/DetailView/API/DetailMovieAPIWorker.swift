//
//  DetailMovieAPIWorker.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation

protocol IDetailMovieAPIWorker: AnyObject {
    func getMovieDetail(request: DetailMovieModel.Request, _ completion: @escaping (Result<DetailMovieModel.Response, RequestError>) -> Void) async
    func getMovieCast(request: MovieCastModel.Request, _ completion: @escaping (Result<MovieCastModel.Response, RequestError>) -> Void) async
}

class DetailMovieAPIWorker: IDetailMovieAPIWorker {

    private let api: IAPIServices
    
    init(api: IAPIServices = APIServices.share) {
        self.api = api
    }

    
    func getMovieDetail(request: DetailMovieModel.Request, _ completion: @escaping (Result<DetailMovieModel.Response, RequestError>) -> Void) async {
        let result = await api.sendRequest(endpoint: DetailMovieEndpoint.movieDetail(id: request.id), responseModel: DetailMovieModel.Response.self)
        completion(result)
    }
    
    func getMovieCast(request: MovieCastModel.Request, _ completion: @escaping (Result<MovieCastModel.Response, RequestError>) -> Void) async {
        let result = await api.sendRequest(endpoint: DetailMovieEndpoint.movieCast(id: request.id), responseModel: MovieCastModel.Response.self)
        completion(result)
    }
}
