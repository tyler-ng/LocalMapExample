//
//  FirstMapView.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-26.
//

import SwiftUI
import MapKit

struct FirstMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.220776, longitude: -123.046978), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var annotations = [MapPlace]()
    private var placesTable = PlacesTable.shared
    @State var topLeftCorner: CLLocationCoordinate2D?
    @State var topRightCorner: CLLocationCoordinate2D?
    @State var bottomLeftCorner: CLLocationCoordinate2D?
    @State var bottomRightCorner: CLLocationCoordinate2D?
    
    var body: some View {
        ZStack {
            
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapMarker(coordinate: $0.coordinate)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            

        }
        .task {
//            let place = await placesTable.findPlaceBy(presetMinerId: "205877.0")
//            print(place)
//            let places = await placesTable.findNearestPlacesFrom(lat: 49.220776, long: -123.046978)
//            print(places)
//            self.annotations = Array(places.prefix(300))
        }
    }
}

#Preview {
    FirstMapView()
}
