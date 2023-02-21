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
    <#code#>
  }
  
  func requestCampsiteImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], CampsiteServiceError>> {
    <#code#>
  }
  
  
}
  
  
