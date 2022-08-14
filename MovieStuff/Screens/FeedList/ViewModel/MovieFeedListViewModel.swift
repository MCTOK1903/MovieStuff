//
//  MovieFeedListViewModel.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation

enum MovieListViewModelState {
    case showMovieList(MovieListCellViewModel)
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
    func resetSearch()
    func eventOccored(type: MediaType, id: Int)
}

final class MovieFeedListViewModel: MovieFeedListViewModelProtocol {
    
    // MARK: Properties
    weak var output: MovieFeedListViewModelOutput?
    private var httpClient: HttpClientProtocol?
    private var searchResult: [SubResult] = []
//    var coordinator: Coordinator?
    
    // MARK: Init
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
//        self.coordinator = coordinator
    }
    
    // MARK: Private Funcs
    private func fetch<T: Codable>(url: URL?, completion: @escaping resultClosure<T>) {
        guard let url = url else {
            output?.updateState(.showError(HttpError.badURL.localizedDescription))
            return
        }

        httpClient?.fetch(url: url, completion: completion)
    }
    
    private func addMovieType(searchResult: [SubResult]) -> [SubResult ]{
        var searchResult: [SubResult] = searchResult
        for (index, _) in searchResult.enumerated() {
            searchResult[index].mediaType = .movie
        }
        return searchResult
    }
    
    // MARK: Public Funcs
    func getMovies() {
        output?.updateState(.isLoading(true))
        
        fetch(url: Constants.generateURL(with: .type_url,
                                      searchKey: .empty))
        { [output, weak self] (result: Result<SearchResult, Error>) in
            guard let self = self else { return }
            output?.updateState(.isLoading(false))
            
            switch result {
            case .success(let movie):
                guard let movieResult = movie.subResults else {
                    output?.updateState(.showError(HttpError.badResponse.localizedDescription))
                    return
                }
                self.searchResult = movieResult
                let viewModel = MovieListCellViewModel(subResult:   self.addMovieType(searchResult: movieResult),
                                                       isSearch: false)
                output?.updateState(.showMovieList(viewModel))
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
                let viewModel = MovieListCellViewModel(subResult: subResult,
                                                       isSearch: true)
                output?.updateState(.showMovieList(viewModel))
            case .failure(let error):
                output?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    func resetSearch() {
        let viewModel = MovieListCellViewModel(subResult: self.searchResult,
                                               isSearch: false)
        output?.updateState(.showMovieList(viewModel))
    }
    
    func eventOccored(type: MediaType, id: Int) {
//        coordinator?.eventOccurred(with: .goToDetail, itemType: type, id: id)
    }
}
