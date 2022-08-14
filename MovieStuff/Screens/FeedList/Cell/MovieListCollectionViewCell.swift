//
//  MovieListCollectionViewCell.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit
import AlamofireImage

class MovieListCollectionViewCell: UICollectionViewCell {
    
    // MARK: Views
    private lazy var parentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var mainImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 8
        return image
    }()
    
    private var movieName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var movieRating: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    // MARK: Properties
    private var viewModel: MovieListCellViewModel?
    private var indexPath: IndexPath?
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
        configureConstaints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImage.image = nil
        movieName.text = nil
        movieRating.text = nil
    }
    
    // MARK: Public Func
    func configure(viewModel: MovieListCellViewModel,
                   indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        configureCell()
    }
    
    // MARK: Private Funcs
    private func configureUI() {
        contentView.addSubview(parentStackView)
        parentStackView.addArrangedSubview(mainImage)
        parentStackView.addArrangedSubview(movieName)
        parentStackView.addArrangedSubview(movieRating)
        
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
        configureTitle(stringTitle: viewModel.getTitle(indexPath: indexPath))
        configureRating(stringRating: viewModel.getRating(indexPath: indexPath))
    }
    
    private func configureTitle(stringTitle: String) {
        movieName.isHidden = stringTitle == .empty
        movieName.text = stringTitle
    }
    
    private func configureRating(stringRating: String) {
        movieRating.isHidden = stringRating == .empty
        movieRating.text = stringRating
    }
    
    private func configureImage(url: URL) {
        mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor,
                                         multiplier: 0.75).isActive = true
        mainImage.af.setImage(withURL: url,
                              progressQueue: .global())
    }
}
