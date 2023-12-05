//
//  SearchViewPresenter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import Foundation
import UIKit

protocol ISearchViewPresenter: AnyObject {
    func presentSuccessGetMovies(movies: [MovieListModel.Movie])
    func presentFailedGetMovies(message: String)
}

class SearchViewPresenter: ISearchViewPresenter {
    weak var view: ISearchViewController?
    
    init(view: ISearchViewController) {
        self.view = view
    }
    
    func presentSuccessGetMovies(movies: [MovieListModel.Movie]) {
        if movies.isEmpty { view?.displayEmptyState() }
        var moviesList: [MovieListModel.MoviesViewModel] = []
        for movie in movies {
            let film = MovieListModel.MoviesViewModel(id: movie.id ?? 0, movieTitle: movie.title ?? "", rating: Rating(rating: (movie.voteAverage ?? 0.0)) ?? .Neutral, ratingValue: String(movie.voteAverage?.rounded(toPlaces: 1) ?? 0.0), movieYear: movie.releaseDate ?? "", movieCover: "\(BaseURL.avatar.rawValue)\(movie.posterPath ?? "")", isWatched: false)
            moviesList.append(film)
        }
        view?.displaySuccessGetMovies(movies: moviesList)
    }
    
    func presentFailedGetMovies(message: String) {
        view?.displayFailedGetMovies(message: message)
    }
    
}
