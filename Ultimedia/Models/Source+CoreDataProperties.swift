//
//  Source+CoreDataProperties.swift
//  
//
//  Created by William Alexander on 4/29/22.
//
//

import Foundation
import CoreData


extension Source {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Source> {
        return NSFetchRequest<Source>(entityName: "Source")
    }

    @NSManaged public var endpoint: String?
    @NSManaged public var name: String?
    @NSManaged public var port: Int32
    @NSManaged public var share: String?
    @NSManaged public var sourceType: Int32
    @NSManaged public var credentials: Credentials?

}
