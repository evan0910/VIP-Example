//
//  DetailViewInteractor.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation
import CoreData
import UIKit

protocol IDetailViewInteractor: AnyObject {
    func getMovieDetailByID(_ id: Int, completion: (() -> Void)?)
    func getMovieCastByID(_ id: Int, completion: (() -> Void)?)
    func addItemToWatchlist(item: DetailMovieModel.DetailMovieViewModel)
    func removeItemInWatchlist(id: Int)
    func getDataByID(id: Int) -> MovieDB?
}

class DetailViewInteractor: IDetailViewInteractor {

    let apiWorker: IDetailMovieAPIWorker
    let presenter: IDetailViewPresenter
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    init(apiWorker: IDetailMovieAPIWorker, presenter: IDetailViewPresenter) {
        self.apiWorker = apiWorker
        self.presenter = presenter
    }
    
    func getMovieDetailByID(_ id: Int, completion: (() -> Void)? = nil) {
        Task.init(priority: .background) {
            await apiWorker.getMovieDetail(request: DetailMovieModel.Request(id: id), { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let result):
                    self.presenter.presentSuccessGetDetail(result: result)
                    completion?()
                case .failure(let error):
                    self.presenter.presentFailedGetDetail(message: error.customMessage)
                    completion?()
                }
            })
        }
    }
    
    func getDataByID(id: Int) -> MovieDB? {
        guard let context  = self.context else { return nil }
        let request: NSFetchRequest<MovieDB> = MovieDB.fetchRequest()
        let predicate =  NSPredicate(format: "id = \(id)")
        request.predicate = predicate
        let movie = try? context.fetch(request)
        return movie?.first
    }
    
    func getMovieCastByID(_ id: Int, completion: (() -> Void)? = nil) {
        Task.init(priority: .background) {
            await apiWorker.getMovieCast(request: MovieCastModel.Request(id: id), { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let result):
                    self.presenter.presentSuccessGetCast(result: result)
                    completion?()
                case .failure(let error):
                    self.presenter.presentFailedGetCast(message: error.customMessage)
                    completion?()
                }
            })
        }
    }
    
    func addItemToWatchlist(item: DetailMovieModel.DetailMovieViewModel) {
        guard let context else { return }
        let movie = MovieDB(context: context)
        movie.id = Int32(item.id)
        movie.title = item.movieTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: item.releaseDate)
        movie.releaseDate = date
        movie.genre = item.genres
        movie.popularity = item.popularity
        movie.voteAverage = item.rating
        movie.overview = item.synopsis
        movie.posterPath = item.movieCover
        movie.info = "\(item.genres) - \(item.runtime)"
        try? context.save()
    }
    
    func removeItemInWatchlist(id: Int) {
        guard let obj = getDataByID(id: id), let context else { return }
        context.delete(obj)
        try? context.save()
    }
}
