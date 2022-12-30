//
//  CampsiteBasicRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct CampsiteBasicRequestDTO: Codable, CampsiteRequestDTO {
  var numOfRows: Int
  var pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  
  var toDictionary: [String: Any] {
    var dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json"
    ]
    return dict
  }
  
  init(query :CampsiteBasicQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
  }
}
