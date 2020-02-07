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

protocol DataBaseHandler {
    func findPlaylists(with etag:String) -> Playlists?
    func findPlaylist(with etag:String) -> Playlist?
    func getValue(for etag:String) -> String?
    
    func createPlaylistsDBRecord(for record: Playlists, with tableId: String)
    func createPlaylistDBRecord(for record: Playlist, with tableId: String, withEtag: Bool)
    func updatePlaylistDBRecord(with newPlaylist: Playlist, for tableId: String)
}

class DatabaseHandlerImp: DataBaseHandler {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let dateHelper = DateHelper(downloadIntervalSpam: 60, dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    
    lazy var moc: NSManagedObjectContext! = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func findPlaylists(with etag:String) -> Playlists? {
        let predicate = NSPredicate(format: "key == %@", etag)
        if let obj = query(ETag.self, search: predicate).first,
           let data = obj.relationship?.data,
            let playlists = try? decoder.decode(Playlists.self, from: data) {
            return playlists
        }
        return nil
    }

    func findPlaylist(with etag:String) -> Playlist? {
        let predicate = NSPredicate(format: "key == %@", etag)
        if let obj = query(ETag.self, search: predicate).first,
           let data = obj.relationship?.data,
           let playlist = try? decoder.decode(Playlist.self, from: data) {
            return playlist
        }
        return nil
    }
    
    func getValue(for etag:String) -> String? {
        let predicate = NSPredicate(format: "key == %@", etag)
        if let obj = query(ETag.self, search: predicate).first {
            return obj.headerValue
        }
        return nil
    }
    
    func createPlaylistsDBRecord(for record: Playlists, with tableId: String) {
        let data = try? encoder.encode(record)
        let blob = addRecord(Blob.self)
        blob.data = data
        let new = addRecord(ETag.self)
        new.key = tableId
        new.headerValue = record.etag
        new.relationship = blob

        saveDatabase()
    }

    func createPlaylistDBRecord(for record: Playlist, with tableId: String, withEtag: Bool) {
        let data = try? encoder.encode(record)
        let blob = addRecord(Blob.self)
        blob.data = data
        let new = addRecord(ETag.self)
        new.key = tableId
        new.headerValue = withEtag ? record.etag : dateHelper.dateString()
        new.relationship = blob

        saveDatabase()
    }

    func updatePlaylistDBRecord(with newPlaylist: Playlist, for tableId: String) {
        let predicate = NSPredicate(format: "key == %@", tableId)
        if let obj = query(ETag.self, search: predicate).first,
            let oldBlob = obj.relationship {
                let newData = try? encoder.encode(newPlaylist)
                obj.headerValue = dateHelper.dateString()
                oldBlob.data = newData
            
                saveDatabase()
        }
    }

    private func query<T: NSManagedObject>(_ type: T.Type, search: NSPredicate?) -> [T] {
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
    
    private func addRecord<T: NSManagedObject>(_ type: T.Type) -> T {
        let entityName = String(describing: T.self)
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: moc)
        let record = T(entity: entity!, insertInto: moc)
        return record
    }
    
    private func deleteRecord(_ object: NSManagedObject) {
        moc.delete(object)
    }

    private func deleteAllRecords<T: NSManagedObject>(_ type: T.Type, search: NSPredicate? = nil) {
        let results = query(T.self, search: search)
        for record in results {
            moc.delete(record)
        }
    }

    private func saveDatabase() {
        do {
            try moc.save()
        } catch {
            print("Error saving database: \(error)")
        }
    }
}
