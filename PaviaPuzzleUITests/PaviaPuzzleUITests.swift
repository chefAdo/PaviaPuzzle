//
//  PaviaPuzzleUITests.swift
//  PaviaPuzzleUITests
//
//  Created by Adahan on 17/12/24.
//

import XCTest

final class PaviaPuzzleUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testGameSelectViewButtons() {
        XCTAssertTrue(app.buttons["funambolPuzzleButton"].exists)
        XCTAssertTrue(app.buttons["customGameButton"].exists)
        app.buttons["funambolPuzzleButton"].tap()
        XCTAssertTrue(app.activityIndicators["LoadingIndicator"].exists)
    }

    func testCustomGameViewButtons() {
        app.buttons["customGameButton"].tap()
        
        XCTAssertTrue(app.buttons["blitzButton"].exists)
        XCTAssertTrue(app.buttons["mediumButton"].exists)
        XCTAssertTrue(app.buttons["extremeButton"].exists)
        
        app.buttons["blitzButton"].tap()
        XCTAssertTrue(app.activityIndicators["LoadingIndicator"].exists)
    }
 
}
