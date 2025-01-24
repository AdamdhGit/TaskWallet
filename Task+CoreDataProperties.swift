//
//  Task+CoreDataProperties.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/7/25.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?

}

extension Task : Identifiable {

}
