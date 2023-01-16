//
//  RealmStorage.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation
import RealmSwift

final class RealmStorage {
  static let shared = RealmStorage()
  private let realm = try! Realm()
  
  func writeFromLocalJson(campsites: [Campsite]) {
    try! realm.write {
      realm.delete(realm.objects(CampsiteRealmDTO.self))
    }
    
    DispatchQueue.global().async {
      let realmOnBackground = try! Realm()
      autoreleasepool {
        let realmDTOs = campsites.map { CampsiteRealmDTO(campsite: $0) }
        try! realmOnBackground.write({
          realmOnBackground.add(realmDTOs)
        })
      }
      print("Realm is located at:", self.realm.configuration.fileURL!)
    }
  }
  
  func readCampsites() -> Results<CampsiteRealmDTO> {
    print("Realm is located at:", realm.configuration.fileURL!)
    return realm.objects(CampsiteRealmDTO.self).filter("contentID == '4'")
  }
  
  func hasCampsites(contentID: String) -> Bool {
    print(contentID, "콘텐츠 아이디 확인")
    return !(realm.objects(CampsiteRealmDTO.self).filter("contentID == '\(contentID)'").isEmpty)
  }
  
  func createCampsite(campsite: CampsiteRealmDTO) {
    try! realm.write {
      realm.add(campsite)
    }
  }
  
  func deleteCampsite(campsite: CampsiteRealmDTO) {
    try! realm.write {
      realm.delete(campsite)
    }
  }
  
  func readReviews() -> Results<ReviewDTO> {
    return realm.objects(ReviewDTO.self)
  }
  
  func createReview(review: ReviewDTO) {
    try! realm.write {
      realm.add(review)
    }
  }
  
  func updateReview(review: ReviewDTO) {
    // 읽고 다시 write
  }
  
  func deleteReview(review: ReviewDTO) {
    try! realm.write {
      realm.delete(review)
    }
  }
}

extension Results {
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
}
