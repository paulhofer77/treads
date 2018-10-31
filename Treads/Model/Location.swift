//
//  Location.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    
    @objc dynamic public private(set) var latitude: Double = 0.0
    @objc dynamic public private(set) var longitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude

    }
    
    
    
}
