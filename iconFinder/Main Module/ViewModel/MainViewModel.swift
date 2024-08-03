//
//  MainViewModel.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation
import Combine
import UIKit

enum MainViewModelAction {
    case find
    case downLoadImage(MainTableViewCellData)
}

enum MainViewState: Equatable {
    case initial
    case loading
    case success
    case failure(String)
}

final class MainViewModel: ObservableObject {
    private let iconService: FindIconService
    private let converter = IconItemConverter()
    
    @Published var viewState = MainViewState.initial
    @Published var searchText = ""
    @Published var items = [MainTableViewCellData]()
    
    var isValidSearchText: AnyPublisher<Bool, Never> {
        $searchText
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    init(iconService: FindIconService) {
        self.iconService = iconService
    }
    
    func perform(_ action: MainViewModelAction) {
        switch action {
        case .find:
            viewState = .loading
            
            iconService.fetchIconItems(query: searchText) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let iconsData):
                    self.items = self.converter.map(items: iconsData.icons)
                    self.viewState = .success
                case .failure(let error):
                    let message = "\(error.localizedDescription)\n\n\(error)"
                    self.viewState = .failure(message)
                }
            }
            
        case .downLoadImage(let item):
            iconService.downloadImage(from: item) { data, error in
                if let data {
                    let image = UIImage(data: data)
                    // TODO
                }
            }
        }
    }
    
}
