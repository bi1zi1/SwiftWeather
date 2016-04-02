//
//  City.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import Foundation

struct CoderConst {
    static let kCoderName = "kCoderName"
    static let kCoderTemp = "kCoderTemp"
    static let kCoderHumidity = "kCoderHumidity"
    static let kCoderWeatherDescription = "kCoderWeatherDescription"
}

class City: NSObject, NSCoding {
    //MARK: - Properties
    
    var name: String!
    var temp: Temperature?
    var humidity: Double?
    var weatherDescription: String?
    
    //MARK: - Coder
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: CoderConst.kCoderName)
        aCoder.encodeObject(temp, forKey: CoderConst.kCoderTemp)
        aCoder.encodeObject(humidity, forKey: CoderConst.kCoderHumidity)
        aCoder.encodeObject(weatherDescription, forKey: CoderConst.kCoderWeatherDescription)
    }
    
    required init (coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectForKey(CoderConst.kCoderName) as? String {
            self.name = name
        } else {
            self.name = ""
        }
        if let temp = aDecoder.decodeObjectForKey(CoderConst.kCoderTemp) as? Temperature {
            self.temp = temp
        } else {
            self.temp = nil
        }
        if let humidity = aDecoder.decodeObjectForKey(CoderConst.kCoderHumidity) as? Double {
            self.humidity = humidity
        } else {
            self.humidity = nil
        }
        if let weatherDescription = aDecoder.decodeObjectForKey(CoderConst.kCoderWeatherDescription) as? String {
            self.weatherDescription = weatherDescription
        } else {
            self.weatherDescription = nil
        }
    }
    
    override init (){}
    
    override var description: String {
        get {
            return name
        }
    }
    
}