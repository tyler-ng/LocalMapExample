//
//  LoadMapSqliteData.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import SwiftUI

struct LoadMapSqliteData: View {
    
    private var placesTable = PlacesTable.shared
    @State var allPlaces = [MapPlace]()
    
    var body: some View {
        VStack {
            Button {
                Task {
                    let mapPlaces = DataGenerator.createMapPlaces()
                    mapPlaces.forEach({
                        let placeId = placesTable.insert(place: $0)
                        print(placeId)
                    })
                    print("DONE")
                }
            } label: {
                Text("Load Map Sqlite Data")
            }
            .padding()
            
            Button {
                Task {
                    let allPlaces = await placesTable.getAllPlaces()
                    self.allPlaces = allPlaces
                    print(allPlaces)
                }
            } label: {
                Text("Get all places")
            }
            .padding(.top, 50)
            
            Button {
                Task {
//                    let places = await placesTable.findPlaceBy(presetMinerId: "294655")
//                    let places = await placesTable.findNearestPlacesFrom(lat: 49.220776, long: -123.046978)
//                    print(places)
                }
            } label: {
                Text("Find minerId")
            }
            .padding()

            
            List {
                ForEach(allPlaces) { place in
                    HStack {
                        Text(place.id)
                        Text(place.latitude)
                        Text(place.longitude)
                    }
                }
            }
            .padding()

        }
    }
}

#Preview {
    LoadMapSqliteData()
}
