//
//  TouristInfoCommonResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoCommonResponseDTO: Codable {
  let response: TouristInfoCommonResponseDTO_Response
}

struct TouristInfoCommonResponseDTO_Response: Codable {
  let header: TouristInfoResponseDTO_Header
  let body: TouristInfoCommonResponseDTO_Body
}

struct TouristInfoCommonResponseDTO_Body: Codable {
  let items: TouristInfoCommonResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

struct TouristInfoCommonResponseDTO_Items: Codable {
  let item: [TouristInfoCommonResponseDTO_Item]
}

struct TouristInfoCommonResponseDTO_Item: Codable {
  let contentId, contentTypeId, title, createdtime: String?
  let modifiedtime, tel, telname, homepage: String?
  let booktour: String?
  let firstimage, firstimage2: String?
  let areaCode, sigunguCode, cat1, cat2: String?
  let cat3, addr1, addr2, zipcode: String?
  let mapX, mapY, mlevel, overview: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case title, createdtime, modifiedtime, tel, telname, homepage, booktour
    case firstimage, firstimage2
    case areaCode = "areacode"
    case sigunguCode = "sigungucode"
    case cat1, cat2, cat3
    case addr1, addr2, zipcode
    case mapX = "mapx"
    case mapY = "mapy"
    case mlevel, overview
  }
}

extension TouristInfoCommonResponseDTO {
  func toDomain() -> [TouristInfoCommon] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension TouristInfoCommonResponseDTO_Item {
  func toDomain() -> TouristInfoCommon {
    .init(
      contentId: contentId,
      contentTypeId: contentTypeId,
      title: title,
      tel: tel,
      homepage: homepage,
      mainImage: firstimage,
      subImage: firstimage2,
      areaCode: areaCode,
      sigunguCode: sigunguCode,
      address: addr1,
      mapX: mapX,
      mapY: mapY,
      mlevel: mlevel,
      overview: overview
    )
  }
}






