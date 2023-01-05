//
//  WeatherQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

enum WeatherQueryType {
  case basic(lat: Double, lon: Double)
  
  var query: WeatherQuery {
    switch self {
    case .basic(let lat, let lon):
      return WeatherQuery(
        lat: lat,
        lon: lon,
        appid: APIKey.weather.rawValue.decodeUrl()
      )
    }
  }
}

struct WeatherQuery {
  var lat: Double
  var lon: Double
  var exclude: String = "current,minutely,hourly,alerts"
  var appid: String
  var units: String = "metric"
  var lang: String = "kr"
}
