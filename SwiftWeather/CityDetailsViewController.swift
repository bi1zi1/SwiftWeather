//
//  CityDetailsViewController.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var city: City?
    let persistanceService: PersistanceService = PersistanceService()
    
    override func loadView() {
        super.loadView()
        self.title = city?.name
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CityDetailsViewController.dataChanged), name: PersistanceServiceConst.kDataChanged, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.temperatureLabel?.text = "N/A"
        self.humidityLabel?.text = "N/A"
        self.descriptionLabel?.text = "N/A"
        
        self.displayCityData()
    }
    
    func dataChanged() {
        self.city = persistanceService.fetchCityDataForName((city?.name)!)
        dispatch_async(dispatch_get_main_queue()) {
            self.displayCityData()
        }
    }
    
    private func displayCityData() {
        if let testVal = city?.temp?.celsius {
            self.temperatureLabel?.text = String(testVal)
        }
        
        if let testVal = city?.humidity {
            self.humidityLabel?.text = String(testVal)
        }
        
        if let testVal = city?.weatherDescription {
            self.descriptionLabel?.text = String(testVal)
        }
    }
    
}