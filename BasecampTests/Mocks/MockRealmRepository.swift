//
//  MockRealmRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/21.
//

import Foundation
@testable import Basecamp

final class StubRealmRepository: RealmRepositoryInterface {
  static func saveFromLocalJson() {
    <#code#>
  }
  
  func loadCampsite() -> [Campsite] {
    <#code#>
  }
  
  func loadCampsite(query: String) -> [Campsite] {
    <#code#>
  }
  
  func loadCampsite(query: [[String]]) -> [Campsite] {
    <#code#>
  }
  
  func loadCampsite(keyword: String) -> [Campsite] {
    <#code#>
  }
  
  func loadCampsite(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    <#code#>
  }
  
  func saveCampsite(campsite: Campsite) {
    <#code#>
  }
  
  func unsaveCampsite(campsite: Campsite) {
    <#code#>
  }
  
  func updateCampsite(campsite: Campsite) {
    <#code#>
  }
  
  func loadReview() -> [Review] {
    <#code#>
  }
  
  func loadReview(query: String, startDate: Date, endDate: Date) -> [Review] {
    <#code#>
  }
  
  func saveReview(review: Review) {
    <#code#>
  }
  
  func updateReveiw(review: Review) {
    <#code#>
  }
  
  func deleteReview(review: Review) {
    <#code#>
  }
}
