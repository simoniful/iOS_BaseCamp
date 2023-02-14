//
//  MyPageUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/12.
//

import Foundation

final class MyPageUseCase {
  internal let realmRepository: RealmRepositoryInterface
  
  init(realmRepository: RealmRepositoryInterface) {
    self.realmRepository = realmRepository
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData() -> (Int, Int) {
    let likedCampsiteCount = realmRepository.loadCampsite().count
    let completedCampsiteCount = realmRepository.loadReview().count
    
    return (likedCampsiteCount, completedCampsiteCount)
  }
}
