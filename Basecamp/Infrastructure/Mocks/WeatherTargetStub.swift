//
//  WeatherTargetStub.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

extension WeatherTarget {
  func stubData(_ target: WeatherTarget) -> Data {
    switch self {
    case .getWeather:
      return Data("a".utf8)
    }
  }
}
