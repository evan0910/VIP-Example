//
//  SearchViewController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 28/10/23.
//

import UIKit

protocol ISearchViewController: AnyObject {
    func displaySuccessGetMovies(movies: [MovieListModel.MoviesViewModel])
    func displayFailedGetMovies(message: String)
    func displayEmptyState()
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var emptyStateView: UIView!
    
    var viewModel: [MovieListModel.MoviesViewModel] = []
    var interactor: ISearchViewInteractor?
    var router: ISearchRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.getTopRatedMovies(completion: nil)
    }
    
    func setupUI() {
        guard let image = UIImage(systemName: "magnifyingglass") else { return }
        searchTextfield.setIcon(image)
        collectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        searchTextfield.delegate = self
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel[safe: indexPath.row] else { return }
        router?.routeToDetailMovie(from: self, id: movie.id, title: movie.movieTitle)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count > 10 ? 10 : viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell,let movie = viewModel[safe: indexPath.row] else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 8.0
        cell.tag = movie.id
        cell.setupCellData(viewModel: movie)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 250)
    }
}

extension SearchViewController: ISearchViewController {
    func displayEmptyState() {
        emptyStateView.isHidden = false
    }
    
    func displaySuccessGetMovies(movies: [MovieListModel.MoviesViewModel]) {
        viewModel = movies
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.emptyStateView.isHidden = true
            self.collectionView.reloadData()
        }
    }
    
    func displayFailedGetMovies(message: String) {
        showAlert(message: message)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let query = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if query.count > 3 {
            interactor?.searchMovies(query: query, completion: nil)
        }
        return true
    }
}

