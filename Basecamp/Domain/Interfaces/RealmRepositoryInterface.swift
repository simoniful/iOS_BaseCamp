//
//  RealmRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RealmSwift

protocol RealmRepositoryInterface: AnyObject {
  static func saveFromLocalJson()
  
  func loadCampsite() -> [Campsite]
  func loadCampsite(query: String) -> [Campsite]
  func loadCampsite(query: [[String]]) -> [Campsite]
  func loadCampsite(keyword: String) -> [Campsite]
  func loadCampsite(area: Area?, sigungu: Sigungu?) -> [Campsite]
  func saveCampsite(campsite: Campsite)
  func unsaveCampsite(campsite: Campsite)
  func updateCampsite(campsite: Campsite)
  
  func loadReview() -> [Review]
  func loadReview(query: String, startDate: Date, endDate: Date) -> [Review]
  func saveReview(review: Review)
  func updateReveiw(review: Review)
  func deleteReview(review: Review)
}
