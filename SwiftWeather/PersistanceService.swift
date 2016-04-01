//
//  PersistanceService.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import Foundation

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
    
    //Save all the cities and overwrite current content
    func storeCities(cities: [City]) {
        NSKeyedArchiver.archiveRootObject(cities, toFile: self.dbPath())
    }
    
    //Clear all the saved cities
    func deleteAllCities() {
        self.storeCities([])
    }
}