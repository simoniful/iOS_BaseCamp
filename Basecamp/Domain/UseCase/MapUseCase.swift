//
//  MapUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import Foundation
import RxSwift
import RxCocoa

final class MapUseCase {
  private let realmRepository: RealmRepositoryInterface
  
  init(realmRepository: RealmRepositoryInterface) {
    self.realmRepository = realmRepository
  }
  
  func getValue<T>(_ result: Result<[T], some Error>) -> [T]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getError<T>(_ result: Result<[T], some Error>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    let data = realmRepository.loadCampsite(area: area, sigungu: sigungu)
    return data
  }
}
