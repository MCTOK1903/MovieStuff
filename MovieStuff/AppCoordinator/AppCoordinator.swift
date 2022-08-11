//
//  AppCoordinator.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation
import UIKit

enum Event {
    case goToDetail
}

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func eventOccurred(with type: Event, item: Any)
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?

    func eventOccurred(with type: Event, item: Any) {
//        switch type {
//        case .goToDetail:
//            var vc: UIViewController & Coordinating = ItemDetailViewController(resultDetail: item as? Result)
//            vc.coordinator = self
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }

    func start() {
//        let service: IService = Services()
//        let viewModel = ItemSearchViewModel(
//            service: service,
//            coordinator: self
//        )
//        let searchTableViewProvider = SearchResultCollectionViewProvider()
//        let vc: UIViewController = ItemSearchViewController(
//            viewModel: viewModel,
//            searchResultCollectionViewDelegate: searchTableViewProvider
//        )
        navigationController?.setViewControllers([FeedListViewController()], animated: false)
    }
}
