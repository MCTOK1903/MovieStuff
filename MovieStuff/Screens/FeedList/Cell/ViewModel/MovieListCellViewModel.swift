//
//  MovieListCellViewModel.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 12.08.2022.
//

import Foundation

class MovieListCellViewModel {
    
    // MARK: Constants
    private enum Constant {
        static let rating: String = "Rating: "
        static let ratingDefaultValue: Double = 0.0
    }
    
    // MARK: Properties
    private var isSearch: Bool
    private var subResult: [SubResult]
    private var filteredSubResults: [[SubResult]] = [[]]
    
    // MARK: Init
    init(subResult: [SubResult], isSearch: Bool) {
        self.subResult = subResult
        self.isSearch = isSearch
        
        filterSubResult()
    }
    
    // MARK: Public Funcs
    func isSearchResult() -> Bool {
        return isSearch
    }
    
    func numberOfSections() -> Int {
        isSearch ? 3 : 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        isSearch ? filteredSubResults[section + 1].count : subResult.count
    }
    
    func getImageURL(indexPath: IndexPath) -> URL {
        
        var imagePath: String?
        
        if isSearch {
            imagePath = getImagePath(indexPath: indexPath)
        } else {
            imagePath = subResult[indexPath.item].posterPath
        }
        
        guard let imagePath = imagePath,
              let imageURL = Constants.generateImageURL(with: imagePath) else { return Constants.emptyImageURL }
        return imageURL
        
    }
    
    func getTitle(indexPath: IndexPath) -> String {
        if isSearch {
            let item = filteredSubResults[indexPath.section + 1][indexPath.item]
            switch item.mediaType {
            case .person, .tv:
                return item.name ?? .empty
            default:
                return item.title ?? .empty
            }
        }
        
        return subResult[indexPath.item].title ?? .empty
    }
    
    
    func getRating(indexPath: IndexPath) -> String {
        var rating: Double = .zero
        if isSearch {
            rating = filteredSubResults[indexPath.section + 1][indexPath.item].voteAverage ?? .zero
        } else {
            rating = subResult[indexPath.item].voteAverage ?? .zero
        }
        
        if rating == Constant.ratingDefaultValue {
            return .empty
        }
        
        return Constant.rating + String(rating)
    }
    
    func getHeaderTitle(indexPath: IndexPath) -> String {
        let mediaType = filteredSubResults[indexPath.section + 1][indexPath.item].mediaType
        switch mediaType {
        case .movie:
            return mediaType?.rawValue.uppercased() ?? .empty
        case .tv:
            return mediaType?.rawValue.uppercased() ?? .empty
        case .person:
            return mediaType?.rawValue.uppercased() ?? .empty
        case .none:
            return .empty
        }
    }
    
    // MARK: Private Funcs
    private func filterSubResult() {
        if self.isSearch {
            filterResultAccordingToType()
        }
    }
    
    private func filterResultAccordingToType() {
        var movieList: [SubResult] = []
        var tvList: [SubResult] = []
        var personList: [SubResult] = []
        
        
        for (_, item) in subResult.enumerated() {
            switch item.mediaType {
            case .movie:
                movieList.append(item)
            case .tv:
                tvList.append(item)
            case .person:
                personList.append(item)
            case .none:
                break
            }
        }
        
        filteredSubResults.append(movieList)
        filteredSubResults.append(tvList)
        filteredSubResults.append(personList)
    }
    
    private func getImagePath(indexPath: IndexPath) -> String? {
        var imagePath: String?
        let mediaType = filteredSubResults[indexPath.section + 1][indexPath.item].mediaType
        
        switch mediaType {
        case .person:
            imagePath = filteredSubResults[indexPath.section + 1][indexPath.item].profilePath
        case .tv, .movie:
            imagePath = filteredSubResults[indexPath.section + 1][indexPath.item].posterPath
        case .none:
            break
        }
        return imagePath
    }
}
