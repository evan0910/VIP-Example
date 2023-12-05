//
//  SearchViewRouter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import Foundation
import UIKit

protocol ISearchRouter: AnyObject {
    func routeToDetailMovie(from: UIViewController, id: Int, title: String)
}

class SearchRouter: ISearchRouter {
    
    static func assembleModule() -> UIViewController {
        let viewController = SearchViewController()
        let presenter = SearchViewPresenter(view: viewController)
        let movieWorker = MovieSharedAPIWorker()
        let searchWorker = SearchAPIWorker()
        viewController.interactor = SearchViewInteractor(presenter: presenter,movieWorker: movieWorker, searchWorker: searchWorker)
        viewController.router = SearchRouter()
        return viewController
    }
    
    func routeToDetailMovie(from: UIViewController, id: Int, title: String) {
        let detailVC = DetailRouter.assembleModule(id: id)
        detailVC.title = title
        let detailNavVC = UINavigationController(rootViewController: detailVC)
        detailNavVC.modalPresentationStyle = .overCurrentContext
        detailNavVC.modalTransitionStyle = .crossDissolve
        from.present(detailNavVC, animated: true)
    }
}
