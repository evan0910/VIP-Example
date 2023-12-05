//
//  PersonCollectionViewCell.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 30/10/23.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photos: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!

    func setup(viewModel: MovieCastModel.MovieCastViewModel) {
        nameLabel.text = viewModel.name
        characterLabel.text = "(\(viewModel.character))"
        guard let url = URL(string: viewModel.photo) else { return }
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.separator.cgColor
        ImageDownloader.share.downloadImage(fromURL: url) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    if viewModel.id == self.tag {
                        self.photos.image = image
                    }
                case .failure( _):
                    self.photos.image = UIImage(named: "ic_no_photo")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photos.image = UIImage(named: "ic_no_photo")
    }
    
    

}
