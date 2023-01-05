//
//  CampsiteLocationRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct CampsiteLocationRequestDTO: Codable, CampsiteRequestDTO {
  var numOfRows: Int
  var pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  var mapX: String
  var mapY: String
  var radius: String
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "mapX": mapX,
      "mapY": mapY,
      "radius": radius
    ]
    return dict
  }
  
  init(query: CampsiteLocationQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.mapX = query.coordinate.longitude.string
    self.mapY = query.coordinate.latitude.string
    self.radius = query.radius.string
  }
}

