//
//  FilterViewController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import UIKit

enum SortBy {
    case titleAsc
    case titleDesc
    case popularityAsc
    case popularityDesc
    case ratingAsc
    case ratingDesc
}

protocol IFilterViewController: AnyObject {
    func didTapSortBy(_ sort: SortBy)
}

class FilterViewController: UIViewController {
    
    weak var delegate: IFilterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAscendingTitle(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.titleAsc)
    }
    
    @IBAction func didTapDescendingTitle(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.titleDesc)
    }
    
    @IBAction func didTapPopularityAscending(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.popularityAsc)
    }
    
    @IBAction func didTapPopularityDescending(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.popularityDesc)
    }
    
    
    @IBAction func didTapRatingAscending(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.ratingAsc)
    }
    
    @IBAction func didTapRatingDescending(_ sender: Any) {
        dismiss(animated: true)
        delegate?.didTapSortBy(.ratingDesc)
    }
}
