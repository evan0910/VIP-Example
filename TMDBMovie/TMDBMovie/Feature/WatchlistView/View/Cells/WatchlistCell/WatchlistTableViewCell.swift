//
//  WatchlistTableViewCell.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 27/10/23.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(movie: MovieDB) {
        titleLabel.text = movie.title
        subtitleLabel.text = "\(movie.info)"
        descriptionLabel.text = "\(movie.overview ?? "")"
        imageView?.layer.cornerRadius = 8
        ratingLabel.text = String(movie.voteAverage.rounded(toPlaces: 1))
        popularityLabel.text = "Popularity : \(movie.popularity)"
        guard let url = URL(string: movie.posterPath ?? "") else { return }
        ImageDownloader.share.downloadImage(fromURL: url) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    if movie.id == self.tag {
                        self.posterImage.image = image
                    }
                case .failure( _):
                    self.posterImage.image = UIImage(named: "noImage")
                }
            }
        }
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = UIImage(named: "noImage")
    }
}
