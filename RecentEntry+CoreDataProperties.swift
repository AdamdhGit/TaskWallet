//
//  RecentEntry+CoreDataProperties.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/10/25.
//
//

import Foundation
import CoreData


extension RecentEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentEntry> {
        return NSFetchRequest<RecentEntry>(entityName: "RecentEntry")
    }

    @NSManaged public var creditsReceived: Int64
    @NSManaged public var dateSaved: Date?
    @NSManaged public var origin: UserTask?

}

extension RecentEntry : Identifiable {

}
