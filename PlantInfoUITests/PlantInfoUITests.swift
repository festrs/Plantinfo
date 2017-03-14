//
//  PlantInfoUITests.swift
//  PlantInfoUITests
//
//  Created by Felipe Dias Pereira on 2016-09-12.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

import XCTest

class PlantInfoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScrennShotTaker() {
        let app = XCUIApplication()
        snapshot("01ListScreen")
        app.tabBars.buttons["New"].tap()
        app.collectionViews.childrenMatchingType(.Cell).matchingIdentifier("Photo").elementBoundByIndex(0).tap()
        app.buttons["Done"].tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        app.buttons["Photos"].tap()
        snapshot("02PhotosScreen")
        app.buttons["Info"].tap()
        snapshot("03PlantInfoScreen")
        app.buttons["Save"].tap()
    }
    
}
