//
//  RealmRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/23.
//

import Foundation
import RealmSwift

enum RealmError: Error {
  case saveFromLocalFailure
}

final class RealmRepository: RealmRepositoryInterface {
  static var storage = RealmStorage.shared
  
  static func saveFromLocalJson()  {
    guard let url = Bundle.main.url(forResource: "goCampingData", withExtension: "json") else { return }
    do {
      let data = try Data(contentsOf: url, options: .mappedIfSafe)
      let decoder = JSONDecoder()
      if let mappingDTO = try? decoder.decode(CampsiteResponseDTO.self, from: data) {
        // 기존의 데이터에서 추가된 부분의 집합만 구분하여 더하는 형식 필요
        let campsites = mappingDTO.toDomain()
        storage.writeFromLocalJson(campsites: campsites)
      }
    } catch {
      print("Init DB Setting Error")
    }
  }
  
  func loadCampsite() -> [Campsite] {
    let realmDTO = RealmRepository.storage.readCampsites().toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(query: String) -> [Campsite] {
    let realmDTO = RealmRepository.storage.readCampsites(query: query).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(query: [[String]]) -> [Campsite] {
    let realmDTO = RealmRepository.storage.readCampsites(query: query).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(keyword: String) -> [Campsite] {
    let realmDTO = RealmRepository.storage.readCampsites(keyword: keyword).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func loadCampsite(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    let realmDTO = RealmRepository.storage.readCampsites(area: area, sigungu: sigungu).toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  
  func saveCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    RealmRepository.storage.createCampsite(campsite: campsiteDTO)
  }
  
  func unsaveCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    RealmRepository.storage.deleteCampsite(campsite: campsiteDTO)
  }
  
  func updateCampsite(campsite: Campsite) {
    let campsiteDTO = CampsiteRealmDTO(campsite: campsite)
    RealmRepository.storage.updateCampsites(campsite: campsiteDTO)
  }
  
  func loadReview() -> [Review] {
    let realmDTO = RealmRepository.storage.readReviews().toArray()
    return realmDTO.map {
      $0.toDomain()
    }
  }
  
  func saveReview(review: Review) {
    let reviewDTO = ReviewDTO(review: review)
    RealmRepository.storage.createReview(review: reviewDTO)
  }
  
  func updateReveiw(review: Review) {
    
  }
  
  func deleteReview(review: Review) {
    
  }
}


