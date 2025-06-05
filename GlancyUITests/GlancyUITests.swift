//
//  GlancyUITests.swift
//  GlancyUITests
//
//  Created by 齐天乐 on 2025/3/27.
//

import XCTest

final class GlancyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSearchAddsHistory() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["请输入单词"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("hello")

        app.buttons["magnifyingglass"].firstMatch.tap()

        let historyLabel = app.staticTexts["hello"].firstMatch
        XCTAssertTrue(historyLabel.waitForExistence(timeout: 5))

        if #available(iOS 17.0, *) {
            XCTAssertNoThrow(try app.performAccessibilityAudit())
        }
    }

    @MainActor
    func testOpenLanguageSettings() throws {
        let app = XCUIApplication()
        app.launch()

        let gearButton = app.buttons["gear"].firstMatch
        XCTAssertTrue(gearButton.waitForExistence(timeout: 2))
        gearButton.tap()

        let settingsNav = app.navigationBars["语言偏好设置"].firstMatch
        XCTAssertTrue(settingsNav.waitForExistence(timeout: 2))
        settingsNav.buttons["保存"].tap()

        XCTAssertFalse(settingsNav.exists)
    }

    @MainActor
    func testOpenProfileSheet() throws {
        let app = XCUIApplication()
        app.launch()

        let profileButton = app.buttons["person.crop.circle"].firstMatch
        XCTAssertTrue(profileButton.waitForExistence(timeout: 2))
        profileButton.tap()

        XCTAssertTrue(app.staticTexts["登录"].waitForExistence(timeout: 2))
        app.buttons["关闭"].firstMatch.tap()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
