//
//  MockTouristInfoRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/21.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Basecamp

final class StubTouristInfoRepository: TouristInfoRepositoryInterface {
  func requestTouristInfoList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    let dummy = touristInfoDummyData.toDomain()
    return Single.just(Result.success(dummy))
  }
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> {
    let dummy = touristInfoCommonDummyData.toDomain()
    return Single.just(Result.success(dummy))
  }
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType, contentType: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> {
    let dummy = touristInfoIntroDummyData.toDomain()
    return Single.just(Result.success([dummy]))
  }
  
  func requestTouristInfoImageList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[String], TouristInfoServiceError>> {
    let dummy = touristInfoImageDummyData.toDomain()
    return Single.just(Result.success(dummy))
  }
  
  func requestTouristInfoAreaCode(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[Sigungu], TouristInfoServiceError>> {
    let dummy = touristInfoAreaCodeDummyData.toDomain()
    return Single.just(Result.success(dummy))
  }
}
