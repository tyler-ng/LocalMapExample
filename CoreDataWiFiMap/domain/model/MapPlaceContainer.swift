//
//  MapPlaceContainer.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import Foundation
import MapKit

struct MapPlaceContainer: Codable {
    let data: [MapPlace]
}

struct MapPlace: Codable, Identifiable {
    let id: String
    let latitude: String
    let longitude: String
}

extension MapPlace {
    var minerIdDoule: Double {
        return Double(id) ?? 0
    }
    
    var latDouble: Double {
        return Double(latitude) ?? 0
    }
    
    var logDouble: Double {
        return Double(longitude) ?? 0
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latDouble, longitude: logDouble)
    }
}
