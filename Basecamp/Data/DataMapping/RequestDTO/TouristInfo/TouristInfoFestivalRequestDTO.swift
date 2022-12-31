//
//  TouristInfoFestivalRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoFestivalRequestDTO: Codable, TouristInfoRequestDTO {
  let numOfRows: Int
  let pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let areaCode: String
  let sigunguCode: String
  let eventStartDate: String
  var eventEndDate: String
  
  var toDictionary: [String: Any] {
    var dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "listYN": "Y",
      "arrange": "Q",
      "areaCode": areaCode,
      "sigunguCode": sigunguCode,
      "eventStartDate": eventStartDate,
      "eventEndDate": eventEndDate
    ]
    return dict
  }
  
  init(query: TouristInfoFestivalQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.areaCode = query.areaCode?.areaCode.string ?? ""
    self.sigunguCode = query.sigunguCode?.code ?? ""
    self.eventStartDate = query.eventStartDate.toString(format: "yyyyMMdd")
    self.eventEndDate = query.eventEndDate.toString(format: "yyyyMMdd")
  }
}


