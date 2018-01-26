//
//  WeatherTestTests.swift
//  WeatherTestTests
//
//  Created by Prasad Lade on 25/01/18.
//  Copyright © 2018 test. All rights reserved.
//

import XCTest
@testable import WeatherTest


class WeatherTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test case to test Weather Info Model
    func testWeatherInfo() {
        var weatherData = [String: Any]()
        weatherData["name"] = "San Antonio"
        var mainInfo = [String: Any]()
        mainInfo["temp"] = 19.89334566 as Float
        mainInfo["temp_max"] = 25.89334566 as Float
        mainInfo["temp_min"] = 17.97576463 as Float
        weatherData["main"] = mainInfo
        
        var weatherArray = [[String: Any]]()
        var weatherDescObj = [String: Any]()
        weatherDescObj["description"] = "Cloud Description"
        weatherDescObj["icon"] = "10d"
        weatherArray.append(weatherDescObj)
        weatherData["weather"] = weatherArray

        let weather = Weather(info: weatherData)

        XCTAssertEqual(weather.city, "San Antonio", "City Name Wrongly Mapped")
        XCTAssertEqual(weather.temperature, "\(round(19.89334566))", "Temperature Wrongly Mapped")
        XCTAssertEqual(weather.maxTemperature, "\(round(25.89334566))", "max temperature Wrongly Mapped")
        XCTAssertEqual(weather.minTemperature, "\(round(17.97576463))", "min temperature Wrongly Mapped")
        XCTAssertEqual(weather.description, "Cloud Description", "Weather description Wrongly Mapped")
        let imageURL = weather.imageBaseURL + ((weatherArray[0]["icon"]) as! String) + ".png"
        XCTAssertEqual(weather.imageURL, imageURL, "imageURL not formed properly")
    }
}
