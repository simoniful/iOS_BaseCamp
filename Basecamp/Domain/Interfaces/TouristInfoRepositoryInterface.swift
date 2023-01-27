//
//  TouristInfoRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RxSwift

protocol TouristInfoRepositoryInterface: AnyObject {
  func requestTouristInfoList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoData, TouristInfoServiceError>>
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>>
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType, contentType: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>>
  
  func requestTouristInfoImageList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[String], TouristInfoServiceError>>
  
  func requestTouristInfoAreaCode(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[Sigungu], TouristInfoServiceError>>
}
