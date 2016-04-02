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
    
    var persistanceService: PersistanceService = PersistanceService()
    var cities: [City] = []

    override func loadView() {
        super.loadView()
        self.cities = self.persistanceService.fetchCities()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CityDetailsViewController.dataChanged), name: PersistanceServiceConst.kDataChanged, object: nil)
    }
    
    func dataChanged() {
        self.cities = self.persistanceService.fetchCities()
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
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