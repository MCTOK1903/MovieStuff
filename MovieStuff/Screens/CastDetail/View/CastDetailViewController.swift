//
//  CastDetailViewController.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import UIKit

class CastDetailViewController: UIViewController {
    
    // MARK: View
    
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
    
    private var personImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private var personName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: Properties
    private var viewModel: CastDetailViewModelProcol?
    
    // MARK: Init
    init(viewModel: CastDetailViewModelProcol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        viewModel?.ouput = self
    }
    
    // MARK: Funcs
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(personImage)
        stackView.addArrangedSubview(personName)
        stackView.addArrangedSubview(descriptionLabel)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeScroll()
        makeStack()
        makeImage()
    }
    
    private func setData() {
        guard let viewModel = viewModel else {
            return
        }

        personImage.af.setImage(withURL: viewModel.getImageURL())
        personName.text = viewModel.getName()
        descriptionLabel.text = viewModel.getDescription()
    }
}

// MARK: CastDetailViewModelOutput
extension CastDetailViewController: CastDetailViewModelOutput {
    func updateState(_ state: CastDetailViewModelState) {
        switch state {
        case .setData:
            self.setData()
        case .showError(let error):
            showAlert(message: error)
        }
    }
}

//MARK: - Constraints

extension CastDetailViewController {
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
        personImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.size.height / 3)
            make.width.equalTo(view.frame.size.width / 1.1)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
