//
//  TouristInfoCommonRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoCommonRequestDTO: Codable, TouristInfoRequestDTO {
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let contentId: String
  let contentTypeId: String
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "contentId": contentId,
      "contentTypeId": contentTypeId,
      "defaultYN": "Y",
      "firstImageYN": "Y",
      "areacodeYN": "Y",
      "catcodeYN": "Y",
      "addrinfoYN": "Y",
      "mapinfoYN": "Y",
      "overviewYN": "Y"
    ]
    return dict
  }
  
  init(query: TouristInfoCommonQuery) {
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.contentId = query.contentId.string
    self.contentTypeId = query.contentTypeId.rawValue.string
  }
}
