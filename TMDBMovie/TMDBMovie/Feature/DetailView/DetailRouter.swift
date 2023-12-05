//
//  DetailRouter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 19/11/23.
//

import Foundation
import UIKit

class DetailRouter {
    static func assembleModule(id: Int) -> UIViewController {
        let viewController = DetailViewController(id: id)
        let presenter = DetailViewPresenter(view: viewController)
        let apiWorker = DetailMovieAPIWorker()
        viewController.interactor = DetailViewInteractor(apiWorker: apiWorker, presenter: presenter)
        return viewController
    }
}
