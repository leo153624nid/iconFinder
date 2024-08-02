//
//  MainViewController.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchTextField = SearchTextField(placeholder: "Enter icon name...")
    private lazy var searchButton = SearchButton(title: "Find")
    private lazy var resultsLabel = UILabel()
    private lazy var tableView = UITableView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        bindViewModel()
    }
    
    @objc private func searchButtonTapped() {
        viewModel.perform(.find)
    }
    
    @objc func endEditingTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//MARK: - Binding viewModel
private extension MainViewController {
    func bindViewModel() {
        // bind searchTextField
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .assign(to: \.searchText, on: viewModel)
            .store(in: &cancellables)
        
        // bind searchButton enabled
        viewModel.isValidSearchText
            .assign(to: \.isEnabled, on: searchButton)
            .store(in: &cancellables)
        
        // bind viewState
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self else { return }
                switch viewState {
                case .initial:
                    self.tableView.isHidden = true
                case .loading:
                    self.tableView.isHidden = true
                    self.searchButton.setTitle("Loading", for: .normal)
                    self.activityIndicator.startAnimating()
                case .success:
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.searchButton.setTitle("Find", for: .normal)
                    self.activityIndicator.stopAnimating()
                case .failure:
                    // TODO: - update
                    self.tableView.isHidden = false
                    self.searchButton.setTitle("Find", for: .normal)
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Setting Views
private extension MainViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        addSubviews()
        addTargets()
        setupEndEditingTapGestureRecognizer()
        setupSearchTextField()
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
        view.addSubview(activityIndicator)
    }
    
    func addTargets() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    func setupEndEditingTapGestureRecognizer() {
        let endEditingTapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingTap))
        endEditingTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(endEditingTapGesture)
    }
    
    func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
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
        setupActivityIndicatorConstraints()
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
    
    func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("choose cell")
        // TODO: - update
    }

}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MainTableViewCell.self, for: indexPath)
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
}

//MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField && searchButton.isEnabled {
            textField.resignFirstResponder()
            viewModel.perform(.find)
            return false
        }
        return true
    }
    
}
