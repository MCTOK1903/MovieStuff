//
//  CastViewModel.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import Foundation

class CastViewModel {
    
    // MARK: Properties
    private var cast: [Cast]
    
    // MARK: Init
    init(cast: [Cast]) {
        self.cast = cast
    }
    
    // MARK: Funcs
    func numberOfItemsInSection(section: Int) -> Int {
         cast.count
    }
    
    func getImageURL(indexPath: IndexPath) -> URL {
        
        let imagePath = cast[indexPath.item].profilePath
        
        guard let imagePath = imagePath,
              let imageURL = Constants.generateImageURL(with: imagePath) else { return Constants.emptyImageURL }
        return imageURL
    }
    
    func getName(indexPath: IndexPath) -> String {
        cast[indexPath.item].originalName ?? .empty
    }
}

