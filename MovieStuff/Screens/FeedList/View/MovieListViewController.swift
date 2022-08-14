//
//  MovieListViewController.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController, Coordinating {

    // MARK: Constant
    private enum Constant {
        static let searchHeight: CGFloat = 40
    }
    
    // MARK: View
    private var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search"
        return search
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            MovieListHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieListHeaderReusableView.reuseIdentifier
        )
        return collectionView
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        return indicator
    }()
    
    // MARK: Properties
    private var viewModel: MovieFeedListViewModelProtocol?
    private var dataSource: MovieSearchCollectionViewDataSource?
    private var delegate:  MovieSearchCollectionViewDelegate?
    private var searchBarDelegate: SearchBarDelegate?
    var coordinator: Coordinator?
    
    // MARK: Init
    init(viewModel: MovieFeedListViewModelProtocol,
         dataSource: MovieSearchCollectionViewDataSource,
         delegate: MovieSearchCollectionViewDelegate) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.output = self
        searchBarDelegate = SearchBarDelegate(output: self)
        viewModel?.getMovies()
        configureUI()
    }
    
    // MARK: Private Funcs
    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.searchController = searchBar
        
        configureContraints()
        configureDelegate()
    }
    
    private func configureDelegate() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let sizeCalculator = MovieSearchCellSizeCalculator(flowLayout: flowLayout, width: UIScreen.main.bounds.size.width)
            collectionView.contentInset = sizeCalculator.contentInset
            collectionView.collectionViewLayout = sizeCalculator.getFlowLayout()
        }
        
        searchBar.searchBar.delegate = searchBarDelegate
    }
    
    private func configureContraints() {
        view.addSubview(collectionView)
        view.addSubview(indicator)
        
        movieCollection()
        makeIndcator()
    }
    
    private func movieCollection() {
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
    
    private func makeIndcator() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.width.equalTo(Constant.searchHeight)
        }
    }
    
    private func showIndicator(isShow: Bool) {
        if isShow {
            indicator.isHidden = !isShow
            collectionView.isHidden = isShow
            indicator.startAnimating()
        } else {
            indicator.isHidden = !isShow
            collectionView.isHidden = isShow
            indicator.stopAnimating()
        }
    }
}

// MARK: - MovieFeedListViewModelOutput
extension MovieListViewController: MovieFeedListViewModelOutput {
    func updateState(_ state: MovieListViewModelState) {
        switch state {
        case .showMovieList(let cellViewModel):
            dataSource?.update(cellViewModel: cellViewModel)
            delegate?.update(cellViewModel: cellViewModel,
                             output: self)
            collectionView.reloadData()
        case .showError(let error):
            print(error)
        case .isLoading(let isShow):
            showIndicator(isShow: isShow)
        }
    }
}

// MARK: - SearchBarDelegateOutput
extension MovieListViewController: SearchBarDelegateOutput {
    func searchTapped(_ searchKey: String) {
        viewModel?.search(with: searchKey)
    }
    
    func resetSearch() {
        viewModel?.resetSearch()
    }
}

extension MovieListViewController: MovieSearchCollectionViewDelegateOutput {
    func didSelectItem(type: MediaType, id: Int) {
        navigationController?.pushViewController(MovieDetailBuilder.build(type: type, id: id), animated: true)
    }
}
