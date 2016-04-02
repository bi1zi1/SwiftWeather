//
//  WeatherService.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/2/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import Foundation

struct WeatherServiceConst {
    static var WEATHER_API_KEY = "c3fd1c8f010fcf787e23c2215af49a95"
    static var WEATHER_API_URL = "http://api.openweathermap.org/data/2.5/weather?units=metric&APPID=" + WEATHER_API_KEY + "&q="
}

class WeatherService {
    func weatherForCity(cityName: String, completionClosure:(City)->()) {
        let city = City()
        city.name = cityName
        
        let weatherRequestString = (WeatherServiceConst.WEATHER_API_URL + cityName) as NSString
        let weatherApiUrl = NSURL(string: weatherRequestString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String)
        let task = NSURLSession.sharedSession().dataTaskWithURL(weatherApiUrl!) {
            (data, response, error) in
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    NSLog("Not a dictionary")
                    return
                }
                
                if let main = JSONDictionary["main"] as? NSDictionary {
                    if let temp = main["temp"] as? Double {
                        city.temp = Temperature(degrees: temp, scale: .celsius)
                    }
                    if let humidity = main["humidity"] as? Double {
                        city.humidity = humidity
                    }
                }
                
                if let weather = JSONDictionary["weather"] as? NSArray {
                    if let description = weather[0]["description"] as? String {
                        city.weatherDescription = description
                    }
                }
                
                if let name = JSONDictionary["name"] as? String {
                    city.name = name;
                }
                completionClosure(city)
            }
            catch let JSONError as NSError {
                NSLog("%@",JSONError)
                return
            }
        }
        task.resume()
    }
    
}
