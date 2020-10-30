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
        app.navigationBars.buttons["Add"].tap()
        app.alerts.element.buttons["キャンセル"].tap()

        // Todoを追加する
        let random = Int.random(in: 0..<10000)
        app.navigationBars.buttons["Add"].tap()
        app.alerts.element.textFields["Title"].tap()
        app.alerts.element.textFields["Title"].typeText("タイトル\(random)")
        app.alerts.element.textFields["LocationInfo"].tap()
        app.alerts.element.textFields["LocationInfo"].typeText("場所")
        app.alerts.element.buttons["登録"].tap()
        XCTAssertEqual(app.cells.element(boundBy: 0).staticTexts["Title"].label, "タイトル\(random)")

        // Todoを完了する
        XCTAssertEqual(
            app.cells.element(boundBy: 0).otherElements["CheckBox"].label,
            "Unchecked"
        )
        app.cells.element(boundBy: 0).otherElements["CheckBox"].tap()
        XCTAssertEqual(
            app.cells.element(boundBy: 0).otherElements["CheckBox"].label,
            "Checked"
        )
    }

    func test_メッセージでTodoのログを記録できる() {
        let app = XCUIApplication()

        // メッセージ追加のテストに使うTodoを追加する
        app.navigationBars.buttons["Add"].tap()
        app.alerts.element.textFields["Title"].tap()
        app.alerts.element.textFields["Title"].typeText("メッセージテスト")
        app.alerts.element.textFields["LocationInfo"].tap()
        app.alerts.element.textFields["LocationInfo"].typeText("テスト")
        app.alerts.element.buttons["登録"].tap()
        app.cells.element(boundBy: 0).tap()

        // メッセージを送信する
        app.textViews["ChatInput"].tap()
        app.textViews["ChatInput"].typeText("これは1つ目のテストメッセージです")
        app.buttons["SendButton"].tap()

        // 送信後にテキストフィールドが空になっているか確認する
        XCTAssertEqual(app.textViews["ChatInput"].label, "")

        app.textViews["ChatInput"].tap()
        app.textViews["ChatInput"].typeText("これは2つ目のテストメッセージです")
        app.buttons["SendButton"].tap()

        XCTAssertEqual(
            app.collectionViews.cells.element(boundBy: 0).staticTexts.firstMatch.label,
            "これは1つ目のテストメッセージです"
        )
        XCTAssertEqual(
            app.collectionViews.cells.element(boundBy: 1).staticTexts.firstMatch.label,
            "これは2つ目のテストメッセージです"
        )

        // 画面を開き直してもデータが消えないことを確認する
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.cells.element(boundBy: 0).tap()
        XCTAssertEqual(
            app.collectionViews.cells.element(boundBy: 0).staticTexts.firstMatch.label,
            "これは1つ目のテストメッセージです"
        )
        XCTAssertEqual(
            app.collectionViews.cells.element(boundBy: 1).staticTexts.firstMatch.label,
            "これは2つ目のテストメッセージです"
        )

    }
}
