//
//  MovieSearchCellSizeCalculator.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 12.08.2022.
//

import UIKit

struct MovieSearchCellSizeCalculator {
    
    private enum Constant {
        static let contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let collectionViewEstimatedCellHeight: CGFloat = 320
        static let collectionViewIndicatorHeight: CGFloat = 50
        static let minimumLineSpacing: CGFloat = 8.0
        static let minimumInteritemSpacing: CGFloat = 0.0
        static let zero: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
    }
    
    // MARK: Private Properties
    private let flowLayout: UICollectionViewFlowLayout
    private let width: CGFloat
    private var space: CGFloat {
        return flowLayout.minimumLineSpacing + (flowLayout.collectionView?.contentInset.left ?? 0) + (flowLayout.collectionView?.contentInset.right ?? 0)
    }
    
    // MARK: Public Properties
    var contentInset: UIEdgeInsets {
        return Constant.contentInset
    }
    
    var estimatedItemSize: CGSize {
        return CGSize(width: floor((width - space) / 2),
                      height: Constant.collectionViewEstimatedCellHeight)
    }
    
    var zero: CGSize {
        return Constant.zero
    }
    
    var headerSize: CGSize {
        return CGSize(width: width, height: 40)
    }
    
     // MARK: - Initializers
    init(flowLayout: UICollectionViewFlowLayout, width: CGFloat) {
        self.flowLayout = flowLayout
        self.width = width
        
        setSpacing()
    }
    
    // MARK: Private Functions
    private func setSpacing() {
        flowLayout.minimumLineSpacing = Constant.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = Constant.minimumInteritemSpacing
    }
    
    // MARK: Public Functions
    public func getFlowLayout() -> UICollectionViewFlowLayout {
        return flowLayout
    }
}
