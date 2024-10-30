//
//  MapPlaceEntity+CoreDataProperties.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-26.
//
//

import Foundation
import CoreData


extension MapPlaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPlaceEntity> {
        return NSFetchRequest<MapPlaceEntity>(entityName: "MapPlaceEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}

extension MapPlaceEntity : Identifiable {

}
