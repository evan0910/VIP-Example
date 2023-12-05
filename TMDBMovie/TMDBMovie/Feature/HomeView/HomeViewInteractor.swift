//
//  HomeViewInteractor.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 24/10/23.
//

import Foundation
import UIKit
import CoreData

protocol IHomeViewInteractor: AnyObject {
    func getMovieWithType(_ type: MovieType, isLoadMore: Bool, completion: (() -> Void)?)
    func isDataExistByID(_ id: Int) -> Bool
}

class HomeViewInteractor: IHomeViewInteractor {
    
    var presenter: IHomeViewPresenter?
    var worker: IMovieSharedAPIWorker?
    var page = 1
    var totalPages = 1
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    init(presenter: IHomeViewPresenter? = nil, worker: IMovieSharedAPIWorker? = nil) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func getMovieWithType(_ type: MovieType, isLoadMore: Bool, completion: (() -> Void)? = nil) {
        if page > totalPages { return }
        if !isLoadMore {
            page = 1
        }
        let localData = getLocalData()
        Task(priority: .background) {
            await worker?.getMovieList(type: type, request: .init(page: page), { [weak self] result in
                guard let self else { return }
                switch result {
                    case.success(let movieResult):
                        self.page+=1
                        self.totalPages = movieResult.totalPages
                        self.presenter?.presentSuccessGetMovies(
                            movies: self.setMovieData(movies: movieResult.results,localData: localData),
                            isLoadMore: isLoadMore
                        )
                        completion?()
                    case .failure(let error):
                        self.presenter?.presentFailedGetMovies(message: error.customMessage)
                        completion?()
                }
            })
        }
    }
    
    func setMovieData(movies: [MovieListModel.Movie], localData: [MovieDB]) ->  [MovieListModel.MoviesViewModel] {
        var moviesList: [MovieListModel.MoviesViewModel] = []
        for movie in movies {
            let isWatched = localData.contains(where: { $0.id == movie.id ?? 0})
            let film = MovieListModel.MoviesViewModel(
                id: movie.id ?? 0,
                movieTitle: movie.title ?? "",
                rating: Rating(rating: (movie.voteAverage ?? 0.0)) ?? .Neutral,
                ratingValue: String(movie.voteAverage?.rounded(toPlaces: 1) ?? 0.0),
                movieYear: movie.releaseDate ?? "",
                movieCover: ("\(BaseURL.avatar.rawValue)\(movie.posterPath ?? "")"),
                isWatched: isWatched )
            moviesList.append(film)
        }
        return moviesList
    }
    
    func getLocalData() -> [MovieDB] {
        guard let context  = self.context else { return [] }
        return (try? context.fetch(MovieDB.fetchRequest())) ?? []
    }
    
    func isDataExistByID(_ id: Int) -> Bool {
        guard let context  = self.context else { return false }
        let request: NSFetchRequest<MovieDB> = MovieDB.fetchRequest()
        let predicate =  NSPredicate(format: "id = \(id)")
        request.predicate = predicate
        let movie = try? context.fetch(request)
        return !(movie?.isEmpty ?? true)
    }
}
