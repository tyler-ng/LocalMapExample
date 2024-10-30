//
//  NotesTable.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import Foundation
import SQLite

class NotesTable {
    static let shared = NotesTable(db: DatabaseManager.shared.getDb())
    
    private var db: Connection
    
    private let noteTable = Table("Notes")
    private let noteId = Expression<Int>("noteId")
    private let noteTitle = Expression<String>("noteTitle")
    private let noteCompleted = Expression<Int>("noteCompleted") // 0 : not completed, 1 : Completed
    
    init(db: Connection) {
        self.db = db
        let createdQuery = noteTable.create(ifNotExists: true) { table in
            table.column(noteId, primaryKey: PrimaryKey.autoincrement)
            table.column(noteTitle, defaultValue: "")
            table.column(noteCompleted, defaultValue: 0)
        }
        try! self.db.run(createdQuery)
    }
    
    func insert(note: Notes) async -> Int64 {
        do {
            let insert = noteTable.insert(
                self.noteTitle <- note.noteTitle,
                self.noteCompleted <- note.noteCompleted
            )
            let noteId = try self.db.run(insert)
            return noteId
        } catch {
            print(error)
        }
        return 0
    }
    
    func update(note: Notes) async -> Int64 {
        do {
            let updatedItem = noteTable.filter(noteId == note.noteId)
            
            let update = updatedItem.update(
                self.noteTitle <- note.noteTitle,
                self.noteCompleted <- note.noteCompleted
            )
            let noteId = try self.db.run(update)
            return Int64(noteId)
        } catch {
            print(error)
        }
        return 0
    }
    
    func getAllNotes() async -> [Notes] {
        
        var notesList = [Notes]()
        
        guard let dbQuery = try? self.db.prepare(noteTable) else {
            return notesList
        }
        
        for item in dbQuery {
            notesList.append(Notes(noteId: item[noteId], noteTitle: item[noteTitle], noteCompleted: item[noteCompleted]))
        }
        
        return notesList
    }
    
    func getAllCompetedNotes() async -> [Notes] {
        
        var noteList = [Notes]()
        
        for item in try! self.db.prepare(noteTable.filter(noteCompleted == 1)) {
            
            noteList.append(Notes(noteId: item[noteId], noteTitle: item[noteTitle], noteCompleted: item[noteCompleted]))
        }
        
        return noteList
    }
}
