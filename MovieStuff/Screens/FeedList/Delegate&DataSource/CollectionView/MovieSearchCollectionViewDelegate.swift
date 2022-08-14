//
//  MovieSearchCollectionViewDelegate.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 12.08.2022.
//

import UIKit

protocol MovieSearchCollectionViewDelegateOutput: AnyObject {
    func didSelectItem(type: MediaType, id: Int)
}

class MovieSearchCollectionViewDelegate: NSObject {
    
    private var viewModel: MovieListCellViewModel?
    private var isSearchResult: Bool?
    private weak var output: MovieSearchCollectionViewDelegateOutput?
    
    func update(cellViewModel: MovieListCellViewModel,
                output: MovieSearchCollectionViewDelegateOutput) {
        self.viewModel = cellViewModel
        self.output = output
        self.isSearchResult = cellViewModel.isSearchResult()
    }
}

extension MovieSearchCollectionViewDelegate: UICollectionViewDelegateFlowLayout,
                                             UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let sizeCalculator = MovieSearchCellSizeCalculator(flowLayout: flowLayout,
                                                               width: UIScreen.main.bounds.size.width)
            return sizeCalculator.estimatedItemSize
        }
        return .zero
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        output?.didSelectItem(type: viewModel.getMediaType(indexPath: indexPath),
                              id: viewModel.getID(indexPath: indexPath))
    }
}

