//
//  MainViewController.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    private lazy var searchTextField = SearchTextField(placeholder: "Enter icon name...")
    private lazy var searchButton = SearchButton(title: "Find")
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    @objc private func searchButtonTapped() {
        print("Tapped")
    }
}

//MARK: - Setting Views
private extension MainViewController {
    func setupViews() {
        addSubviews()
        addTargets()
        setupLayout()
    }
}

//MARK: - Setting
private extension MainViewController {
    func addSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
    }
    
    func addTargets() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
}

//MARK: - Layout
private extension MainViewController {
    func setupLayout() {
        setupSearchTextField()
        setupSearchButton()
    }
    
    func setupSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
        ])
    }
    
    func setupSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            searchButton.widthAnchor.constraint(equalToConstant: 100),
            searchButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 0),
        ])
    }
}
