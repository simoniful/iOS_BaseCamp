//
//  TouristInfoAreaCodeRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoAreaCodeRequestDTO: Codable, TouristInfoRequestDTO {
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let areaCode: String
  
  var toDictionary: [String: Any] {
    var dict: [String: Any] = [
      "numOfRows": 35,
      "pageNo": 1,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "areaCode": areaCode
    ]
    return dict
  }
  
  init(query: TouristInfoAreaCodeQuery) {
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.areaCode = query.areaCode.areaCode.string
  }
}
