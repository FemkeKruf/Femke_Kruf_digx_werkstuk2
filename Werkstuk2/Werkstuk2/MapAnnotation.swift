//
//  MapAnnotation.swift
//  Werkstuk2
//
//  Created by student on 03/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    var station = Station()
    
    override init() {
        coordinate = CLLocationCoordinate2D()
        title = ""
    }
    
    init (coordinate: CLLocationCoordinate2D, title: String)
    {
        self.coordinate = coordinate
        self.title = title
        
    }
}

