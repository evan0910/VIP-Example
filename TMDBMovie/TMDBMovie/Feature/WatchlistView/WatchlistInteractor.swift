//
//  WatchlistInteractor.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 27/10/23.
//

import Foundation
import CoreData
import UIKit

protocol IWatchlistInteractor: AnyObject {
    func getWatchlist()
    func removeItemInWatchlist(id: Int)
    func sortDataBy(_ type: SortBy,data: [MovieDB]) -> [MovieDB]
}

class WatchlistInteractor: IWatchlistInteractor {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var presenter: IWatchlistPresenter
    
    init(presenter: IWatchlistPresenter) {
        self.presenter = presenter
    }
    
    func getWatchlist() {
        guard let context else { return }
        do {
            let items = try context.fetch(MovieDB.fetchRequest())
            items.count > 0 ? presenter.presentSuccessGetWatchlist(movies: items) : presenter.presentFailedOrEmptyWatchlist()
        } catch {
            presenter.presentFailedOrEmptyWatchlist()
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
    
    func removeItemInWatchlist(id: Int) {
        guard let obj = getDataByID(id: id), let context else { return }
        context.delete(obj)
        try? context.save()
    }
    
    func sortDataBy(_ type: SortBy,data: [MovieDB]) -> [MovieDB] {
                guard data.count > 1 else {
            return data
        }
        
        let leftArray  = Array(data[0..<data.count/2])
        let rightArray = Array(data[data.count/2..<data.count])
        
        return sort(type: type, left: sortDataBy(type, data: leftArray), right: sortDataBy(type, data: rightArray))
    }

    func sort(type: SortBy, left: [MovieDB], right: [MovieDB]) -> [MovieDB] {
        var mergedArray: [MovieDB] = []
        var left = left
        var right = right
        
        while left.count > 0 && right.count > 0 {
            switch type {
            case .titleAsc,.titleDesc:
                left.first!.title! < right.first!.title! ? mergedArray.append(left.removeFirst()) :  mergedArray.append(right.removeFirst())
            case .popularityAsc,.popularityDesc:
                left.first!.popularity < right.first!.popularity ? mergedArray.append(left.removeFirst()) :  mergedArray.append(right.removeFirst())
            case .ratingAsc,.ratingDesc:
                left.first!.voteAverage < right.first!.voteAverage ? mergedArray.append(left.removeFirst()) :  mergedArray.append(right.removeFirst())
            }
            print("left \(left.count)")
            print("right \(right.count)")
            print("merged array \(mergedArray)")
        }
        print("hasil akhir \(mergedArray + left + right)")
        return mergedArray + left + right
    }
}
