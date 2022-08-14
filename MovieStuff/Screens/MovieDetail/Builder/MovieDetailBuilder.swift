//
//  MovieDetailBuilder.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 13.08.2022.
//

import Foundation
import Alamofire

enum MovieDetailBuilder {
    static func build(type: MediaType, id: Int) -> MovieDetailViewController {
        
        let httpClient = HttpClient(afSession: Alamofire.Session.default)
        let viewModel = MovieDetailViewModel(type: type,
                                             id: id,
                                             httpClient: httpClient)
//        viewModel.coordinator = coordinator
        let vc = MovieDetailViewController(viewModel: viewModel)
        return vc
    }
}
