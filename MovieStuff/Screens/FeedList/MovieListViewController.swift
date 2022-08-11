//
//  MovieListViewController.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController {
    
    // MARK: View
    private var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search"
        search.searchBar.showsCancelButton = true
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier
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
    private var searchBarDelegate: SearchBarDelegate?
    
    // MARK: Init
    init(viewModel: MovieFeedListViewModelProtocol,
         dataSource: MovieSearchCollectionViewDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
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
        collectionView.delegate = dataSource
        
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
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeIndcator() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.width.equalTo(40)
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
        case .showMovieList(let result, let isSearchResult):
            dataSource?.update(subResult: result,
                               isSearchResult: isSearchResult)
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
}
