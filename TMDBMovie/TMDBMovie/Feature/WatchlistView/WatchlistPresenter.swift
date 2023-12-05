//
//  WatchlistPresenter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 27/10/23.
//

import Foundation

protocol IWatchlistPresenter: AnyObject {
    func presentSuccessGetWatchlist(movies: [MovieDB])
    func presentFailedOrEmptyWatchlist()
}

class WatchlistPresenter: IWatchlistPresenter {
    
    var view: IWatchlistViewController?
    
    func presentSuccessGetWatchlist(movies: [MovieDB]) {
        view?.displaySuccesGetWatchlist(movies: movies)
    }
    
    func presentFailedOrEmptyWatchlist() {
        view?.displayFailedOrEmptyWatchlist()
    }

}
