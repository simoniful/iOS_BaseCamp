//
//  WeatherRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import Foundation

struct WeatherRequestDTO: Codable {
  let lat: String
  let lon: String
  let exclude: String
  let appid: String
  let units: String
  let lang: String
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "lat": lat,
      "lon": lon,
      "exclude": exclude,
      "appid": appid,
      "units": units,
      "lang": lang
    ]
    return dict
  }
  
  init(query: WeatherQuery) {
    self.lat = query.lat.string
    self.lon = query.lon.string
    self.exclude = query.exclude
    self.appid = query.appid
    self.units = query.units
    self.lang = query.lang
  }
}

