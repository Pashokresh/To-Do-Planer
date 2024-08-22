//
//  Utils.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//

import Foundation

extension Date {
    /// Returns localized String from the date
    func localized() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
