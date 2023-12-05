//
//  WatchlistViewController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 20/10/23.
//

import UIKit

protocol IWatchlistViewController: AnyObject {
    func displaySuccesGetWatchlist(movies: [MovieDB])
    func displayFailedOrEmptyWatchlist() 
}

class WatchlistViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    var viewModel: [MovieDB] = []
    
    var interactor: IWatchlistInteractor?
    var router: IWatchlistRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor?.getWatchlist()
    }
    
    func setupNavigation() {
        let button: UIButton = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        button.tintColor = .black
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        let bundle = Bundle(for: type(of: self))
        tableView.register(UINib(nibName: String.init(describing: WatchlistTableViewCell.self), bundle: bundle), forCellReuseIdentifier: "WatchlistTableViewCell")
        setupConstraint()
    }
    
    func setupConstraint() {
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc
    func didTapFilter() {
        router?.routeToFilter(from: self)
    }
}

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let data = viewModel[safe: indexPath.row] else { return }
            tableView.beginUpdates()
            viewModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            if viewModel.isEmpty { displayFailedOrEmptyWatchlist() }
            interactor?.removeItemInWatchlist(id: Int(data.id))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = viewModel[safe: indexPath.row] else { return }
        router?.routeToDetailMovie(from: self, id: Int(movie.id), title: movie.title ?? "")
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension WatchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistTableViewCell") as? WatchlistTableViewCell, let movie = viewModel[safe: indexPath.row] else { return UITableViewCell() }
        cell.tag = Int(movie.id)
        cell.setupData(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
}

extension WatchlistViewController: IWatchlistViewController {
    func displayFailedOrEmptyWatchlist() {
        let image = UIImage(named: "ic_empty_watchlist")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
    }
    
    func displaySuccesGetWatchlist(movies: [MovieDB]) {
        viewModel = movies
        tableView.backgroundView = nil
        tableView.reloadData()
    }
}

extension WatchlistViewController: IFilterViewController {
    func didTapSortBy(_ sort: SortBy) {
        switch sort {
        case .titleAsc:
            guard let sorted = interactor?.sortDataBy(.titleAsc, data: viewModel) else { return }
            viewModel = sorted
        case .titleDesc:
            guard let sorted = interactor?.sortDataBy(.titleDesc, data: viewModel) else { return }
            viewModel = sorted.reversed()
        case .popularityAsc:
            guard let sorted = interactor?.sortDataBy(.popularityAsc, data: viewModel) else { return }
            viewModel = sorted
        case .popularityDesc:
            guard let sorted = interactor?.sortDataBy(.popularityDesc, data: viewModel) else { return }
            viewModel = sorted.reversed()
        case .ratingAsc:
            guard let sorted = interactor?.sortDataBy(.ratingAsc, data: viewModel) else { return }
            viewModel = sorted
        case .ratingDesc:
            guard let sorted = interactor?.sortDataBy(.ratingDesc, data: viewModel) else { return }
            viewModel = sorted.reversed()
        }
        tableView.reloadData()
    }
}
