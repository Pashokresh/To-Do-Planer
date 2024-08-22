//
//  TaskItem+CoreDataProperties.swift
//  ToDoPlaner
//
//  Created by Pavel Martynenkov on 22.08.24.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var statusRawValue: Int16
    @NSManaged public var comment: String?
    @NSManaged public var dateCreated: Date?

}

extension TaskItem : Identifiable {
}
