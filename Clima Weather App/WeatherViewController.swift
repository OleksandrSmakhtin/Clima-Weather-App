//
//  ViewController.swift
//  Clima Weather App
//
//  Created by Oleksandr Smakhtin on 02.09.2022.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTxtField.delegate = self
    }


    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTxtField.endEditing(true)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.endEditing(true)
        return true
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type a city"
            return false
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searcText.text to get the weather from the API
        if let city = searchTxtField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTxtField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempretureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}



//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    

}

