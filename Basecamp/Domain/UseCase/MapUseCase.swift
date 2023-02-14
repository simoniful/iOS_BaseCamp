//
//  MapUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import Foundation
import RxSwift
import RxCocoa

final class MapUseCase: FilterUseCase {
  internal let realmRepository: RealmRepositoryInterface
  
  init(realmRepository: RealmRepositoryInterface) {
    self.realmRepository = realmRepository
  }
  
//  func getValue<T>(_ result: Result<[T], some Error>) -> [T]? {
//    guard case .success(let value) = result else {
//      return nil
//    }
//    return value
//  }
//
//  func getError<T>(_ result: Result<[T], some Error>) -> String? {
//    guard case .failure(let error) = result else {
//      return nil
//    }
//    return error.localizedDescription
//  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    let data = realmRepository.loadCampsite(area: area, sigungu: sigungu)
    return data
  }
  
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
}
