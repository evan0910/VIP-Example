//
//  HomeViewRouter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 24/10/23.
//

import Foundation
import UIKit

protocol IHomeViewRouter: AnyObject {
    func routeToDetailMovie(from: UIViewController, id: Int, title: String)
}

class HomeViewRouter: IHomeViewRouter {
    
    static func assembleModule() -> UIViewController {
        let viewController = HomeViewController()
        let presenter = HomeViewPresenter(view: viewController)
        let worker = MovieSharedAPIWorker()
        viewController.interactor = HomeViewInteractor(presenter: presenter,worker: worker)
        viewController.router = HomeViewRouter()
        return viewController
    }
    
    func routeToDetailMovie(from: UIViewController, id: Int, title: String) {
        let detailVC = DetailRouter.assembleModule(id: id)
        detailVC.title = title
        let detailNavVC = UINavigationController(rootViewController: detailVC)
        detailNavVC.modalPresentationStyle = .fullScreen
        detailNavVC.modalTransitionStyle = .crossDissolve
        from.present(detailNavVC, animated: true)
    }
}
