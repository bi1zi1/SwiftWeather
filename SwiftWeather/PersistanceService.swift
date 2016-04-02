//
//  PersistanceService.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import Foundation

struct PersistanceServiceConst {
    static var kDataChanged = "kDataChanged"
}

class PersistanceService {
    //# MARK: - Private Methods

    //Return the path to the db (storage) file
    private func dbPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path: AnyObject = paths[0]
        let dbFilePath = path.stringByAppendingPathComponent("db.plist")
        return dbFilePath
    }
    
    //# MARK: - Public Methods
    
    //Fetch all the saved cities
    func fetchCities() -> [City] {
        if let cities: [City] = NSKeyedUnarchiver.unarchiveObjectWithFile(dbPath()) as? [City] {
            return cities
        }
        return [City]()
    }
    
    func fetchCityDataForName(cityName: String) -> City {
        let cities = self.fetchCities()
        if let loccity = cities.filter({$0.name == cityName}).first {
            return loccity
        }
        
        let loccity = City()
        loccity.name = cityName
        return loccity
    }
    
    func addOrUpdateCity(city: City) {
        var cities = self.fetchCities()
        var cityix = 0
        if let loccity = cities.filter({$0.name == city.name}).first {
            cityix = cities.indexOf(loccity)!
            cities.removeAtIndex(cityix)
        }
        cities.insert(city, atIndex: cityix)
        self.storeCities(cities)
    }
    
    //Save all the cities and overwrite current content
    func storeCities(cities: [City]) {
        NSKeyedArchiver.archiveRootObject(cities, toFile: self.dbPath())    
        NSNotificationCenter.defaultCenter().postNotificationName(PersistanceServiceConst.kDataChanged, object: nil)

    }
    
    func deleteCity(cityName: String) {
        var cities = self.fetchCities()
        if let loccity = cities.filter({$0.name == cityName}).first {
            cities.removeAtIndex(cities.indexOf(loccity)!)
        }
        self.storeCities(cities)
    }
    
    //Clear all the saved cities
    func deleteAllCities() {
        self.storeCities([])
    }
}