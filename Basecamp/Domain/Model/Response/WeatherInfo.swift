//
//  WeatherInfo.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

struct WeatherInfo: Codable {
    let date: Date?
    let minTemp: Double?
    let maxTemp: Double?
    let weatherIcon: String?
    let description: String?
}
