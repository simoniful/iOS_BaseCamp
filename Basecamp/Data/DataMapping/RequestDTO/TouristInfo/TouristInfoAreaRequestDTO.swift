//
//  TouristInfoAreaRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoAreaRequestDTO: Codable, TouristInfoRequestDTO {
  let numOfRows: Int
  let pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let contentTypeId: String
  let areaCode: String
  let sigunguCode: String
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "listYN": "Y",
      "arrange": "Q",
      "contentTypeId": contentTypeId,
      "areaCode": areaCode,
      "sigunguCode": sigunguCode
    ]
    return dict
  }
  
  init(query: TouristInfoAreaQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.contentTypeId = query.contentTypeId.rawValue.string
    self.areaCode = query.areaCode.areaCode.string
    self.sigunguCode = query.sigunguCode.code ?? ""
  }
}
