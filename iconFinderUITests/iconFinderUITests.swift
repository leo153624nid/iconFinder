//
//  iconFinderUITests.swift
//  iconFinderUITests
//
//  Created by A Ch on 02.08.2024.
//

import XCTest

final class iconFinderUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testNoIconsFinded() throws {
        let app = XCUIApplication()
        app.launch()

        let searchtextField = app.textFields["Enter icon name..."]
        searchtextField.tap()
        searchtextField.typeText("Qqq")
        
        let searchButton = app.buttons["Find"]
        searchButton.tap()
        
        let noIconLabel = app.staticTexts["No icons"]
        XCTAssert(noIconLabel.waitForExistence(timeout: 3))
    }
    
    func testFindedArrowIcons() throws {
        let app = XCUIApplication()
        app.launch()

        let searchtextField = app.textFields["Enter icon name..."]
        searchtextField.tap()
        searchtextField.typeText("Arrow")
        
        let searchButton = app.buttons["Find"]
        searchButton.tap()
        
        let noIconLabel = app.staticTexts["No icons"]
        XCTAssertFalse(noIconLabel.waitForExistence(timeout: 3))
        
        let tableView = app.tables["mainTableView"]
        XCTAssert(tableView.waitForExistence(timeout: 3))
    }
    
    func testSavedArrowIcon() throws {
        let app = XCUIApplication()
        app.launch()

        let searchtextField = app.textFields["Enter icon name..."]
        searchtextField.tap()
        searchtextField.typeText("Arrow")
        
        let searchButton = app.buttons["Find"]
        searchButton.tap()
        
        let firstCell = app.tables["mainTableView"].cells.firstMatch
        firstCell.tap()
        
        let alert = app.alerts["Success"]
        XCTAssert(alert.waitForExistence(timeout: 3))
    }
}
