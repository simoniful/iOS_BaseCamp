//
//  WeatherInfo.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

struct WeatherInfo: Codable {
    let date: Int
    let minTemp: Double
    let maxTemp: Double
    let weatherIcon: String
    let weather: String
}
