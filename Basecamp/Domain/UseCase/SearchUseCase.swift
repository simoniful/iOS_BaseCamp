//
//  SearchUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchUseCase {
  private let campsiteRepository: CampsiteRepositoryInterface
  private let realmRepository: RealmRepositoryInterface
  
  init(campsiteRepository: CampsiteRepositoryInterface, realmRepository: RealmRepositoryInterface) {
    self.campsiteRepository = campsiteRepository
    self.realmRepository = realmRepository
  }
  
  // MARK: - 지역 정보 매핑
  func requestAreaData() -> [HomeAreaItem] {
    let areaList = Area.allCases.map {
      HomeAreaItem(area: $0)
    }
    return areaList
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData(min: Int = 0, max: Int = 24, filterCase: [FilterCase]) -> [Campsite] {
    let data = realmRepository.loadCampsite()
    return data
  }
}
