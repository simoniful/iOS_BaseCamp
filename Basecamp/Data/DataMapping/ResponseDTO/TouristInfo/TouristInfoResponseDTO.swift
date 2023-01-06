//
//  TouristInfoResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoResponseDTO: Codable {
  let response: TouristInfoResponseDTO_Response
}

struct TouristInfoResponseDTO_Response: Codable {
  let header: TouristInfoResponseDTO_Header
  let body: TouristInfoResponseDTO_Body
}

struct TouristInfoResponseDTO_Header: Codable {
    let resultCode, resultMsg: String?
}

struct TouristInfoResponseDTO_Body: Codable {
  let items: TouristInfoResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

struct TouristInfoResponseDTO_Items: Codable {
  let item: [TouristInfoResponseDTO_Item]
}

struct TouristInfoResponseDTO_Item: Codable {
  let addr1, addr2, areaCode, booktour: String?
  let cat1, cat2, cat3, contentId: String?
  let contentTypeId, createdtime, dist: String?
  let firstimage, firstimage2: String?
  let mapX, mapY, mlevel, modifiedtime: String?
  let readcount: Int?
  let sigunguCode, tel, title: String?
  let eventStartDate, eventEndDate: String?
  
  enum CodingKeys: String, CodingKey {
    case addr1, addr2
    case areaCode = "areacode"
    case booktour, cat1, cat2, cat3
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case createdtime, dist, firstimage, firstimage2
    case mapX = "mapx"
    case mapY = "mapy"
    case mlevel, modifiedtime, readcount
    case sigunguCode = "sigungucode"
    case tel, title
    case eventStartDate = "eventstartdate"
    case eventEndDate = "eventenddate"
  }
}

extension TouristInfoResponseDTO {
  func toDomain() -> [TouristInfo] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension TouristInfoResponseDTO_Item {
  func toDomain() -> TouristInfo {
    .init(
      address: addr1,
      areaCode: areaCode,
      contentId: contentId,
      contentTypeId: contentTypeId,
      dist: dist,
      mainImage: firstimage,
      subImage: firstimage2,
      mapX: mapX,
      mapY: mapY,
      mlevel: mlevel,
      readcount: readcount,
      sigunguCode: sigunguCode,
      tel: tel,
      title: title,
      eventStartDate: eventStartDate?.toDate(),
      eventEndDate: eventEndDate?.toDate()
    )
  }
}
