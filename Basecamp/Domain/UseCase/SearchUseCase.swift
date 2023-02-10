//
//  SearchUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilterUseCase: AnyObject {
  var realmRepository: RealmRepositoryInterface { get }
  
  func requestRealmData(min: Int, max: Int, filterCases: [FilterCase]) -> [Campsite]
}

final class SearchUseCase: FilterUseCase {
  private let campsiteRepository: CampsiteRepositoryInterface
  internal let realmRepository: RealmRepositoryInterface
  
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
  func requestRealmData(min: Int = 0, max: Int = 24, filterCases: [FilterCase]) -> [Campsite] {
    let queryStrArr: [[String]] = filterCases.compactMap { filterCase -> [String] in
      switch filterCase {
      case .area(let area):
        return area?.compactMap{ $0.realmQuery } ?? []
      case .environment(let env, let exp):
        let envQuery = env?.compactMap{ $0.realmQuery } ?? []
        let expQuery = exp?.compactMap{ $0.realmQuery } ?? []
        return envQuery + expQuery
      case .rule(let campType, let resv):
        let campTypeQuery = campType?.compactMap{ $0.realmQuery } ?? []
        let resvQuery = resv?.compactMap{ $0.realmQuery } ?? []
        return campTypeQuery + resvQuery
      case .facility(let basicFctly, let sanitaryFctly, let sportsFctly):
        let basicFctlyQuery = basicFctly?.compactMap{ $0.realmQuery } ?? []
        let sanitaryFctlyQuery = sanitaryFctly?.compactMap{ $0.realmQuery } ?? []
        let sportsFctlyQuery = sportsFctly?.compactMap{ $0.realmQuery } ?? []
        return basicFctlyQuery + sanitaryFctlyQuery + sportsFctlyQuery
      case .pet(let petEntry, let petSize):
        let petEntryQuery = petEntry?.compactMap{ $0.realmQuery } ?? []
        let petSizeQuery = petSize?.compactMap{ $0.realmQuery } ?? []
        return petEntryQuery + petSizeQuery
      }
    }
    
    let data = realmRepository.loadCampsite(query: queryStrArr)
    return data
  }
  
  func requestRealmData(keyword: String) -> [Campsite] {
    let data = realmRepository.loadCampsite(keyword: keyword)
    return data
  }
}
