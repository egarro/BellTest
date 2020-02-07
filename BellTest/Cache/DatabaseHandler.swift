//
//  DatabaseHandler.swift
//  BellTest
//
//  Created by Esteban on 2020-02-05.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {
    lazy var moc: NSManagedObjectContext! = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func addRecord<T: NSManagedObject>(_ type: T.Type) -> T {
        let entityName = String(describing: T.self)
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: moc)
        let record = T(entity: entity!, insertInto: moc)
        return record
    }

    func query<T: NSManagedObject>(_ type: T.Type, search: NSPredicate?) -> [T] {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        if let predicate = search {
            request.predicate = predicate
        }

        do {
            let results = try moc.fetch(request)
            return results
        }
        catch {
            print("Error runing query with request: \(error)")
            return []
        }
    }
    
    func deleteRecord(_ object: NSManagedObject) {
        moc.delete(object)
    }

    func deleteAllRecords<T: NSManagedObject>(_ type: T.Type, search: NSPredicate? = nil) {
        let results = query(T.self, search: search)
        for record in results {
            moc.delete(record)
        }
    }

    func saveDatabase() {
        do {
            try moc.save()
        } catch {
            print("Error saving database: \(error)")
        }
    }
}
