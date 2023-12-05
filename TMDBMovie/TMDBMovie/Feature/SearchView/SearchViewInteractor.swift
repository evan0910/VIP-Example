//
//  SearchViewInteractor.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import Foundation

protocol ISearchViewInteractor: AnyObject {
    func getTopRatedMovies(completion: (() -> Void)?)
    func searchMovies(query: String, completion: (() -> Void)?)
}

class SearchViewInteractor: ISearchViewInteractor {
    
    var presenter: ISearchViewPresenter?
    var movieWorker: IMovieSharedAPIWorker?
    var searchWorker: ISearchAPIWorker?
    var movieList: [MovieListModel.Movie] = []
    
    init(presenter: ISearchViewPresenter? = nil, movieWorker: IMovieSharedAPIWorker? = nil, searchWorker: ISearchAPIWorker?) {
        self.presenter = presenter
        self.movieWorker = movieWorker
        self.searchWorker = searchWorker
    }
    
    func getTopRatedMovies(completion: (() -> Void)? = nil) {
        Task(priority: .background) {
            await movieWorker?.getMovieList(type: .topRated, request: .init(page: 1), { [weak self] result in
                guard let self else { return }
                switch result {
                    case.success(let movieResult):
                        self.presenter?.presentSuccessGetMovies(movies: movieResult.results)
                        completion?()
                    case .failure(let error):
                        self.presenter?.presentFailedGetMovies(message: error.customMessage)
                        completion?()
                }
            })
        }
    }
    
    func searchMovies(query: String, completion: (() -> Void)? = nil) {
        Task(priority: .background) {
            await searchWorker?.searchMovie(request: MovieListModel.SearchRequest(query: query), { [weak self] result in
                guard let self else { return }
                switch result {
                    case.success(let movieResult):
                        self.presenter?.presentSuccessGetMovies(movies: movieResult.results)
                        completion?()
                    case .failure(let error):
                        self.presenter?.presentFailedGetMovies(message: error.customMessage)
                        completion?()
                }
            })
        }
    }
}
