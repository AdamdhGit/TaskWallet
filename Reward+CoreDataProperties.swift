//
//  Reward+CoreDataProperties.swift
//  TaskWallet
//
//  Created by Adam Heidmann on 1/9/25.
//
//

import Foundation
import CoreData


extension Reward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reward> {
        return NSFetchRequest<Reward>(entityName: "Reward")
    }


}

extension Reward : Identifiable {

}
