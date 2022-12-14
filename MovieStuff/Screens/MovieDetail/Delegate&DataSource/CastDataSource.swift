//
//  CastDataSource.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import UIKit

protocol CastDataSourceOutput: AnyObject {
    func didSelectItem(id: Int)
}

class CastDataSource: NSObject {
    
    private var viewModel: CastViewModel?
    private var output: CastDataSourceOutput?
    
    init(output: CastDataSourceOutput?) {
        self.output = output
    }
    
    func update(cellViewModel: CastViewModel) {
        self.viewModel = cellViewModel
    }
}

// MARK: - UICollectionViewDataSource
extension CastDataSource: UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout,
                          UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CastCollectionViewCell,
              let viewModel = viewModel else {
            return UICollectionViewCell()
        }

        cell.configure(viewModel: viewModel,
                       indexPath: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectItem(id: viewModel?.getId(indexPath: indexPath) ?? .zero)
    }
}
