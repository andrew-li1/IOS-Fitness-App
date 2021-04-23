//
//  CustomAnnotation.swift
//  Fitness
//
//  Created by Jiacheng Li on 4/22/21.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let coordinateType: CoordinateType
    
    init(coordinateType: CoordinateType, coordinate: CLLocationCoordinate2D) {
        self.coordinateType = coordinateType
        self.title = coordinateType == .start ? "Starting Point" : "Ending Point"
        self.subtitle = coordinateType == .start ? "This is where you started" : "This is where you ended"
        self.coordinate = coordinate
    }
}

enum CoordinateType {
    case start
    case end
}
