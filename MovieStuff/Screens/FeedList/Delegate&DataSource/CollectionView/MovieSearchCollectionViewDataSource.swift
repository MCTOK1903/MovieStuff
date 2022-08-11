//
//  MovieSearchCollectionViewDataSource.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit

class MovieSearchCollectionViewDataSource: NSObject {
    
    private var subResult: [SubResult] = []
    
    func update(subResult: [SubResult],
                isSearchResult: Bool) {
        self.subResult = subResult
    }
}

// MARK: - UICollectionViewDataSource
extension MovieSearchCollectionViewDataSource: UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout,
                                               UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        subResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .gray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 100)
    }
}
