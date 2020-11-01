//
//  TodoLogUITests.swift
//  TodoLogUITests
//
//  Created by Kouki Saito on 2019/06/17.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import XCTest

class TodoLogUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_新しいTodoを追加して完了できる() {
        let app = XCUIApplication()
        // キャンセルできるかを確認
        app.navigationBars.buttons.firstMatch.tap()
        app.alerts.buttons["キャンセル"].tap()

        // Todoを追加する
        let random = Int.random(in: 0..<10000)
        app.navigationBars.buttons.firstMatch.tap()
        app.alerts.textFields["InputTitle"].tap()
        app.alerts.textFields["InputTitle"].typeText("タイトル\(random)")
        app.alerts.textFields["InputLocationInfo"].tap()
        app.alerts.textFields["InputLocationInfo"].typeText("場所")
        app.alerts.buttons["登録"].tap()
        XCTAssertEqual(app.cells.element(boundBy: 0).staticTexts["TodoTitle"].label, "タイトル\(random)")

        // Todoを完了する
        XCTAssertEqual(
            app.cells.element(boundBy: 0).otherElements["TodoCheckBox"].label,
            "Unchecked"
        )
        app.cells.element(boundBy: 0).otherElements["TodoCheckBox"].tap()
        XCTAssertEqual(
            app.cells.element(boundBy: 0).otherElements["TodoCheckBox"].label,
            "Checked"
        )
    }

}
