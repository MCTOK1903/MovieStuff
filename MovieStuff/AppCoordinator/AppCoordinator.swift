//
//  AppCoordinator.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation
import UIKit

enum Event {
    case goToDetail(MediaType, Int)
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    func eventOccored(event: Event)
    func start()
}

class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?

    init(navCon : UINavigationController) {
        self.navigationController = navCon
    }

    func start() {
        navigationController?.pushViewController(MovieListBuilder.build(appCoordinator: self), animated: false)
    }
    
    func eventOccored(event: Event) {
        switch event {
        case .goToDetail(let mediaType, let id):
            navigationController?.pushViewController(MovieDetailBuilder.build(type: mediaType, id: id), animated: true)
        }
    }
}
