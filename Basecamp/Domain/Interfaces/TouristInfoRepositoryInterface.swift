//
//  TouristInfoRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RxSwift

protocol TouristInfoRepositoryInterface: AnyObject {
  func requestTouristInfoList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfo], TouristInfoServiceError>>
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoCommon, TouristInfoServiceError>>
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoIntro, TouristInfoServiceError>>
  
  func requestTouristInfoDetail(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoDetail, TouristInfoServiceError>>
  
  func requestTouristInfoImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], TouristInfoServiceError>>
}
