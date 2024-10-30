//
//  RandomGenerator.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-24.
//

import Foundation
import MapKit
import CoreData

class DataGenerator {
    static func loadMapPlaces() -> [MapPlace] {
        guard let url = Bundle.main.url(forResource: "miner_info_filtered", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try? decoder.decode(MapPlaceContainer.self, from: data)
        return decoded?.data ?? []
    }
    
    static func createMapPlaceEntities(in context: NSManagedObjectContext) -> [MapPlaceEntity] {
        let mapPlaces = DataGenerator.loadMapPlaces()
        var mapPlaceEntities = [MapPlaceEntity]()
        mapPlaces.forEach({
            let mapPlaceEntity = MapPlaceEntity(context: context)
            mapPlaceEntity.latitude = $0.latitude
            mapPlaceEntity.longitude = $0.longitude
            mapPlaceEntities.append(mapPlaceEntity)
        })
        return mapPlaceEntities
    }
    
    
    static func createMapPlaces() -> [MapPlace] {
        let data = DataGenerator.loadMapPlaces()
        var mapPlaces = [MapPlace]()
        data.forEach({
            let mapPlace = MapPlace(id: $0.id, latitude: $0.latitude, longitude: $0.longitude)
            mapPlaces.append(mapPlace)
        })
        return mapPlaces
    }
}
