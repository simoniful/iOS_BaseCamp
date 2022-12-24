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
  
  func readCampsites() -> Results<CampsiteRealmDTO> {
    print("Realm is located at:", realm.configuration.fileURL!)
    return realm.objects(CampsiteRealmDTO.self).filter("isLiked == true")
  }
  
  func create(campsite: CampsiteRealmDTO) {
    try! realm.write {
      realm.add(campsite)
    }
  }
  
  func delete(campsite: CampsiteRealmDTO) {
    try! realm.write {
      realm.delete(campsite)
    }
  }
  
  
}

extension Results {
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
}
