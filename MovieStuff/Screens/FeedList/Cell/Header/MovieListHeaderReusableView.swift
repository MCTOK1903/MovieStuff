//
//  CollectionReusableView.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 12.08.2022.
//

import UIKit
import SnapKit

class MovieListHeaderReusableView: UICollectionReusableView, Reusable {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.alpha = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self).inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
