//
//  TouristInfoImageRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoImageRequestDTO: Codable, TouristInfoRequestDTO {
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let contentId: String
  
  var toDictionary: [String: Any] {
    var dict: [String: Any] = [
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "contentId": contentId,
      "imageYN": "Y",
      "subImageYN": "Y"
    ]
    return dict
  }
  
  init(query: TouristInfoImageQuery) {
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.contentId = query.contentId.string
  }
}
