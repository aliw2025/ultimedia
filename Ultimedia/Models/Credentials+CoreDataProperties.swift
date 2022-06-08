//
//  Credentials+CoreDataProperties.swift
//  
//
//  Created by William Alexander on 4/29/22.
//
//

import Foundation
import CoreData


extension Credentials {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Credentials> {
        return NSFetchRequest<Credentials>(entityName: "Credentials")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var source: Source?

}
