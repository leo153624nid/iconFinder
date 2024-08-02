//
//  MainViewModel.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation

enum MainViewModelAction {
    case find
}

enum MainViewState {
    case initial
    case loading
    case succeess
    case failure
}

final class MainViewModel: ObservableObject {
    
    func perform(_ action: MainViewModelAction) {
        switch action {
        case .find:
            break
        }
    }
    
}
