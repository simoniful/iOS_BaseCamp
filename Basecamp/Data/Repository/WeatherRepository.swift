//
//  WeatherRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import Moya

enum WeatherServiceError: Error {
    case unableToConstructUrl
    case zipCodeIncorrect
    case latLongIncorrect
    case locationError
    case networkError
    case unableToParseWeatherResponse
    case unableToParseTemperatureUnit
    case other
}

final class WeatherRepository: WeatherRepositoryInterface {
  func requestWeatherList(weatherQueryType: WeatherQueryType) -> Single<Result<[WeatherInfo], WeatherServiceError>> {
    switch weatherQueryType {
    case .basic:
      let query = weatherQueryType.query
      let requestDTO = WeatherRequestDTO(query: query)
      let target = MultiTarget(WeatherTarget.getWeather(parameters: requestDTO.toDictionary))
      return provider.rx.request(target)
        .filterSuccessfulStatusCodes()
        .flatMap { response -> Single<Result<[WeatherInfo], WeatherServiceError>> in
          let responseDTO = try response.map(WeatherResponseDTO.self)
          return Single.just(Result.success(responseDTO.toDomain()))
        }
        .catch { error in
          return Single.just(Result.failure(.networkError))
        }
    }
  }
}
