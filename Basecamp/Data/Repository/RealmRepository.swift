//
//  RealmRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/23.
//

import Foundation
import RealmSwift

final class RealmRepository: RealmRepositoryInterface {
  var storage: RealmStorage

  init() {
      self.storage = RealmStorage.shared
  }
  
  func loadCampsite() -> [Campsite] {
    let realmDTO = storage.readCampsites().toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func saveCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    storage.createCampsite(campsite: campsiteDTO)
  }
  
  func unsaveCampsite() {
    <#code#>
  }
  
  func loadReview() -> [Review] {
    <#code#>
  }
  
  func saveReview(review: Review) {
    <#code#>
  }
  
  func updateReveiw(review: Review) {
    <#code#>
  }
  
  func deleteReview() {
    <#code#>
  }
}


