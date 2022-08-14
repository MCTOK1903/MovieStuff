//
//  CastDetailBuilder.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import Foundation
import Alamofire

enum CastDetailBuilder {
    static func build(id: Int) -> CastDetailViewController {
        let httpClient = HttpClient(afSession: Alamofire.Session.default)
        let viewModel = CastDetailViewModel(id: id, httpClient: httpClient)
        let vc = CastDetailViewController(viewModel: viewModel)
        
        return vc
    }
}
