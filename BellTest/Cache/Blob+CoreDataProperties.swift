//
//  Blob+CoreDataProperties.swift
//  
//
//  Created by Esteban on 2020-02-06.
//
//

import Foundation
import CoreData


extension Blob {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Blob> {
        return NSFetchRequest<Blob>(entityName: "Blob")
    }

    @NSManaged public var data: Data?

}
