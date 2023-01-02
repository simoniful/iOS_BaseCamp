//
//  TouristInfoLocationRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct TouristInfoLocationRequestDTO: Codable, TouristInfoRequestDTO {
  let numOfRows: Int
  let pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  let contentTypeId: String
  let mapX: String
  let mapY: String
  let radius: String
  
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
      "mapX": mapX,
      "mapY": mapY,
      "radius": radius
    ]
    return dict
  }
  
  init(query: TouristInfoLocationQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.contentTypeId = query.contentTypeId.rawValue.string
    self.mapX = query.coordinate.longitude.string
    self.mapY = query.coordinate.latitude.string
    self.radius = query.radius.string
  }
}
