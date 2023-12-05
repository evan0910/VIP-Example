//
//  MoviesCollectionViewCell.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 23/10/23.
//

import UIKit
import Combine

class MoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellData(viewModel: MovieListModel.MoviesViewModel) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        titleLabel.text = viewModel.movieTitle
        yearLabel.text = viewModel.movieYear
        watchedLabel.isHidden = !viewModel.isWatched
        ratingView.backgroundColor = viewModel.rating.color
        ratingLabel.text = viewModel.ratingValue
        containerView.alpha = 0.7
        guard let url = URL(string: viewModel.movieCover) else {
            loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            imageView.image = UIImage(named: "noImage")
            return
        }
        ImageDownloader.share.downloadImage(fromURL: url) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    if viewModel.id == self.tag {
                        self.imageView.image = image
                        self.loadingIndicator.isHidden = true
                        self.loadingIndicator.stopAnimating()
                    }
                case .failure( _):
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.imageView.image = UIImage(named: "noImage")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage()
        loadingIndicator.isHidden = true
    }
}
