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
    return realm.objects(CampsiteRealmDTO.self).filter("isLiked == true")
  }
  
  func readCampsites(query: String) -> Results<CampsiteRealmDTO> {
    return realm.objects(CampsiteRealmDTO.self).filter(query)
  }
  
  func readCampsites(query: [[String]]) -> Results<CampsiteRealmDTO> {
    print("Realm is located at:", realm.configuration.fileURL!)
    if query == [[], [], [], [], []] {
      return realm.objects(CampsiteRealmDTO.self)
    } else {
      let areaQuery = query[0].joined(separator: " OR ")
      let envQuery = query[1].joined(separator: " AND ")
      let fcltyQuery = query[2].joined(separator: " AND ")
      let ruleQuery = query[3].joined(separator: " AND ")
      let petQuery = query[4].joined(separator: " AND ")
      
      let totalData = realm.objects(CampsiteRealmDTO.self)
      
      let first = areaQuery.isEmpty ? totalData : totalData.filter(areaQuery)
      let second = envQuery.isEmpty ? first : first.filter(envQuery)
      let third = fcltyQuery.isEmpty ? second : second.filter(fcltyQuery)
      let fourth = ruleQuery.isEmpty ? third : third.filter(ruleQuery)
      let fifth = petQuery.isEmpty ? fourth : fourth.filter(petQuery)
      
      return fifth
    }
  }
  
  func readCampsites(keyword: String) -> Results<CampsiteRealmDTO> {
    let totalData = realm.objects(CampsiteRealmDTO.self)
    let result = totalData.filter("addr1 CONTAINS '\(keyword)' OR facltNm CONTAINS '\(keyword)'")
    return result
  }
  
  func readCampsites(area: Area?, sigungu: Sigungu?) -> Results<CampsiteRealmDTO> {
    var result = realm.objects(CampsiteRealmDTO.self)
    if let area = area {
      result = result.filter("doNm CONTAINS '\(area.doNm)'")
    }
    if let sigungu = sigungu {
      result = result.filter("addr1 CONTAINS '\(sigungu.name!)'")
    }
    return result
  }
  
  func updateCampsites(campsite: CampsiteRealmDTO) {
    print("Realm is located at:", self.realm.configuration.fileURL!)
    guard let taskToUpdate = realm.objects(CampsiteRealmDTO.self).filter("contentID == '\(campsite.contentID)'").first else { return }
    
    try! realm.write {
      taskToUpdate.isLiked = !(taskToUpdate.isLiked)
    }
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
  
  func readReviews(query: String, startDate: Date, endDate: Date) -> Results<ReviewDTO> {
    return realm.objects(ReviewDTO.self).filter(query, startDate, endDate)
  }
  
  func createReview(review: ReviewDTO) {
    try! realm.write {
      realm.add(review)
      print("Realm is located at:", realm.configuration.fileURL!)
    }
  }
  
  func updateReview(review: ReviewDTO) {
    // 읽고 다시 write
  }
  
  func deleteReview(review: ReviewDTO) {
    
    guard let taskToDelete = realm.objects(ReviewDTO.self).filter("_id == %@", review._id).first else { return }
    
    print(review._id, taskToDelete._id, "비교")
    
    try! realm.write {
      realm.delete(taskToDelete)
    }
  }
}

extension Results {
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
}
