//
//  UserTask+CoreDataProperties.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/10/25.
//
//

import Foundation
import CoreData


extension UserTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTask> {
        return NSFetchRequest<UserTask>(entityName: "UserTask")
    }

    @NSManaged public var accumulationStyle: String?
    @NSManaged public var name: String?
    @NSManaged public var recentEntry: NSSet?

}

// MARK: Generated accessors for recentEntry
extension UserTask {

    @objc(addRecentEntryObject:)
    @NSManaged public func addToRecentEntry(_ value: RecentEntry)

    @objc(removeRecentEntryObject:)
    @NSManaged public func removeFromRecentEntry(_ value: RecentEntry)

    @objc(addRecentEntry:)
    @NSManaged public func addToRecentEntry(_ values: NSSet)

    @objc(removeRecentEntry:)
    @NSManaged public func removeFromRecentEntry(_ values: NSSet)

}

extension UserTask : Identifiable {

}
