//
//  MovieDetailViewController.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 12.08.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .white
        scroll.contentSize = CGSize(width: 0 , height: view.frame.height)
        return scroll
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .lastBaseline
        stackView.spacing = 8
        return stackView
    }()
    
    private var movieImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private var movieName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
//        label.text = "\(MovieDetailConstant.PropertyLabel.description.rawValue):"
        return label
    }()
    
    private lazy var movieDescription: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var movieRating: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CastCollectionViewCell.self,
            forCellWithReuseIdentifier: CastCollectionViewCell.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    private let viewModel: MovieDetailViewModel?
    var coordinator: Coordinator?
    private var dataSource: CastDataSource?
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.output = self
        
        configureUI()
    }
    
    private func configureUI() {
        configureProperty()
        configureCollectionView()
    }
    
    private func configureData() {
        guard let viewModel = viewModel else {
            return
        }
        
        movieImage.af.setImage(withURL: viewModel.getImageURL())
        movieName.text = viewModel.getMovieName()
        movieDescription.text = viewModel.getDescription()
        movieRating.text = viewModel.getRating()
    }
    
    private func configureProperty() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(movieImage)
        stackView.addArrangedSubview(movieName)
        stackView.addArrangedSubview(movieRating)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(movieDescription)
        stackView.addArrangedSubview(collectionView)
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeScroll()
        makeStack()
        makeImage()
        makeCollectionView()
    }
    
    private func configureCollectionView() {
        dataSource = CastDataSource(output: self)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
    }
}

//MARK: - Constraints

extension MovieDetailViewController {
    private func makeScroll() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.right.equalTo(-8)
            make.left.equalTo(8)
            make.width.equalTo(view.frame.size.width)
        }
    }
    private func makeStack() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func makeImage() {
        movieImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.size.height / 3)
            make.width.equalTo(view.frame.size.width / 1.1)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func makeCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 16)
            make.height.equalTo(180)
        }
    }
}

// MARK: MovieDetailViewModelOutput
extension MovieDetailViewController: MovieDetailViewModelOutput {
    func updateState(_ state: MovieDetailViewModelState) {
        switch state {
        case .setData:
            configureData()
        case .updateCast(let cellViewModel):
            dataSource?.update(cellViewModel: cellViewModel)
            collectionView.reloadData()
        case .showError(let error):
            showAlert(message: error)
        }
    }
}

// MARK: CastDataSourceOutput
extension MovieDetailViewController: CastDataSourceOutput {
    func didSelectItem(id: Int) {
        viewModel?.goToCastDetail(id: id)
    }
}

