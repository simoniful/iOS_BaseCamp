//
//  RealmRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RealmSwift

protocol RealmRepositoryInterface: AnyObject {
  func loadCampsite(matchedID: String) -> [Campsite]
  func saveCampsite(campsite: Campsite, matchedID: String)
  func unsaveCampsite(matchedID: String)
  
  func loadReview(matchedID: String) -> [Review]
  func saveReview(review: Review, matchedID: String)
  func deleteReview(matchedID: String)
}
