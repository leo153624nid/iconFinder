//
//  IconItemConverterTest.swift
//  iconFinderTests
//
//  Created by A Ch on 03.08.2024.
//

import XCTest
@testable import iconFinder

final class IconItemConverterTest: XCTestCase {
    private let converter = IconItemConverter()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMap() throws {
        // is Empty
        let items1 = [IconItem]()
        let result1 = converter.map(items: items1)
        XCTAssertEqual(items1.count, result1.count)
        
        // tags, rasterSizes are Empty
        let items2 = [
            IconItem(iconID: 0, tags: [], rasterSizes: []),
        ]
        let result2 = converter.map(items: items2)
        XCTAssertEqual(items2.count, result2.count)
        XCTAssertEqual(result2[0].name, "No correct dimensions")
        XCTAssertEqual(result2[0].description, "")
        
        // tags, rasterSizes are not Empty
        let items3 = [
            IconItem(
                iconID: 0,
                tags: ["tag1", "tag2"],
                rasterSizes: [
                    RasterSize(
                        formats: [
                            .init(format: .png, previewURL: "previewURL", downloadURL: "downloadURL")
                        ],
                        size: 12,
                        sizeWidth: 12,
                        sizeHeight: 12
                    )
                ]
            ),
        ]
        let result3 = converter.map(items: items3)
        XCTAssertEqual(items3.count, result3.count)
        XCTAssertEqual(result3[0].name, "12 x 12")
        XCTAssertEqual(result3[0].description, "tag1, tag2")
        XCTAssertEqual(result3[0].iconPreview, "previewURL")
        XCTAssertEqual(result3[0].iconDownload, "downloadURL")
    }

}
