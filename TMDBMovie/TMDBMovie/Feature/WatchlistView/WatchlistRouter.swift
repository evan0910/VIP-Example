//
//  WatchlistRouter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 27/10/23.
//

import UIKit

protocol IWatchlistRouter: AnyObject {
    func routeToDetailMovie(from: UIViewController, id: Int, title: String)
    func routeToFilter(from: WatchlistViewController)
}

class WatchlistRouter: IWatchlistRouter {
    
    static func assembleModule() -> UIViewController {
        let viewController = WatchlistViewController()
        let presenter = WatchlistPresenter()
        presenter.view = viewController
        viewController.interactor = WatchlistInteractor(presenter: presenter)
        viewController.router = WatchlistRouter()
        return viewController
    }
    
    func routeToDetailMovie(from: UIViewController, id: Int, title: String) {
        let detailVC = DetailRouter.assembleModule(id: id)
        detailVC.title = title
        let detailNavVC = UINavigationController(rootViewController: detailVC)
        detailNavVC.modalPresentationStyle = .overCurrentContext
        from.tabBarController?.present(detailNavVC, animated: true)
    }
    
    func routeToFilter(from: WatchlistViewController) {
        let vc = FilterViewController()
        vc.delegate = from
        vc.modalPresentationStyle = .pageSheet
        if
            #available(iOS 15.0, *),
            let sheet = vc.sheetPresentationController
        {
            sheet.detents = [.medium()]
        }
        from.present(vc, animated: true, completion: nil)
    }
}
