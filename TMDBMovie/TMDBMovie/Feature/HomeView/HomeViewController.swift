//
//  HomeViewController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 21/10/23.
//

import UIKit

protocol IHomeViewController: AnyObject {
    func displaySuccessGetMovies(movies: [MovieListModel.MoviesViewModel],isLoadMore: Bool)
    func displayFailedGetMovies(message: String)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleMenuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var menuGroupButton: [UIButton]!
    @IBOutlet weak var popularMenuButton: UIButton!
    @IBOutlet weak var buttonScrollToTop: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var interactor: IHomeViewInteractor?
    var router: IHomeViewRouter?
    
    var exceptionButton: UIButton?
    var refreshControl: UIRefreshControl! = UIRefreshControl()

    var viewModel: [MovieListModel.MoviesViewModel] = []
    var currentMovieType: MovieType = .popular
    var selectedID: IndexPath?
    
    init() {
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String.init(describing: HomeViewController.self), bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNeedUpdateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.getMovieWithType(.popular, isLoadMore: false, completion: nil)
    }
    
    func isNeedUpdateData() {
        guard let indexPath = selectedID, let id = viewModel[safe: indexPath.row]?.id else { return }
        if interactor?.isDataExistByID(id) ?? false {
            viewModel[indexPath.row].isWatched = true
            collectionView.reloadItems(at: [indexPath])
            selectedID = nil
        }
    }
    
    func reloadData() {
        let currentContentOffSet = collectionView.contentOffset
        UIView.setAnimationsEnabled(false)
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: { _ in
            self.collectionView.contentOffset = currentContentOffSet
        })
        UIView.setAnimationsEnabled(true)
    }
    
    func setupUI() {
        collectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        exceptionButton = popularMenuButton
        refreshControl.addTarget(self, action: #selector(didRefreshPage), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        buttonScrollToTop.layer.cornerRadius = 20
    }
    
    @objc
    func didRefreshPage() {
        interactor?.getMovieWithType(currentMovieType, isLoadMore: false, completion: nil)
    }
    
    func animateTitleMenu(exception: UIButton? = nil, isHidden: Bool) {
        menuGroupButton.forEach({ [weak self] button in
            if let exception, button == exception  { return }
            UIView.animate(withDuration: 0.3) {
                button.isHidden = isHidden
                self?.view.layoutIfNeeded()
            }
        })
    }


    @IBAction func didSelectMenu(_ sender: Any) {
        let isHidden = !(menuGroupButton.first?.isHidden ?? false)
        animateTitleMenu(exception: exceptionButton,isHidden: isHidden)
    }
    
    @IBAction func didTapPopularMovie(_ sender: UIButton) {
        animateTitleMenu(isHidden: true)
        currentMovieType = .popular
        exceptionButton = sender
        titleMenuButton.setTitle(MovieType.popular.rawValue, for: .normal)
        interactor?.getMovieWithType(.popular, isLoadMore: false, completion: nil)
    }
    
    @IBAction func didTapTopRatedMovie(_ sender: UIButton) {
        animateTitleMenu(isHidden: true)
        currentMovieType = .topRated
        exceptionButton = sender
        titleMenuButton.setTitle(MovieType.topRated.rawValue, for: .normal)
        interactor?.getMovieWithType(.topRated, isLoadMore: false, completion: nil)
    }
    
    @IBAction func didTapNowPlayingMovie(_ sender: UIButton) {
        animateTitleMenu(isHidden: true)
        currentMovieType = .nowPlaying
        titleMenuButton.setTitle(MovieType.nowPlaying.rawValue, for: .normal)
        exceptionButton = sender
        interactor?.getMovieWithType(.nowPlaying, isLoadMore: false, completion: nil)
    }
    
    
    @IBAction func didTapUpcomingMovie(_ sender: UIButton) {
        animateTitleMenu(isHidden: true)
        currentMovieType = .upcoming
        titleMenuButton.setTitle(MovieType.upcoming.rawValue, for: .normal)
        exceptionButton = sender
        interactor?.getMovieWithType(.upcoming, isLoadMore: false, completion: nil)
    }
    
    @IBAction func didTapScrollToTop(_ sender: Any) {
        collectionView.setContentOffset(.zero, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        buttonScrollToTop.isHidden = indexPath.row < 20
        if indexPath.row == viewModel.count-1 {
            interactor?.getMovieWithType(currentMovieType, isLoadMore: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel[safe: indexPath.row] else { return }
        selectedID = indexPath
        router?.routeToDetailMovie(from: self, id: movie.id, title: movie.movieTitle)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell,let movie = viewModel[safe: indexPath.row] else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 8.0
        cell.tag = movie.id
        cell.setupCellData(viewModel: movie)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 250)
    }
}

extension HomeViewController: IHomeViewController {
    func displaySuccessGetMovies(movies: [MovieListModel.MoviesViewModel],isLoadMore: Bool) {
        if !isLoadMore { self.viewModel.removeAll() }
        self.viewModel.append(contentsOf: movies)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            self.reloadData()
        }
    }
    
    func displayFailedGetMovies(message: String) {
        showAlert(message: message)
    }
}

