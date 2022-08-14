//
//  CastCollectionViewCell.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import UIKit
import AlamofireImage

class CastCollectionViewCell: UICollectionViewCell {
    
    // MARK: Views
    private lazy var parentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var castImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 8
        return image
    }()
    
    private var castName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Properties
    private var viewModel: CastViewModel?
    private var indexPath: IndexPath?
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
        configureConstaints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        castImage.image = nil
        castName.text = nil
    }
    
    // MARK: Public Func
    func configure(viewModel: CastViewModel,
                   indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        configureCell()
    }
    
    // MARK: Private Funcs
    private func configureUI() {
        contentView.addSubview(parentStackView)
        parentStackView.addArrangedSubview(castImage)
        parentStackView.addArrangedSubview(castName)
        
        self.layer.cornerRadius = 8
    }
    
    private func configureConstaints() {
        parentStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    private func configureCell() {
        guard let viewModel = viewModel,
              let indexPath = indexPath else { return }
        configureImage(url: viewModel.getImageURL(indexPath: indexPath))
        configureTitle(stringTitle: viewModel.getName(indexPath: indexPath))
    }
    
    private func configureTitle(stringTitle: String) {
        castName.isHidden = stringTitle == .empty
        castName.text = stringTitle
    }
    
    private func configureImage(url: URL) {
        castImage.widthAnchor.constraint(equalTo: castImage.heightAnchor,
                                         multiplier: 0.75).isActive = true
        castImage.af.setImage(withURL: url,
                              progressQueue: .global())
    }
}
