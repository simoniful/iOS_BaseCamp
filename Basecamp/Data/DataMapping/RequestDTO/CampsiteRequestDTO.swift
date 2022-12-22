//
//  CampsiteRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

struct CampsiteRequestDTO: Codable {
  var toDictionary: [String: Any] {
    return makeDictionary()
  }
  
  let numOfRows: Int
  let pageNo: Int
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  
  let mapX: Double?
  let mapY: Double?
  let radius: Int?
  
  let keyword: String?
  
  let contentId: Int?
  
  init(campsiteQueryType: CampsiteQueryType) {
    switch campsiteQueryType {
    case .basic(numOfRows: let numOfRows, pageNo: let pageNo):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = campsiteQueryType.query.mobileOS
      self.mobileApp = campsiteQueryType.query.moblieApp
      self.serviceKey = campsiteQueryType.query.serviceKey
    case .location(numOfRows: let numOfRows, pageNo: let pageNo, coordinate: let coordinate, radius: let radius):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = campsiteQueryType.query.mobileOS
      self.mobileApp = campsiteQueryType.query.moblieApp
      self.serviceKey = campsiteQueryType.query.serviceKey
      self.mapX = coordinate.longitude
      self.mapY = coordinate.latitude
      self.radius = radius
    case .keyword(numOfRows: let numOfRows, pageNo: let pageNo, keyword: let keyword):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = campsiteQueryType.query.mobileOS
      self.mobileApp = campsiteQueryType.query.moblieApp
      self.serviceKey = campsiteQueryType.query.serviceKey
      self.keyword = keyword
    case .imageList(numOfRows: let numOfRows, pageNo: let pageNo, conteneId: let conteneId):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = campsiteQueryType.query.mobileOS
      self.mobileApp = campsiteQueryType.query.moblieApp
      self.serviceKey = campsiteQueryType.query.serviceKey
      self.contentId = conteneId
    }
  }
}

private extension CampsiteRequestDTO {
  func makeDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json"
    ]
    
    if let mapX = self.mapX,
       let mapY = self.mapY,
       let radius = self.radius {
      dict["mapX"] = mapX
      dict["mapY"] = mapY
      dict["radius"] = radius
    }
    
    if let keyword = self.keyword {
      dict["keyword"] = keyword
    }
    
    if let contentId = self.contentId {
      dict["contentId"] = contentId
    }
    
    return dict
  }
}
