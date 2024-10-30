//
//  DatabaseManager.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import Foundation
import SQLite

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let db: Connection
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        db = try! Connection("\(path)/NotesDatabase.db")
    }
    
    func getDb() -> Connection {
        return db
    }
}
