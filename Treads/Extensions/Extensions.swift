//
//  Extensions.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation

//MARK: - Extension for Doubles
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

//MARK: - Extension for Int
extension Int {
    
    func formatTimeDurationToString () -> String {
        
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        }else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
        
    }
    
    
}


