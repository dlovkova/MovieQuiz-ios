//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Daria Lovkova on 22.07.2023.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

   
    func testYesButton() {
        sleep(2)
        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.exists)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
       
        sleep(2)
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(secondPoster.exists)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    
    func testNoButton() {
        sleep(2)
        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.exists)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
       
        sleep(2)
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(secondPoster.exists)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    
    func testAlert() {
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)
        app.buttons["No"].tap()
        sleep(1)
        app.buttons["Yes"].tap()
        sleep(1)


        let alert = app.alerts["Alert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз!")
        
        
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}
