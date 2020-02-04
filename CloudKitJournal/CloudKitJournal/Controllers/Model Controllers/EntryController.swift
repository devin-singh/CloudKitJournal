//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Devin Singh on 2/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let shared = EntryController()
    
    var entries: [Entry] = []
    
    // MARK: - CRUD
    
    func save(entry: Entry, completion: @escaping (Bool) -> ()) {
        let ckRecord = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(ckRecord) { (record, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(false)
            }
            
            guard let record = record else { print("Error UW"); return completion (false) }
            
            guard let entryToAppend = Entry(ckRecord: record) else { print("Error UW"); return completion(false) }
            
            self.entries.append(entryToAppend)
            completion(true)
        }
    }
    
    func addEntryWith(title: String, body: String, completion: @escaping (Bool) -> Void) {
        let newEntry = Entry(title: title, bodyText: body)
        
        save(entry: newEntry) { (result) in
            if result {
                return completion(true)
            }else{
                return completion(false)
            }
        }
    }
    
    func fetchAllEntries(completion: @escaping (Bool) -> ()) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(false)
            }
            
            guard let records = records else { print("Error UW"); return completion(false)}
            
            let entries = records.compactMap( { Entry(ckRecord: $0)} )
            
            self.entries = entries
            
            completion(true)
        }
    }
}
