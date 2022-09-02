//
//  WeatherData.swift
//  Clima Weather App
//
//  Created by Oleksandr Smakhtin on 02.09.2022.
//

import Foundation

struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    
    let id: Int
}
