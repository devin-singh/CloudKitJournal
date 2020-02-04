//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Devin Singh on 2/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants{
    static let recordTypeKey = "Entry"
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
}

class Entry {
    
    let title: String
    let bodyText: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.titleKey] as? String, let body = ckRecord[EntryConstants.bodyKey] as? String, let timestamp = ckRecord[EntryConstants.timestampKey] as? Date else { return nil }
        self.init(title: title, bodyText: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordTypeKey)
        
        self.setValuesForKeys([
            EntryConstants.bodyKey : entry.bodyText,
            EntryConstants.titleKey: entry.title,
            EntryConstants.timestampKey : entry.timestamp
        ])
    }
}


