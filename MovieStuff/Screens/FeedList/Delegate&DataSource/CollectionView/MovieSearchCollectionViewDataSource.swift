//
//  MovieSearchCollectionViewDataSource.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit

class MovieSearchCollectionViewDataSource: NSObject {
    
    private var viewModel: MovieListCellViewModel?
    private var isSearchResult: Bool?
    
    func update(cellViewModel: MovieListCellViewModel) {
        self.viewModel = cellViewModel
        self.isSearchResult = cellViewModel.isSearchResult()
    }
}

// MARK: - UICollectionViewDataSource
extension MovieSearchCollectionViewDataSource: UICollectionViewDataSource,
                                               UICollectionViewDelegateFlowLayout,
                                               UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.numberOfSections() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsInSection(section: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieListCollectionViewCell,
              let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        
        cell.configure(viewModel: viewModel,
                       indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let sizeCalculator = MovieSearchCellSizeCalculator(flowLayout: flowLayout,
                                                               width: UIScreen.main.bounds.size.width)
            return sizeCalculator.estimatedItemSize
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieListHeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as? MovieListHeaderReusableView else { return UICollectionReusableView() }
        header.titleLabel.text = viewModel?.getHeaderTitle(indexPath: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
           isSearchResult ?? false {
            let sizeCalculator = MovieSearchCellSizeCalculator(flowLayout: flowLayout,
                                                               width: UIScreen.main.bounds.size.width)
            return sizeCalculator.headerSize
        }
        return .zero
    }
}
