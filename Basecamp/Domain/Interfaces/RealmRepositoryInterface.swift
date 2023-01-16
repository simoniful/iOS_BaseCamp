//
//  RealmRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RealmSwift

protocol RealmRepositoryInterface: AnyObject {
  func saveFromLocalJson()
  
  func loadCampsite() -> [Campsite]
  func saveCampsite(campsite: Campsite)
  func unsaveCampsite(campsite: Campsite)
  func checkCampsite(campsite: Campsite) -> Bool
  
  func loadReview() -> [Review]
  func saveReview(review: Review)
  func updateReveiw(review: Review)
  func deleteReview(review: Review)
}
