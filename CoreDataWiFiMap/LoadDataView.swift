//
//  LoadDataView.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-26.
//

import SwiftUI

struct LoadDataView: View {
    
    @Environment(\.managedObjectContext)
    var context
    
    
    var body: some View {
        VStack {
            Button {
                DispatchQueue.global(qos: .userInitiated).async {
                    let entities = DataGenerator.createMapPlaceEntities(in: context)
                    entities.prefix(500).forEach({ element in
//                        context.insert(element)
                        try? context.save()
                    })
                    
                    print("DONE")
                }
            } label: {
                Text("Seed data")
            }

        }
    }
}

#Preview {
    LoadDataView()
}
