//
//  TodoLogTests.swift
//  TodoLogTests
//
//  Created by Kouki Saito on 2019/06/17.
//  Copyright © 2019 Kouki Saito. All rights reserved.
//

import XCTest
@testable import TodoLog

class TodoLogTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Todoのcaptionは時刻と場所を表示できる() {
        let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!

        let todo = Todo(context: context)
        todo.createdAt = Date() - 10
        todo.locationInfo = "東京駅"
        XCTAssertEqual(todo.caption, "10秒前・東京駅")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
