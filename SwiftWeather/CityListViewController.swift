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

    //MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel!.text = String(format: "%@",city.name)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(CityListSeagueConst.kShowCityDetails, sender: self.cities[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CityListSeagueConst.kShowCityDetails {
            let city = sender as! City
            let cityDetailsVC = segue.destinationViewController as! CityDetailsViewController
            cityDetailsVC.city = city
        }
    }
    
    func dataChanged() {
        self.cities = self.persistanceService.fetchCities()
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}