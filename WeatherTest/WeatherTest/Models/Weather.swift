//
//  Weather.swift
//  WeatherTest
//
//  Created by Prasad Lade on 25/01/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

struct Weather {
    
    let imageBaseURL = "http://openweathermap.org/img/w/"
    private(set) var city: String?
    private(set) var temperature: String?
    private(set) var maxTemperature: String?
    private(set) var minTemperature: String?
    private(set) var description: String?
    private(set) var imageURL: String?
    
    init(info: [AnyHashable: Any]) {
        // Grabbing the weather informaion from the info object and setting to iVars
        self.city = info["name"] as? String
        guard let main = info["main"] as? [String: Any] else {
            return
        }
        self.temperature = "\(round(main["temp"] as! Float))"
        self.maxTemperature = "\(round(main["temp_max"] as! Float))"
        self.minTemperature =  "\(round(main["temp_min"] as! Float))"
        guard let weatherArray = info["weather"] as? [[String: Any]] else {
            return
        }
        self.description = weatherArray[0]["description"] as? String
        self.imageURL = imageBaseURL + ((weatherArray[0]["icon"]) as! String) + ".png"
    }
    
}
