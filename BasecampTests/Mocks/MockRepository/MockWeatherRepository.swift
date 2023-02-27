//
//  MockWeatherRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/25.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Basecamp

final class StubWeatherRepository: WeatherRepositoryInterface {
  func requestWeatherList(weatherQueryType: WeatherQueryType) -> Single<Result<[WeatherInfo], WeatherServiceError>> {
    let dummy = weatherDummyData.toDomain()
    return Single.just(Result.success(dummy))
  }
}
