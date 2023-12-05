//
//  UIViewController+Extension.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 30/10/23.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 4
        self.present(alert,animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            alert.dismiss(animated: true)
        }
    }
}
