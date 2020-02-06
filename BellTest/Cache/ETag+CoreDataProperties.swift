//
//  ETag+CoreDataProperties.swift
//  
//
//  Created by Esteban on 2020-02-06.
//
//

import Foundation
import CoreData


extension ETag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ETag> {
        return NSFetchRequest<ETag>(entityName: "ETag")
    }

    @NSManaged public var etag: String?
    @NSManaged public var relationship: Blob?

}
