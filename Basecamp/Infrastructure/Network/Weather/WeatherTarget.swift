//
//  WeatherTarget.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation
import Moya

enum WeatherTarget {
  case getWeather(parameters: DictionaryType)
}

extension WeatherTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: WeatherAPIConstant.environment.rawValue) else {
        fatalError("Fatal error - invalid weather API url")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getWeather(_):
      return "/onecall"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case.getWeather(_):
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getWeather(let parameters):
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.default
      )
    }
  }
  
  var validationType: ValidationType {
      return .customCodes([200])
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}
