//
//  CampsiteImageRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

struct CampsiteImageRequestDTO: Codable, CampsiteRequestDTO {
  var numOfRows: Int
  var pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  var contentId: String
  
  var toDictionary: [String: Any] {
    var dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json",
      "contentId": contentId
    ]
    return dict
  }
  
  init(query: CampsiteImageQuery) {
    self.numOfRows = query.numOfRows
    self.pageNo = query.pageNo
    self.moblieOS = query.mobileOS
    self.mobileApp = query.moblieApp
    self.serviceKey = query.serviceKey
    self.contentId = query.contentId.string
  }
}
