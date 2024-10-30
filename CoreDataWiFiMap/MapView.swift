//
//  MapView.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-30.
//

import SwiftUI
import MapKit
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    var annotations: [PlaceAnnotation] = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.region = mapView.region
            
            // remove annotations that are not in the visible region
            let visibleMapRect = mapView.visibleMapRect
            let annotationsToRemove = mapView.annotations.filter { annotation in
                let annotationPoint = MKMapPoint(annotation.coordinate)
                return !visibleMapRect.contains(annotationPoint)
            }
            
            mapView.removeAnnotations(annotationsToRemove)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is PlaceAnnotation {
                let identifier = "PlaceAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                return annotationView
            }
            return nil
        }
    }
}

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

//#Preview {
//    MapView()
//}
