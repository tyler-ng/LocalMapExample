//
//  Note.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import Foundation

struct Notes: Identifiable, Hashable {
    var id = UUID()
    
    var noteId: Int = 0
    var noteTitle: String = ""
    var noteCompleted: Int = 0
}
