//
//  TouristInfoRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RxSwift

protocol TouristInfoRepositoryInterface: AnyObject {
  func requestTouristInfo(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TourlistInfo, Error>>
}
