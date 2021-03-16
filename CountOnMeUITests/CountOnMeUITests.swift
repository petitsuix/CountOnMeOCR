//
//  CountOnMeUITests.swift
//  CountOnMeUITests
//
//  Created by Richardier on 15/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest

class CountOnMeUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumbersAndACButtons() throws {
        // UI tests must launch the application that they test.
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["0"].tap()
        app.buttons["AC"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let textView = app.textViews.firstMatch
        XCTAssertEqual(textView.value as? String, "") // .value is "any", must specify it's a String
    }
    
    func testAllSymbolButtons() throws {
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["-"].tap()
        app.buttons["1"].tap()
        app.buttons["×"].tap()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["÷"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        
        let textView = app.textViews.firstMatch
        XCTAssertEqual(textView.value as? String, "3 + 2 - 1 × 2 + 4 ÷ 2 = 5")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
