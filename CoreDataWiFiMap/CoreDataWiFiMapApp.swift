//
//  CoreDataWiFiMapApp.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-24.
//

import SwiftUI

@main
struct CoreDataWiFiMapApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
