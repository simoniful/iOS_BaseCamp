//
//  CampsiteRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RxSwift

protocol CampsiteRepositoryInterface: AnyObject {

  func requestCampsite(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Campsite], CampsiteServiceError>>
  
  func requestCampsiteImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], CampsiteServiceError>>
}
