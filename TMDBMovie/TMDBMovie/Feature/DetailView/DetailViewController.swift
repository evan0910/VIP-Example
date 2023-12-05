//
//  DetailViewController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import UIKit

protocol IDetailViewController: AnyObject {
    func displaySuccessGetDetailMovie(viewModel: DetailMovieModel.DetailMovieViewModel)
    func displaySuccessGetCast(viewModel: [MovieCastModel.MovieCastViewModel])
    func displayFailedToGetData(message: String)
}


class DetailViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var watchlistView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var ratedView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet var shimmerView: [UIView]!
    
    var movieID: Int
    var viewModel: DetailMovieModel.DetailMovieViewModel?
    var interactor: IDetailViewInteractor?
    var movieCast: [MovieCastModel.MovieCastViewModel] = []
    
    init(id: Int) {
        movieID = id
        let type = type(of: self)
        super.init(nibName: String(describing: type), bundle: Bundle(for: type))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        setupNavigation()
        interactor?.getMovieDetailByID(movieID, completion: nil)
        interactor?.getMovieCastByID(movieID, completion: nil)
    }
    
    func setupNavigation() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupLoading() {
        loadingView.isHidden = false
        for view in shimmerView {
            view.startShimmer()
        }
    }
    
    @objc
    func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func setupView(viewModel: DetailMovieModel.DetailMovieViewModel) {
        titleLabel.text = viewModel.movieTitle
        synopsisLabel.text = viewModel.synopsis
        
        guard let posterURL = URL(string: viewModel.movieCover) else { return }
        ImageDownloader.share.downloadImage(fromURL: posterURL) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.posterImage.image = image
                case .failure( _):
                    self.posterImage.image = UIImage(named: "noImage")
                }
            }
        }
        
        guard let backdropURL = URL(string: viewModel.backdropCover) else { return }
        ImageDownloader.share.downloadImage(fromURL: backdropURL) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.backgroundImage.image = image
                case .failure( _):
                    self.backgroundImage.image = UIImage(named: "noImage")
                }
            }
        }
        hourLabel.text = "Runtime : \(viewModel.runtime)"
        genre.text = viewModel.genres
        ratedLabel.text = viewModel.isAdult ? "18+" : "R"
        ratingLabel.text = String(viewModel.rating)
        ratingView.backgroundColor = Rating(rating: viewModel.rating)?.color
        ratedView.layer.borderWidth = 1
        backgroundImage.alpha = 0.5
        taglineLabel.text = viewModel.tagline
        watchlistView.backgroundColor = .systemGray5
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PersonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PersonCollectionViewCell")
    }
    
    @IBAction func didTapWatchlist(_ sender: Any) {
        let isWatched = starButton.tintColor == .yellow
        starButton.tintColor = isWatched ? .lightGray : .yellow
        guard let viewModel else { return }
        isWatched ? interactor?.removeItemInWatchlist(id: viewModel.id) : interactor?.addItemToWatchlist(item: viewModel)
    }
}

extension DetailViewController: IDetailViewController {
   func displaySuccessGetDetailMovie(viewModel: DetailMovieModel.DetailMovieViewModel) {
       let localData = interactor?.getDataByID(id: viewModel.id)
       self.viewModel = viewModel
       DispatchQueue.main.async { [weak self] in
           guard let self else { return }
           self.loadingView.isHidden = true
           self.setupView(viewModel: viewModel)
           if localData != nil {
               self.starButton.tintColor = .yellow
           }
        }
    }
    
    func displaySuccessGetCast(viewModel: [MovieCastModel.MovieCastViewModel]) {
        movieCast = viewModel
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewHeightConstraint.constant = viewModel.count == 0 ? 0 : 200
            self?.collectionView.reloadData()
        }
    }
    
    func displayFailedToGetData(message: String) {
        showAlert(message: message)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCast.count > 10 ? 10 : movieCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as? PersonCollectionViewCell, let cast = movieCast[safe: indexPath.row] else { return UICollectionViewCell() }
        cell.setup(viewModel: cast)
        cell.tag = cast.id
        cell.layer.cornerRadius = 4
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
}
