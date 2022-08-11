//
//  MovieFeedListViewModel.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation

enum MovieListViewModelState {
    case showMovieList([SubResult], Bool)
    case showError(String)
    case isLoading(Bool)
}

protocol MovieFeedListViewModelOutput: AnyObject {
    func updateState(_ state: MovieListViewModelState)
}

protocol SearchResponseOutput: AnyObject {
    func updateSearchResult(_ state: MovieListViewModelState)
}

protocol MovieFeedListViewModelProtocol {
    var output: MovieFeedListViewModelOutput? { get set }
    
    func getMovies()
    func search(with searchKey: String) 
}

final class MovieFeedListViewModel: MovieFeedListViewModelProtocol {
    
    // MARK: Properties
    weak var output: MovieFeedListViewModelOutput?
    private var httpClient: HttpClientProtocol?
    private var searchResult: [SubResult] = []
    
    // MARK: Init
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    // MARK: Private Funcs
    private func fetch<T: Codable>(url: URL?, completion: @escaping resultClosure<T>) {
        guard let url = url else {
            output?.updateState(.showError(HttpError.badURL.localizedDescription))
            return
        }

        httpClient?.fetch(url: url, completion: completion)
    }
    
    // MARK: Public Funcs
    func getMovies() {
        output?.updateState(.isLoading(true))
        
        fetch(url: Constants.generateURL(with: .type_url,
                                      searchKey: .empty))
        { [output] (result: Result<SearchResult, Error>) in
            output?.updateState(.isLoading(false))
            
            switch result {
            case .success(let movie):
                guard let movieResult = movie.subResults else {
                    output?.updateState(.showError(HttpError.badResponse.localizedDescription))
                    return
                }
                output?.updateState(.showMovieList(movieResult, false))
            case .failure(let error):
                output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    func search(with searchKey: String) {
        fetch(url: Constants.generateURL( with: .search_multi,
                                          searchKey: searchKey))
        { [output] (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let searchModel):
                guard let subResult = searchModel.subResults else {
                    output?.updateState(.showError(HttpError.badResponse.localizedDescription))
                    return
                }
                output?.updateState(.showMovieList(subResult, true))
            case .failure(let error):
                output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
}
