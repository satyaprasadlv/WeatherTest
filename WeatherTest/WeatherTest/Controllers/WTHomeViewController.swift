//
//  WTHomeViewController.swift
//  WeatherTest
//
//  Created by Prasad Lade on 25/01/18.
//  Copyright © 2018 test. All rights reserved.
//

/********** Note *******

-> Some of the Places I used Force Unwrapping using "!". But If I have some more time, I would have used safe urwrapping with Guard and If lets
-> I implemented Service Call Directly in the Controller, I will try implementing in Separate Controller if got some time
-> For UI, I just added simply because of less time.

***********/


import UIKit
import GooglePlaces
import SDWebImage

class WTHomeViewController: UIViewController {

    private(set) var isLoadingData: Bool = false
    // Creating Weather API object with API Key
    private var weatherAPI = OWMWeatherAPI(apiKey:"647e2b518d4dd03d6702e0ecc132c95f")
    
    // UI Items to display Weather Information on the View
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Weather App"
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        
        // Grabbing the recent searched city info
        if let city = UserDefaults.standard.string(forKey: "RecentCity") {
            // Making a service call to retrieve weather info for the given city
            getWeather(cityName: city)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func loadWeather(with info: Weather) {
        
        cityLabel.text = info.city
        currentTempLabel.text = info.temperature
        maxTempLabel.text = info.maxTemperature
        minTempLabel.text = info.minTemperature
        cloudinessLabel.text = info.description
        guard let imageURL = info.imageURL else {
            weatherImageView.image = UIImage(named: "CardDefaultIcon")
            return
        }
        weatherImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "CardDefaultIcon"))
    }
}

// MARK: Service data retrieval methods
extension WTHomeViewController {
    
    // Getting Weather details for the present time.
    private func getWeather(cityName: String) {
        
        if let network = Reachability()?.connection, network == .none {
            let alert = UIAlertController(title: "Error", message: "No Network Connection available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        // return if already making a service call
        if isLoadingData {
            return
        }
        // show status bar activity indicator
        isLoadingData = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        weatherAPI?.setLangWithPreferedLanguage()
        weatherAPI?.setTemperatureFormat(kOWMTempCelcius)
        weatherAPI?.currentWeather(byCityName: cityName, withCallback: { [weak self] (error, result) in
            guard let weakSelf = self else {
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if (error != nil) {
                print(error ?? "Error found")
                weakSelf.isLoadingData = false
                return
            }
            guard let result = result else {
                return
            }
            let weatherObj = Weather(info: result)
            weakSelf.loadWeather(with: weatherObj)
            weakSelf.isLoadingData = false
        })
    }
}

// MARK:  Google's City Auto Completion API methods
extension WTHomeViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        UserDefaults.standard.set(place.name, forKey: "RecentCity")
        UserDefaults.standard.synchronize()
        getWeather(cityName: place.name)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
