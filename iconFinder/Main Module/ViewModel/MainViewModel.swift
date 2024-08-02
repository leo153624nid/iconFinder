//
//  MainViewModel.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation
import Combine

enum MainViewModelAction {
    case find
}

enum MainViewState {
    case initial
    case loading
    case success
    case failure
}

final class MainViewModel: ObservableObject {
    private let converter = IconItemConverter()
    
    @Published var viewState = MainViewState.initial
    @Published var searchText = ""
    @Published var items = [MainTableViewCellData]()
    
    var isValidSearchText: AnyPublisher<Bool, Never> {
        $searchText
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    func perform(_ action: MainViewModelAction) {
        switch action {
        case .find:
            viewState = .loading
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                let mocks = [
                    IconItem(iconID: 0, tags: [], rasterSizes: []),
                    IconItem(iconID: 1, tags: [], rasterSizes: []),
                    IconItem(iconID: 2, tags: [], rasterSizes: []),
                ]
                self.items = converter.map(items: mocks)
                self.viewState = .success
            }
        }
    }
    
}
