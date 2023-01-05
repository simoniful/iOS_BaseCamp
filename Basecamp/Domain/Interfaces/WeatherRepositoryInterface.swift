//
//  WeatherRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift

protocol WeatherRepositoryInterface: AnyObject {
  func requestWeatherList(weatherQueryType: WeatherQueryType) -> Single<Result<[WeatherInfo], WeatherServiceError>>
}
