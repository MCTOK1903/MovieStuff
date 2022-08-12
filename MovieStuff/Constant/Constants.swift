//
//  Constants.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation

struct Constants {
    
    static let BASE_URL = "https://api.themoviedb.org/3/"
    static let API_KEY = "?api_key=fc6fbc3ee72d36c19e1752a6ee0f6273"
    static let QUERY_URL = "&query="
    
    static let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/"
    static let PATH_URL = "w500"
    
    static let emptyImageURL: URL = URL(string: "https://www.swift-inc.com/public/images/images-empty.png")!
}

extension Constants {
    static func generateURL(with path: MoviePathURL, searchKey: String) -> URL? {
        searchKey.isEmpty ?
        URL(string: BASE_URL + path.rawValue + API_KEY) :
        URL(string: BASE_URL + path.rawValue + API_KEY + QUERY_URL + searchKey)
    }
    
    static func generateImageURL(with path: String) -> URL? {
        URL(string: IMAGE_BASE_URL + PATH_URL + path)
    }
}
