//
//  File.swift
//  ToDoPlanerTests
//
//  Created by Pavel Martynenkov on 26.08.24.
//

import Foundation
@testable import ToDoPlaner

class TestConstants {
    static let someId = UUID()
    static let someName = "Some name"
    static let someFinishDate = Date.init(timeIntervalSinceNow: 5230945)
    static let somePendingStatus = TaskItem.Status.pending
    static let someComment = "Some Task Comment"
}
