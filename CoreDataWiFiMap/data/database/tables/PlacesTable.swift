//
//  PlacesTable.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import Foundation
import SQLite
import MapKit

class PlacesTable {
    static let shared = PlacesTable(db: DatabaseManager.shared.getDb())
    
    private var db: Connection
    
    private let placesTable = Table("Places")
    private let id = Expression<Int>("id")
    private let minerId = Expression<String>("minerId")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    
    init(db: Connection) {
        self.db = db
        let createdQuery = placesTable.create(ifNotExists: true) { table in
            table.column(id, primaryKey: PrimaryKey.autoincrement)
            table.column(minerId, defaultValue: "")
            table.column(latitude, defaultValue: 0)
            table.column(longitude, defaultValue: 0)
        }
        try! self.db.run(createdQuery)
    }
    
    func insert(place: MapPlace) -> Int64 {
        do {
            let insert = placesTable.insert(
                self.minerId <- place.id,
                self.latitude <- place.latDouble,
                self.longitude <- place.logDouble
            )
            let placeID = try self.db.run(insert)
            return placeID
        } catch {
            print(error)
        }
        return 0
    }
    
    func update(place: MapPlace) async -> Int64 {
        do {
            let updatedItem = placesTable.filter(minerId == place.id)
            
            let update = updatedItem.update(
                self.latitude <- place.latDouble,
                self.longitude <- place.logDouble
            )
            let placeId = try self.db.run(update)
            return Int64(placeId)
        } catch {
            print(error)
        }
        return 0
    }
    
    func getAllPlaces() async -> [MapPlace] {
        
        var placesList = [MapPlace]()
        
        guard let dbQuery = try? self.db.prepare(placesTable) else {
            return placesList
        }
        
        for item in dbQuery {
            let latSt = String(item[latitude])
            let logSt = String(item[longitude])
            placesList.append(MapPlace(id: item[minerId], latitude: latSt, longitude: logSt))
        }
        
        return Array(placesList.prefix(1000))
    }
    
    func findPlaceBy(presetMinerId: String) async -> MapPlace? {
        guard let dbQuery = try? self.db.prepare(placesTable.filter(minerId == presetMinerId)) else {
            return nil
        }
        
        var placesList = [MapPlace]()
        
        for item in dbQuery {
            let latSt = String(item[latitude])
            let logSt = String(item[longitude])
            placesList.append(MapPlace(id: item[minerId], latitude: latSt, longitude: logSt))
        }
        
        guard placesList.count > 0 else {
            return nil
        }
        
        return placesList.first!
    }
    
    func findPlace() async -> [MapPlace] {
        guard let dbQuery = try? self.db.prepare(placesTable.filter(minerId.like("41%"))) else {
            return []
        }
        
        var placesList = [MapPlace]()
        
        for item in dbQuery {
            let latSt = String(item[latitude])
            let logSt = String(item[longitude])
            placesList.append(MapPlace(id: item[minerId], latitude: latSt, longitude: logSt))
        }
        
        guard placesList.count > 0 else {
            return []
        }
        
        return placesList
    }
    
    func findNearestPlacesAroundMyHome(topLeftCoordinate: CLLocationCoordinate2D,
                               topRightCoordinate: CLLocationCoordinate2D,
                               bottomLeftCoordinate: CLLocationCoordinate2D,
                               bottomRightCoordinate: CLLocationCoordinate2D) async -> [MapPlace] {
        
        guard let dbQuery = try? self.db.prepare(placesTable.filter(latitude >= bottomLeftCoordinate.latitude && latitude <= topRightCoordinate.latitude && longitude >= topLeftCoordinate.longitude && longitude <= bottomRightCoordinate.longitude)) else {
            return []
        }
        
        var placesList = [MapPlace]()
        
        for item in dbQuery {
            let latSt = String(item[latitude])
            let logSt = String(item[longitude])
            placesList.append(MapPlace(id: item[minerId], latitude: latSt, longitude: logSt))
        }
        print("PlaceList Count: \(placesList.count)")
        return placesList
    }
}
