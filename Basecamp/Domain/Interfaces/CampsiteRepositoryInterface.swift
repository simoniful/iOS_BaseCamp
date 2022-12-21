//
//  CampsiteRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RxSwift

protocol CampsiteRepositoryInterface: AnyObject {
//   아마 추가적인 기입 정보 더 필요
  func requestCampsite(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Campsite], CampsiteServiceError>>
}
