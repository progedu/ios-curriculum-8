//
//  Todo.swift
//  TodoLog
//
//  Created by Kouki Saito on 1/13/20.
//  Copyright © 2020 Kouki Saito. All rights reserved.
//

import Foundation

struct Todo {
    let title: String
    let createdAt: Date
    let locationInfo: String
    let done: Bool

    var caption: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.calendar?.locale = Locale(identifier: "ja_JP")

        let date = "\(formatter.string(from: createdAt, to: Date())!)前"
        return "\(date)・\(locationInfo)"
    }
}
