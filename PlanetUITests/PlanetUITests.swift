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
    
        //navigate app
        let app = XCUIApplication()
        app.tabBars.childrenMatchingType(.Button).elementBoundByIndex(4).tap()
        
        XCTAssert(app.staticTexts["numberOfClasses"].exists)
        
        let classes = app.staticTexts["numberOfClasses"]
        let exists = NSPredicate(format: "exists == true")
        expectationForPredicate(exists, evaluatedWithObject: classes, handler: nil)
        
        app.tabBars.childrenMatchingType(.Button).elementBoundByIndex(4).tap()
        
        let numberofclassesStaticText = app.staticTexts["numberOfClasses"]
        numberofclassesStaticText.tap()
        app.buttons["Add Class"].tap()
         
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.TextField).element.typeText("eeesseerae")
        app.buttons["Create Class"].tap()
        
        waitForExpectationsWithTimeout(3, handler: nil)
        XCTAssert(classes.exists)

    }
    
}
