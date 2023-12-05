//
//  DetailViewPresenter.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 26/10/23.
//

import Foundation

protocol IDetailViewPresenter: AnyObject {
    func presentSuccessGetDetail(result: DetailMovieModel.Response)
    func presentFailedGetDetail(message: String)
    func presentSuccessGetCast(result: MovieCastModel.Response)
    func presentFailedGetCast(message: String)
}

class DetailViewPresenter: IDetailViewPresenter {
    
    var view: IDetailViewController
    
    init(view: IDetailViewController) {
        self.view = view
    }
    
    func presentSuccessGetDetail(result: DetailMovieModel.Response) {
        let viewModel = DetailMovieModel.DetailMovieViewModel(
            id: result.id ?? 0,
            movieTitle: "\(result.originalTitle ?? "") (\(result.releaseDate?.getYear() ?? ""))",
            rating: result.voteAverage?.rounded(toPlaces: 1) ?? 0,
            ratingValue: result.voteCount ?? 0,
            movieYear: result.releaseDate?.getYear() ?? "",
            movieCover: "\(BaseURL.avatar.rawValue)\(result.posterPath ?? "")",
            backdropCover: "\(BaseURL.avatar.rawValue)\(result.backdropPath ?? "")",
            isWatched: false,
            synopsis: result.overview ?? "",
            genres: (result.genres ?? []).map{ $0.name ?? "" }.joined(separator: ","),
            tagline: result.tagline ?? "",
            runtime: (result.runtime ?? 0).calculateTime(),
            releaseDate: result.releaseDate ?? "",
            isAdult: result.adult ?? false,
            popularity: result.popularity ?? 0.0
        )
        view.displaySuccessGetDetailMovie(viewModel: viewModel)
        
    }
    
    func presentFailedGetDetail(message: String) {
        view.displayFailedToGetData(message: message)
    }
    
    func presentSuccessGetCast(result: MovieCastModel.Response) {
        var castList: [MovieCastModel.MovieCastViewModel] = []
        guard let casts = result.cast else { return }
        for cast in casts {
            let film = MovieCastModel.MovieCastViewModel(name: cast.name ?? "", photo: "\(BaseURL.avatar.rawValue)\(cast.profilePath ?? "")", character: cast.character ?? "", id: cast.id ?? 0)
            castList.append(film)
        }
        view.displaySuccessGetCast(viewModel: castList)
    }
    
    func presentFailedGetCast(message: String) {
        view.displayFailedToGetData(message: message)
    }
}
