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
    <#code#>
  }
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> {
    <#code#>
  }
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType, contentType: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> {
    <#code#>
  }
  
  func requestTouristInfoImageList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[String], TouristInfoServiceError>> {
    <#code#>
  }
  
  func requestTouristInfoAreaCode(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[Sigungu], TouristInfoServiceError>> {
    <#code#>
  }
  
  
  
}
