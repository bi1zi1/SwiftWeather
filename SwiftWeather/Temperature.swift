//
//  Temperature.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import Foundation

enum TemperatureScale {
    case celsius
    case fahrenheit
}

class Temperature : NSObject, NSCoding {
    var celsius: Double = 0.0
    var fahrenheit: Double {
        set(newValue) {
            self.celsius =  (newValue - 32) / 1.8
        }
        get {
            return (self.celsius * 1.8) + 32
        }
    }
    
    init(degrees: Double, scale: TemperatureScale) {
        switch scale {
            case .celsius:
                celsius = degrees
            case .fahrenheit:
                celsius = (degrees - 32) / 1.8
        }
    }
    
    //MARK: - Coder
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(celsius, forKey:"celsius")
    }
    
    required init (coder aDecoder: NSCoder) {
        if let celsius = aDecoder.decodeObjectForKey("celsius") as? Double {
            self.celsius = celsius
        } else {
            self.celsius = 0.0
        }
    }
    
    override init (){}
    
    //MARK: - Private Methods
    
    private func convertBetweenCF(degrees: Double, from: TemperatureScale) -> Double {
        var convertedValue = degrees
        switch from {
            case .celsius:
                convertedValue = (degrees * 1.8) + 32
            case .fahrenheit:
                convertedValue = (degrees - 32) / 1.8
        }
        return convertedValue
    }
    
}