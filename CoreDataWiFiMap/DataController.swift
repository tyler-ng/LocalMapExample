//
//  DataController.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-24.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MyDatabase")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
