//
//  TouristInfoRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

enum TouristInfoContentType: Int, CaseIterable {
  case touristSpot = 12
  case cultureFacilities = 14
  case festival = 15
  case leisure = 28
  case stay = 32
  case shoppingSpot = 38
  case restaurant = 39
  
  var koreanTitle: String {
    switch self {
    case .touristSpot:
      return "관광지"
    case .cultureFacilities:
      return "문화시설"
    case .festival:
      return "축제/행사"
    case .leisure:
      return "레저"
    case .stay:
      return "숙소"
    case .shoppingSpot:
      return "쇼핑"
    case .restaurant:
      return "맛집"
    }
  }
}

struct TouristInfoRequestDTO: Codable {
  var toDictionary: [String: Any] {
    return makeDictionary()
  }
  
  let moblieOS: String
  let mobileApp: String
  let serviceKey: String
  
  var numOfRows: Int?
  var pageNo: Int?
  
  let contentTypeId: Int?
  
  let areaCode: Int?
  let sigunguCode: Int?
  
  var mapX: Double?
  var mapY: Double?
  var radius: Int?
  
  let keyword: String?
  
  let contentId: Int?
  
  let eventStartDate: String?
  let eventEndDate: String?
  
  init(touristInfoQueryType: TouristInfoQueryType) {
    switch touristInfoQueryType {
    case .region(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.contentTypeId = contentTypeId.rawValue
      self.areaCode = areaCode
      self.sigunguCode = sigunguCode
    case .location(let numOfRows, let pageNo, let contentTypeId, let coordinate, let radius):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.contentTypeId = contentTypeId.rawValue
      self.mapX = coordinate.longitude
      self.mapY = coordinate.latitude
      self.radius = radius
    case .keyword(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode, let keyword):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.contentTypeId = contentTypeId.rawValue
      self.areaCode = areaCode
      self.sigunguCode = sigunguCode
      self.keyword = keyword
    case .festival(let numOfRows, let pageNo, let areaCode, let sigunguCode, let eventStartDate, let eventEndDate):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.areaCode = areaCode
      self.sigunguCode = sigunguCode
      self.eventStartDate = eventStartDate
      self.eventEndDate = eventEndDate
    case .stay(let numOfRows, let pageNo, let areaCode, let sigunguCode):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.areaCode = areaCode
      self.sigunguCode = sigunguCode
    case .commonInfo(let contentId, let contentTypeId),
         .introInfo(let contentId, let contentTypeId),
         .detailInfo(let contentId, let contentTypeId):
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.contentId = contentId
      self.contentTypeId = contentTypeId.rawValue
    case .imageList(let contentId):
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.contentId = contentId
    case .regionCode(let numOfRows, let pageNo, let areaCode):
      self.numOfRows = numOfRows
      self.pageNo = pageNo
      self.moblieOS = touristInfoQueryType.query.mobileOS
      self.mobileApp = touristInfoQueryType.query.moblieApp
      self.serviceKey = touristInfoQueryType.query.serviceKey
      self.areaCode = areaCode
    }
  }
}

private extension TouristInfoRequestDTO {
  func makeDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      "mobileOS": moblieOS,
      "mobileApp": mobileApp,
      "serviceKey": serviceKey,
      "_type": "json"
    ]
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let contentTypeId = self.contentTypeId,
       let areaCode = self.areaCode,
       let sigunguCode = self.sigunguCode {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["contentTypeId"] = contentTypeId
      dict["areaCode"] = areaCode
      dict["sigunguCode"] = sigunguCode
    }
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let contentTypeId = self.contentTypeId,
       let mapX = self.mapX,
       let mapY = self.mapY,
       let radius = self.radius {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["contentTypeId"] = contentTypeId
      dict["mapX"] = mapX
      dict["mapY"] = mapY
      dict["radius"] = radius
    }
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let contentTypeId = self.contentTypeId,
       let areaCode = self.areaCode,
       let sigunguCode = self.sigunguCode,
       let keyword = self.keyword {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["contentTypeId"] = contentTypeId
      dict["areaCode"] = areaCode
      dict["sigunguCode"] = sigunguCode
      dict["keyword"] = keyword
    }
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let areaCode = self.areaCode,
       let sigunguCode = self.sigunguCode,
       let eventStartDate = self.eventStartDate,
       let eventEndDate = self.eventEndDate {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["areaCode"] = areaCode
      dict["sigunguCode"] = sigunguCode
      dict["eventStartDate"] = eventStartDate
      dict["eventEndDate"] = eventEndDate
    }
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let areaCode = self.areaCode,
       let sigunguCode = self.sigunguCode {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["areaCode"] = areaCode
      dict["sigunguCode"] = sigunguCode
    }
    
    if let contentId = self.contentId,
       let contentTypeId = self.contentTypeId {
      dict["contentId"] = contentId
      dict["contentTypeId"] = contentTypeId
    }
    
    if let contentId = self.contentId {
      dict["contentId"] = contentId
    }
    
    if let numOfRows = self.numOfRows,
       let pageNo = self.pageNo,
       let areaCode = self.areaCode {
      dict["numOfRows"] = numOfRows
      dict["pageNo"] = pageNo
      dict["areaCode"] = areaCode
    }
    
    return dict
  }
}
