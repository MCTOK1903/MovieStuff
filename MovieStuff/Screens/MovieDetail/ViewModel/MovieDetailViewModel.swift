//
//  MovieDetailViewModel.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 13.08.2022.
//

import Foundation

enum MovieDetailViewModelState {
    case setData
    case updateCast(CastViewModel)
    case showError(String)
}

protocol MovieDetailViewModelOutput {
    func updateState(_ state: MovieDetailViewModelState)
}

class MovieDetailViewModel: Coordinating {
    
    // MARK: Enum
    private enum Constant {
        static let unknown = "Unknown"
        static let name = "Name: "
        static let description = "Description: "
        static let rating = "Rating: "
    }
    
    // MARK: Properties
    private let type: MediaType
    private let id: Int
    private let httpClient: HttpClientProtocol
    var output: MovieDetailViewModelOutput?
    var coordinator: Coordinator?
    private var movieDetail: MovieDetailModel?
    private var tvDetail: TVDetail?
    
    // MARK: Init
    init(type: MediaType,
         id: Int,
         httpClient: HttpClientProtocol) {
        self.type = type
        self.id = id
        self.httpClient = httpClient
        
        fetchDetail()
    }
    
    // MARK: Public Funs
    func getImageURL() -> URL {
        switch type {
        case .movie:
            return Constants.generateImageURL(with: movieDetail?.posterPath ?? .empty) ?? Constants.emptyImageURL
        case .tv:
            return Constants.generateImageURL(with: tvDetail?.posterPath ?? .empty) ?? Constants.emptyImageURL
        default:
            return Constants.emptyImageURL
        }
    }
    
    func getMovieName() -> String {
        switch type {
        case .movie:
            guard let name = movieDetail?.originalTitle else {
                return Constant.unknown
            }
            return Constant.name + name
        case .tv:
            guard let name = tvDetail?.originalName else {
                return Constant.unknown
            }
            return Constant.name + name
        default:
            return Constant.unknown
        }
    }
    
    func getDescription() -> String {
        switch type {
        case .movie:
            guard let description = movieDetail?.overview else {
                return Constant.unknown
            }
            return Constant.description + description
        case .tv:
            guard let description = tvDetail?.overview else {
                return Constant.unknown
            }
            return Constant.description + description
        default:
            return Constant.unknown
        }
    }
    
    func getRating() -> String {
        switch type {
        case .movie:
            guard let rating = movieDetail?.voteAverage else {
                return Constant.unknown
            }
            return Constant.rating + "\(rating)"
        case .tv:
            guard let rating = tvDetail?.voteAverage else {
                return Constant.unknown
            }
            return Constant.rating + "\(rating)"
        default:
            return Constant.unknown
        }
    }
    
    // MARK: Private Funcs
    func fetchDetail() {
        switch type {
        case .movie:
            fetchMovieDetail()
            getCast(path: .movie)
        case .person:
            fetcPersonDetail()
        case .tv:
            fetchTVDetail()
            getCast(path: .tv)
        default:
            break
        }
    }
    
    private func fetchMovieDetail() {
        fetch(url: Constants.generateDetailURL(with: .movie, id: id)) { [weak self] (response: Result<MovieDetailModel, Error>) in
            switch response {
            case .success(let movieDetail):
                self?.movieDetail = movieDetail
                self?.output?.updateState(.setData)
            case .failure(let error):
                self?.output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    private func fetcPersonDetail() {
        fetch(url: Constants.generateDetailURL(with: .person, id: id)) { [weak self] (response: Result<PersonModel, Error>) in
            switch response {
            case .success(let personDetail):
                print(personDetail)
            case .failure(let error):
                self?.output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    private func fetchTVDetail() {
        fetch(url: Constants.generateDetailURL(with: .tv, id: id)) { [weak self] (response: Result<TVDetail, Error>) in
            switch response {
            case .success(let tvDetail):
                self?.tvDetail = tvDetail
                self?.output?.updateState(.setData)
            case .failure(let error):
                self?.output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    
    private func fetch<T: Codable>(url: URL?, completion: @escaping resultClosure<T>) {
        guard let url = url else {
            output?.updateState(.showError(HttpError.badURL.localizedDescription))
            return
        }
        
        httpClient.fetch(url: url, completion: completion)
    }
    
    private func getCast(path: Constants.MovieDetailPathURL) {
        fetch(url: Constants.generateDetailSubURL(with: path, id: id, subPath: .cast)) { [weak self] (response: Result<CreditModel, Error>) in
            switch response {
            case .success(let credit):
                let viewModel = CastViewModel(cast: credit.cast ?? [])
                self?.output?.updateState(.updateCast(viewModel))
            case .failure(let error):
                self?.output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
}
