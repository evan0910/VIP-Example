//
//  HomeViewPresenter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 24/10/23.
//

import Foundation
import UIKit

protocol IHomeViewPresenter: AnyObject {
    func presentSuccessGetMovies(movies: [MovieListModel.MoviesViewModel], isLoadMore: Bool)
    func presentFailedGetMovies(message: String)
}

class HomeViewPresenter: IHomeViewPresenter {
    weak var view: IHomeViewController?
    
    init(view: IHomeViewController) {
        self.view = view
    }
    
    func presentSuccessGetMovies(movies: [MovieListModel.MoviesViewModel], isLoadMore: Bool) {
        view?.displaySuccessGetMovies(movies: movies, isLoadMore: isLoadMore)
    }
    
    func presentFailedGetMovies(message: String) {
        view?.displayFailedGetMovies(message: message)
    }
}
