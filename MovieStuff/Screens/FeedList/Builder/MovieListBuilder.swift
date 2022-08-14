//
//  MovieListBuilder.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation
import Alamofire
import UIKit

enum MovieListBuilder {
    static func build() -> MovieListViewController {
        let navVC = UINavigationController()
        let coordinator = AppCoordinator()
        coordinator.navigationController = navVC
        
        let httpClient = HttpClient(afSession: Alamofire.Session.default)
         
        let viewModel = MovieFeedListViewModel(httpClient: httpClient)
        
        let dataSource = MovieSearchCollectionViewDataSource()
        let delegate = MovieSearchCollectionViewDelegate()
        
        let viewController = MovieListViewController(viewModel: viewModel,
                                                     dataSource: dataSource,
                                                     delegate: delegate)
        viewController.coordinator = coordinator
        return viewController
    }
}
