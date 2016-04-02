//
//  AddCityViewController.swift
//  SwiftWeather
//
//  Created by Aleksandar Mihailovski on 4/1/16.
//  Copyright © 2016 Aleksandar Mihailovski. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var cityName: UITextField?
    
    let persistanceService: PersistanceService = PersistanceService()
    let weatherService: WeatherService = WeatherService()
    
    @IBAction func addCity(sender: AnyObject) {
        let cityName = self.cityName?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if self.isCityNameValid(self.cityName?.text) {
            let city = City()
            city.name = cityName
            persistanceService.addOrUpdateCity(city)
            weatherService.weatherForCity(city.name, completionClosure: {
                (city: City)  in
                    self.persistanceService.addOrUpdateCity(city)
            })
            self.dismissScreen()
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid city name (alphabetic characters only)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeScreen(sender: AnyObject) {
        self.dismissScreen()
    }
    
    private func dismissScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func isCityNameValid(cityName: String?) -> Bool {
        var testCityName = cityName
        
        if testCityName == nil {
            return false
        }
        
        testCityName = testCityName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if testCityName!.isEmpty {
            return false
        }
        
        let invalidCharSet = NSMutableCharacterSet()
        invalidCharSet.formUnionWithCharacterSet(NSCharacterSet.decimalDigitCharacterSet())
        invalidCharSet.formUnionWithCharacterSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        let range = testCityName!.rangeOfCharacterFromSet(invalidCharSet, options: NSStringCompareOptions(), range: nil)
        if range != nil {
            return false
        }
        
        return true
    }
}