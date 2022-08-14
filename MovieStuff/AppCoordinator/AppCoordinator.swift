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
    func eventOccurred(with type: Event, itemType: MediaType, id: Int)
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?

    func eventOccurred(with type: Event, itemType: MediaType, id: Int) {
        switch type {
        case .goToDetail:
            break
//            let vc: UIViewController & Coordinating = MovieDetailBuilder.build(type: itemType, id: id, coordinator: self)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func start() {
        navigationController?.pushViewController(MovieListBuilder.build(), animated: false)
    }
}
