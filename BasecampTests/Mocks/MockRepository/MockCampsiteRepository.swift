//
//  MockCampsiteRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/21.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Basecamp

final class StubCampsiteRepository: CampsiteRepositoryInterface {
  func requestCampsiteList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Campsite], CampsiteServiceError>> {
    let dummy = campsiteDummyData.toDomain()
    return Single.just(.success(dummy))
  }
  
  func requestCampsiteImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], CampsiteServiceError>> {
    let dummy = campsiteImageDummyData.toDomain()
    return Single.just(.success(dummy))
  }
}
  
  
