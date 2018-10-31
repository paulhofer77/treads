//
//  Extensions.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation

extension Double {
    
    func metersToMiles(decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
    
    func setDicimalPlaces(decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return (self * divisor).rounded() / divisor
    }
    
    func meterToKm(decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return ((self / 1000) * divisor).rounded() / divisor
    }
   
    
}




