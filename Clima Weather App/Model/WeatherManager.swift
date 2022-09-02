//
//  WeatherManager.swift
//  Clima Weather App
//
//  Created by Oleksandr Smakhtin on 02.09.2022.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}




struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=81c6eecf06e4729b259620afed0811de&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        //print(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URL session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    print(error!)
                    // when there is an error the func ends
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
                
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, tempreture: temp)
            return weather
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
        
        
    }
    

    
    
    
    
    
    

    
    
    
}
