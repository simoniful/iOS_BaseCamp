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
  func requestRealmDataCount() -> (Int, Int) {
    let likedCampsiteCount = realmRepository.loadCampsite().count
    let completedCampsiteCount = realmRepository.loadReview().count
    
    return (likedCampsiteCount, completedCampsiteCount)
  }
  
  func requestLikedCampsiteData() -> [Campsite] {
    let data = realmRepository.loadCampsite()
    return data
  }
  
  func updateLikedCampsiteData(campsites: [Campsite]) {
    campsites.forEach {
      realmRepository.updateCampsite(campsite: $0)
    }
  }
  
  func requestReviewData() -> [Review] {
    let data = realmRepository.loadReview()
    return data
  }
  
  func requestReviewData(query: String, startDate: Date, endDate: Date) -> [Review] {
    let data = realmRepository.loadReview(query: query, startDate: startDate, endDate: endDate)
    return data
  }
  
  func deleteReviewData(review: Review) {
    realmRepository.deleteReview(review: review)
  }
}
