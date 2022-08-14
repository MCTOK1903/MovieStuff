//
//  CastDetailViewController.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import Foundation

enum CastDetailViewModelState {
    case setData
    case showError(String)
}

protocol CastDetailViewModelProcol {
    var ouput: CastDetailViewModelOutput? { get set }
    
    func getImageURL() -> URL
    func getName() -> String
    func getDescription() -> String
}

protocol CastDetailViewModelOutput: AnyObject {
    func updateState(_ state: CastDetailViewModelState)
}

final class CastDetailViewModel: CastDetailViewModelProcol {
    
    private var cast: PersonModel?
    private var id: Int
    private var httpClient: HttpClientProtocol
    weak var ouput: CastDetailViewModelOutput?
    
    // MARK: Init
    
    init(id: Int, httpClient: HttpClientProtocol) {
        self.id = id
        self.httpClient = httpClient
        
        self.fetchCastDetail()
    }
    
    // MARK: Private Func
    private func fetchCastDetail() {
        guard let url = Constants.generateDetailURL(with: .person, id: id) else { return }
        httpClient.fetch(url: url) { [weak self] (response: Result<PersonModel, Error>) in
            switch response {
            case .success(let model):
                self?.cast = model
                self?.ouput?.updateState(.setData)
            case .failure(let error):
                self?.ouput?.updateState(.showError(error.localizedDescription))
            }
        }
    }
    
    // MARK: Public Funcs
    func getImageURL() -> URL {
        guard let imagePath = cast?.profilePath,
              let imageURL = Constants.generateImageURL(with: imagePath) else { return Constants.emptyImageURL }
        return imageURL
    }
    
    func getName() -> String {
        cast?.name ?? .empty
    }
    
    func getDescription() -> String {
        cast?.biography ?? .empty
    }
}
