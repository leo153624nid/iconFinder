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
    
    private lazy var searchTextField = SearchTextField(placeholder: Constants.searchTextFieldPlaceholder)
    private lazy var searchButton = SearchButton(title: Constants.searchButtonNormalTitle)
    private lazy var resultsLabel = UILabel()
    // Бесконечную пагинацию не делал, тк этого не было в условии, всегда получаю первые 20 элементов
    private lazy var tableView = UITableView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var noItemsLabel = UILabel()
    
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
        if viewModel.viewState != .loading {
            viewModel.perform(.find)
        }
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
                    self.noItemsLabel.isHidden = !viewModel.items.isEmpty
                case .loading:
                    self.tableView.isHidden = true
                    self.searchButton.setTitle(Constants.searchButtonLoadingTitle, for: .normal)
                    self.activityIndicator.startAnimating()
                    self.noItemsLabel.isHidden = true
                case .success(let message):
                    if let message {
                        self.showAlertView(title: Constants.alertSuccessTitle, message: message)
                        return
                    }
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.searchButton.setTitle(Constants.searchButtonNormalTitle, for: .normal)
                    self.activityIndicator.stopAnimating()
                    self.noItemsLabel.isHidden = !viewModel.items.isEmpty
                case .failure(let message):
                    self.tableView.isHidden = false
                    self.searchButton.setTitle(Constants.searchButtonNormalTitle, for: .normal)
                    self.activityIndicator.stopAnimating()
                    self.showAlertView(title: Constants.alertErrorTitle, message: message)
                    self.noItemsLabel.isHidden = !viewModel.items.isEmpty
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
        setupNoDataLabel()
        
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
        view.addSubview(noItemsLabel)
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
        searchTextField.returnKeyType = .done
    }
    
    func setupResultsLabel() {
        resultsLabel.font = .systemFont(ofSize: 30, weight: .bold)
        resultsLabel.text = Constants.resultLabelText
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self)
        tableView.accessibilityIdentifier = "mainTableView"
    }
    
    func setupNoDataLabel() {
        noItemsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        noItemsLabel.text = Constants.noDataLabelText
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle, style: .default))
        self.present(alert, animated: true)
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
        setupNoDataLabelConstraints()
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
    
    func setupNoDataLabelConstraints() {
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            noItemsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        viewModel.perform(.downLoadImage(item))
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

//MARK: - Local Constants
extension MainViewController {
    struct Constants {
        static let searchButtonNormalTitle = "Find"
        static let searchButtonLoadingTitle = "Loading"
        static let searchTextFieldPlaceholder = "Enter icon name..."
        static let resultLabelText = "Results:"
        static let alertErrorTitle = "Some error"
        static let alertSuccessTitle = "Success"
        static let alertButtonTitle = "Ok"
        static let noDataLabelText = "No icons"
    }
}
