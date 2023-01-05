//
//  WeatherResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/05.
//

import Foundation

// MARK: - WeatherResponseDTO
struct WeatherResponseDTO: Codable {
    let lat, lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let daily: [WeatherResponseDTO_Daily]?
}

// MARK: - Daily
struct WeatherResponseDTO_Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int?
    let moonset: Int?
    let moonPhase: Double?
    let temp: WeatherResponseDTO_Temp?
    let feelsLike: WeatherResponseDTO_FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [WeatherResponseDTO_Weather]?
    let clouds: Int?
    let pop: Double?
    let uvi: Int?
    let rain, snow: Double?
}

// MARK: - FeelsLike
struct WeatherResponseDTO_FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
struct WeatherResponseDTO_Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}

// MARK: - Weather
struct WeatherResponseDTO_Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
}

extension WeatherResponseDTO {
  func toDomain() -> [WeatherInfo] {
    return daily?.map {
      $0.toDomain()
    } ?? []
  }
}

extension WeatherResponseDTO_Daily {
  func toDomain() -> WeatherInfo {
    .init(
      date: Date(timeIntervalSince1970: TimeInterval(dt!)),
      minTemp: temp?.min,
      maxTemp: temp?.max,
      weatherIcon: weather?.first?.icon,
      description: weather?.description
    )
  }
}
