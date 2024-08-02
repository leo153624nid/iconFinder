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
    private lazy var resultsLabel = UILabel()
    private lazy var tableView = UITableView()
    
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
        setupViews()
    }
    
    @objc private func searchButtonTapped() {
        print("Tapped")
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("choose cell")
    }

}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MainTableViewCell.self, for: indexPath)
        cell.configure(with: "MainTableViewCell") // TODO: - update
        return cell
    }
    
}

//MARK: - Setting Views
private extension MainViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        addSubviews()
        addTargets()
        setupResultsLabel()
        setupTableView()
        setupLayout()
    }
}

//MARK: - Setting
private extension MainViewController {
    func addSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(resultsLabel)
        view.addSubview(tableView)
    }
    
    func addTargets() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    func setupResultsLabel() {
        resultsLabel.font = .systemFont(ofSize: 30, weight: .bold)
        resultsLabel.text = "Results:"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self)
    }
}

//MARK: - Layout
private extension MainViewController {
    func setupLayout() {
        setupSearchTextFieldConstraints()
        setupSearchButtonConstraints()
        setupResultsLabelConstraints()
        setupTableViewConstraints()
    }
    
    func setupSearchTextFieldConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
        ])
    }
    
    func setupSearchButtonConstraints() {
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
    
    func setupResultsLabelConstraints() {
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            resultsLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            resultsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            resultsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
        ])
    }
    
    func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}
