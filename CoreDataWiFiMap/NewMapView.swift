//
//  NewMapView.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-30.
//

import SwiftUI
import MapKit
import CoreLocation

struct NewMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.220776, longitude: -123.046978),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    @State var topLeftCornerCoordinate: CLLocationCoordinate2D?
    @State var topRightCornerCoordinate: CLLocationCoordinate2D?
    @State var bottomLeftCornerCoordinate: CLLocationCoordinate2D?
    @State var bottomRightCornerCoordinate: CLLocationCoordinate2D?
    @State var annnotations = [PlaceAnnotation]()
    private var placesTable = PlacesTable.shared
    
    var body: some View {
        VStack {
            MapView(region: $region, annotations: annnotations)
                .ignoresSafeArea(edges: .all)
                .onChange(of: region.center.latitude) { _ in
                    updateTopLeftCornerCoordinate()
                    updateTopRightCornerCoordinate()
                    updateBottomLeftCornerCoordinate()
                    updateBottomRightCornerCoordinate()
                    findPlacesWithinCurrentMapRegion()
                }
        }
        
    }
    
    private func updateTopLeftCornerCoordinate() {
        let northLat = region.center.latitude + (region.span.latitudeDelta / 2)
        let westLong = region.center.longitude - (region.span.longitudeDelta / 2)
        
        topLeftCornerCoordinate = CLLocationCoordinate2D(latitude: northLat, longitude: westLong)
        print("topLeft: \(northLat), \(westLong)")
    }
    
    private func updateTopRightCornerCoordinate() {
        let northLat = region.center.latitude + (region.span.latitudeDelta / 2)
        let westLong = region.center.longitude + (region.span.longitudeDelta / 2)
        
        topRightCornerCoordinate = CLLocationCoordinate2D(latitude: northLat, longitude: westLong)
        print("topRight: \(northLat), \(westLong)")
    }
    
    private func updateBottomLeftCornerCoordinate() {
        let northLat = region.center.latitude - (region.span.latitudeDelta / 2)
        let westLong = region.center.longitude - (region.span.longitudeDelta / 2)
        
        bottomLeftCornerCoordinate = CLLocationCoordinate2D(latitude: northLat, longitude: westLong)
        print("bottomLeft: \(northLat), \(westLong)")
    }
    
    private func updateBottomRightCornerCoordinate() {
        let northLat = region.center.latitude - (region.span.latitudeDelta / 2)
        let westLong = region.center.longitude + (region.span.longitudeDelta / 2)
        
        bottomRightCornerCoordinate = CLLocationCoordinate2D(latitude: northLat, longitude: westLong)
        print("bottomRight: \(northLat), \(westLong)")
    }
    
    private func findPlacesWithinCurrentMapRegion() {
        Task {
            guard let topLeftCoor = topLeftCornerCoordinate,
                  let topRightCoor = topRightCornerCoordinate,
                  let bottomLeftCoor = bottomLeftCornerCoordinate,
                  let bottomRightCoor = bottomRightCornerCoordinate else {
                return
            }
            var places = await placesTable.findNearestPlacesAroundMyHome(
                topLeftCoordinate: topLeftCoor,
                topRightCoordinate: topRightCoor,
                bottomLeftCoordinate: bottomLeftCoor,
                bottomRightCoordinate: bottomRightCoor)
            print("mapPlaces total: \(places.count)")
            guard !places.isEmpty else {
                print("Error: Places is empty list")
                return
            }
            
//            let center = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
//            places = places.sorted { (place1, place2) in
//                return place1.location.distance(from: center) < place2.location.distance(from: center)
//            }
            
            if places.count >= 1000 {
                places = Array(places.prefix(1000))
            }
            
            var anns = [PlaceAnnotation]()
            places.forEach({
                anns.append(PlaceAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.latDouble, longitude: $0.logDouble)))
            })
            self.annnotations = anns
        }
    }
}

#Preview {
    NewMapView()
}
