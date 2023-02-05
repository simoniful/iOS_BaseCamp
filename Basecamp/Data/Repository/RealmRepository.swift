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
  
  func saveFromLocalJson() {
    if let url = Bundle.main.url(forResource: "goCampingData", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        if let mappingDTO = try? decoder.decode(CampsiteResponseDTO.self, from: data) {
          // 기존의 데이터에서 추가된 부분의 집합만 구분하여 더하는 형식 필요
          let campsites = mappingDTO.toDomain()
          storage.writeFromLocalJson(campsites: campsites)
        }
      } catch {
        print("불러오기를 실패했습니다")
      }
    }
  }
  
  func loadCampsite() -> [Campsite] {
    let realmDTO = storage.readCampsites().toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(query: String) -> [Campsite] {
    let realmDTO = storage.readCampsites(query: query).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(query: [[String]]) -> [Campsite] {
    let realmDTO = storage.readCampsites(query: query).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(keyword: String) -> [Campsite] {
    let realmDTO = storage.readCampsites(keyword: keyword).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    let realmDTO = storage.readCampsites(area: area, sigungu: sigungu).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func saveCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    storage.createCampsite(campsite: campsiteDTO)
  }
  
  func unsaveCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    storage.deleteCampsite(campsite: campsiteDTO)
  }
  
  func checkCampsite(campsite: Campsite) -> Bool {
    storage.hasCampsites(contentID: campsite.contentID!)
  }
  
  func loadReview() -> [Review] {
    let realmDTO = storage.readReviews().toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func saveReview(review: Review) {
    
  }

  func updateReveiw(review: Review) {
    
  }

  func deleteReview(review: Review) {
    
  }
}


