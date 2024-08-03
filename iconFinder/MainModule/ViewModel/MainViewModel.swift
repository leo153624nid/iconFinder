//
//  MainViewModel.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation
import Combine
import UIKit

//MARK: - MainViewState
enum MainViewState: Equatable {
    case initial
    case loading
    case success(String?)
    case failure(String)
}

//MARK: - MainViewModelAction
enum MainViewModelAction {
    case find
    case downLoadImage(MainTableViewCellData)
}

//MARK: - MainViewModel
final class MainViewModel: ObservableObject {
    private let iconService: FindIconService
    private let iconSaver: ImageSaver
    private let converter = IconItemConverter()
    
    @Published var viewState = MainViewState.initial
    @Published var searchText = ""
    @Published var items = [MainTableViewCellData]()
    
    var isValidSearchText: AnyPublisher<Bool, Never> {
        $searchText
            .map { $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    init(iconService: FindIconService, iconSaver: ImageSaver) {
        self.iconService = iconService
        self.iconSaver = iconSaver
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
                    self.viewState = .success(nil)
                case .failure(let error):
                    let message = "\(error.localizedDescription)\n\n\(error)"
                    self.viewState = .failure(message)
                }
            }
            
        case .downLoadImage(let item):
            iconService.downloadImage(from: item) { [weak self] data, error in
                guard let self else { return }
                
                if let error {
                    self.viewState = .failure(error.localizedDescription)
                    return
                }
                guard let data, let image = UIImage(data: data) else {
                    self.viewState = .failure(Constants.noImageMessage)
                    return
                }

                self.iconSaver.writeToPhotoAlbum(image: image) { saved, error in
                    if let error {
                        self.viewState = .failure(error.localizedDescription)
                        return
                    }
                    if saved {
                        self.viewState = .success(Constants.successMessage)
                    }
                }
            }
        }
    }
    
}

//MARK: - Local Constants
extension MainViewModel {
    struct Constants {
        static let successMessage = "Image saved"
        static let noImageMessage = "No image"
    }
}
