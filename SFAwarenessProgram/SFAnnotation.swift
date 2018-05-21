//
//  SFAnnotation.swift
//  SFAwarenessProgram
//
//  Created by Ahyathreah Effi-yah on 3/3/16.
//  Copyright © 2016 TrhUArrayLUV. All rights reserved.
//

import Foundation
import MapKit

enum AnnotationType {
    case DistrictCenter
    case Incident
}

class SFAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color: UIColor?
    var annotationType: AnnotationType?
    
    init(coordinate: CLLocationCoordinate2D, district: String, incidentCount: Int, color: UIColor, type: AnnotationType) {
        self.coordinate = coordinate
        self.title = district
        subtitle = "\(incidentCount) incidents"
        self.color = color
        annotationType = type
    }
}
