//
//  NetworkCostants.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation


extension Constants {
    enum MoviePathURL: String {
        case type_url = "movie/popular"
        case search_multi = "search/multi"
    }
    
    enum MovieDetailPathURL: String {
        case person = "person"
        case movie = "movie"
        case tv = "tv"
    }
    
    enum MovieDetailSubPath: String {
        case images = "images"
        case cast = "credits"
    }
}
