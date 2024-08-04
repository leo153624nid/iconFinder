//
//  MainViewModelTest.swift
//  iconFinderTests
//
//  Created by A Ch on 03.08.2024.
//

import XCTest
@testable import iconFinder

final class MainViewModelTest: XCTestCase {
    private var viewModel: MainViewModel!

    override func setUpWithError() throws {
        viewModel = MainViewModel(iconService: FindIconServiceMock(), iconSaver: ImageSaverMock())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testPerform() throws {
        // Action "find", success
        viewModel.searchText = "find1"
        viewModel.perform(.find)
        XCTAssertEqual(viewModel.viewState, MainViewState.success(nil))
        XCTAssertEqual(viewModel.items.count, 1)
        viewModel.items = []
        viewModel.viewState = .initial
        
        // Action "find", failure
        viewModel.searchText = "find2"
        viewModel.perform(.find)
        XCTAssertEqual(viewModel.viewState,
                       MainViewState.failure("The operation couldn’t be completed. (iconFinder.NetworkError error 4.)\n\nbadResponse"))
        XCTAssertEqual(viewModel.items.count, 0)
        viewModel.items = []
        viewModel.viewState = .initial
        
        // Action "downLoadImage", failure - network error
        let item1 = MainTableViewCellData(iconPreview: "",
                                         iconDownload: "iconDownload1",
                                         name: "",
                                         description: "")
        viewModel.perform(.downLoadImage(item1))
        XCTAssertEqual(viewModel.viewState,
                       MainViewState.failure("The operation couldn’t be completed. (iconFinder.NetworkError error 4.)"))
        viewModel.viewState = .initial
        
        // Action "downLoadImage", failure - no data
        let item2 = MainTableViewCellData(iconPreview: "",
                                         iconDownload: "iconDownload2",
                                         name: "",
                                         description: "")
        viewModel.perform(.downLoadImage(item2))
        XCTAssertEqual(viewModel.viewState,
                       MainViewState.failure(MainViewModel.Constants.noImageMessage))
        viewModel.viewState = .initial
        
        // Action "downLoadImage", failure - saving error
        let item3 = MainTableViewCellData(iconPreview: "",
                                         iconDownload: "iconDownload3",
                                         name: "",
                                         description: "")
        viewModel.perform(.downLoadImage(item3))
        XCTAssertEqual(viewModel.viewState,
                       MainViewState.failure("The operation couldn’t be completed. (iconFinder.NetworkError error 6.)"))
        viewModel.viewState = .initial
        
        // Action "downLoadImage", success
        let item4 = MainTableViewCellData(iconPreview: "",
                                         iconDownload: "iconDownload4",
                                         name: "",
                                         description: "")
        viewModel.perform(.downLoadImage(item4))
        XCTAssertEqual(viewModel.viewState,
                       MainViewState.success(MainViewModel.Constants.successMessage))
        viewModel.viewState = .initial
    }
}

fileprivate final class FindIconServiceMock: FindIconService {
    func fetchIconItems(query: String, 
                        completion: @escaping (Result<iconFinder.IconsData, iconFinder.NetworkError>) -> Void) {
        if query == "find1" {
            let iconItem = IconItem(iconID: 0, tags: [], rasterSizes: [])
            completion(.success(IconsData(totalCount: 1, icons: [iconItem])))
            return
        }
        if query == "find2" {
            completion(.failure(.badResponse))
            return
        }
    }
    
    func downloadImage(from item: iconFinder.MainTableViewCellData, 
                       completion: @escaping (Data?, (any Error)?) -> Void) {
        if item.iconDownload == "iconDownload1" {
            completion(nil, NetworkError.badResponse)
            return
        }
        if item.iconDownload == "iconDownload2" {
            completion(nil, nil)
            return
        }
        if item.iconDownload == "iconDownload3" {
            let image = UIImage(named: Constants.UI.placeholderImage)
            completion(image?.pngData(), nil)
            return
        }
        if item.iconDownload == "iconDownload4" {
            let image = UIImage(named: Constants.UI.testIcon)
            completion(image?.pngData(), nil)
            return
        }
    }
}

fileprivate final class ImageSaverMock: ImageSaver {
    func writeToPhotoAlbum(image: UIImage, handler: @escaping (Bool, (any Error)?) -> Void) {
        if image.size == CGSize(width: 50, height: 50) {
            handler(false, NetworkError.unknown)
            return
        }
        if image.size == CGSize(width: 100, height: 100) {
            handler(true, nil)
            return
        }
    }
}
