//
//  PlanetUITests.swift
//  PlanetUITests
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import XCTest

class PlanetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
  
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let button = tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(1)
        button.tap()
        
        let button2 = tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(4)
        button2.tap()
        button.tap()
        tabBarsQuery.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        app.buttons["Systems 2 "].tap()
        app.buttons["Quiz"].tap()
        app.buttons["Create Event"].tap()
        button2.tap()
        
    }
    
}
