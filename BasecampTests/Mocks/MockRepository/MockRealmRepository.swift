//
//  MockRealmRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/21.
//

import Foundation
@testable import Basecamp

final class StubRealmRepository: RealmRepositoryInterface {
  static func saveFromLocalJson() {}
  
  // home
  func loadCampsite() -> [Campsite] {
    return campsiteDummyData.toDomain()
  }
  
  func loadCampsite(query: String) -> [Campsite] {
    return campsiteDummyData.toDomain()
  }
  
  func loadCampsite(query: [[String]]) -> [Campsite] {
    return campsiteDummyData.toDomain()
  }
  
  func loadCampsite(keyword: String) -> [Campsite] {
    return campsiteDummyData.toDomain()
  }
  
  func loadCampsite(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    return campsiteDummyData.toDomain()
  }
  var saveCampsiteCalled = false
  func saveCampsite(campsite: Campsite) {
    saveCampsiteCalled = true
  }
  
  func unsaveCampsite(campsite: Campsite) {}
  
  var updateCampsiteCalled = false
  func updateCampsite(campsite: Campsite) {
    updateCampsiteCalled = true
  }
  
  func loadReview() -> [Review] {
    return []
  }
  
  func loadReview(query: String, startDate: Date, endDate: Date) -> [Review] {
    return []
  }
  func saveReview(review: Review) {}
  func updateReveiw(review: Review) {}
  func deleteReview(review: Review) {}
}
