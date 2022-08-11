//
//  MovieListBuilder.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation
import Alamofire

class MovieListBuilder {
    static func build() -> MovieListViewController {
        let httpClient = HttpClient(afSession: Alamofire.Session.default)
        let viewModel = MovieFeedListViewModel(httpClient: httpClient)
        let dataSource = MovieSearchCollectionViewDataSource()
        
        let viewController = MovieListViewController(viewModel: viewModel,
                                                     dataSource: dataSource)
        
        return viewController
    }
}
