//
//  CityListViewController.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import UIKit

struct CityListSeagueConst {
    static var kShowCityDetails = "showCityDetails"
}

class CityListViewController: UITableViewController {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem?
    
    let persistanceService: PersistanceService = PersistanceService()
    let weatherService: WeatherService = WeatherService()
    var cities: [City] = []

    override func loadView() {
        super.loadView()
        self.cities = self.persistanceService.fetchCities()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CityDetailsViewController.dataChanged), name: PersistanceServiceConst.kDataChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadWeatherData()
    }
    
    func dataChanged() {
        self.cities = self.persistanceService.fetchCities()
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func reloadWeatherData() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(500 * Double(USEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            //fetch fresh data for each city
            for oneCity in self.cities
            {
                self.weatherService.weatherForCity(oneCity.name, completionClosure: {(city: City)  in
                    self.persistanceService.addOrUpdateCity(city)
                })
            }
        })
    }

    //MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath)
        let city = self.cities[indexPath.row]
        cell.textLabel!.text = String(format: "%@",city.name)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(CityListSeagueConst.kShowCityDetails, sender: self.cities[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deleteCityName = self.cities[indexPath.row].name;
            self.cities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.persistanceService.deleteCity(deleteCityName)
        }
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CityListSeagueConst.kShowCityDetails {
            let city = sender as! City
            let cityDetailsVC = segue.destinationViewController as! CityDetailsViewController
            cityDetailsVC.city = city
        }
    }
}