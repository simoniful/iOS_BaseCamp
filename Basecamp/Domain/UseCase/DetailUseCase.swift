//
//  DetailUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation

final class DetailUseCase {
  private let realmRepository: RealmRepositoryInterface
  private let touristInfoRepository: TouristInfoRepositoryInterface
  private let weatherRepository: WeatherRepositoryInterface
  private let naverBlogRepository: NaverBlogRepositoryInterface
  private let youTubeRepository: YouTubeRepositoryInterface
  
  init(realmRepository: RealmRepositoryInterface,
       touristInfoRepository: TouristInfoRepositoryInterface,
       weatherRepository: WeatherRepositoryInterface,
       naverBlogRepository: NaverBlogRepositoryInterface,
       youTubeRepository: YouTubeRepositoryInterface
  ) {
    self.realmRepository = realmRepository
    self.touristInfoRepository = touristInfoRepository
    self.weatherRepository = weatherRepository
    self.naverBlogRepository = naverBlogRepository
    self.youTubeRepository = youTubeRepository
  }
  
  func getTouristInfoValue(_ result: Result<[TouristInfo], TouristInfoServiceError>) -> [TouristInfo]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getTouristInfoError(_ result: Result<[TouristInfo], TouristInfoServiceError>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
}
