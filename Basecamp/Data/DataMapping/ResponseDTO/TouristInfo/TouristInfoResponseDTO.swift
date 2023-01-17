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
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.addr1 = try container.decodeIfPresent(String.self, forKey: .addr1)
    self.addr2 = try container.decodeIfPresent(String.self, forKey: .addr2)
    self.areaCode = try container.decodeIfPresent(String.self, forKey: .areaCode)
    self.booktour = try container.decodeIfPresent(String.self, forKey: .booktour)
    self.cat1 = try container.decodeIfPresent(String.self, forKey: .cat1)
    self.cat2 = try container.decodeIfPresent(String.self, forKey: .cat2)
    self.cat3 = try container.decodeIfPresent(String.self, forKey: .cat3)
    self.contentId = try container.decodeIfPresent(String.self, forKey: .contentId)
    self.contentTypeId = try container.decodeIfPresent(String.self, forKey: .contentTypeId)
    self.createdtime = try container.decodeIfPresent(String.self, forKey: .createdtime)
    self.dist = try container.decodeIfPresent(String.self, forKey: .dist)
    self.firstimage = try container.decodeIfPresent(String.self, forKey: .firstimage)
    self.firstimage2 = try container.decodeIfPresent(String.self, forKey: .firstimage2)
    self.mapX = try container.decodeIfPresent(String.self, forKey: .mapX)
    self.mapY = try container.decodeIfPresent(String.self, forKey: .mapY)
    self.mlevel = try container.decodeIfPresent(String.self, forKey: .mlevel)
    self.modifiedtime = try container.decodeIfPresent(String.self, forKey: .modifiedtime)
    self.readcount = try container.decodeIfPresent(Int.self, forKey: .readcount)
    self.sigunguCode = try container.decodeIfPresent(String.self, forKey: .sigunguCode)
    self.tel = try container.decodeIfPresent(String.self, forKey: .tel)
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    self.eventStartDate = try? container.decodeIfPresent(String.self, forKey: .eventStartDate)
    self.eventEndDate = try? container.decodeIfPresent(String.self, forKey: .eventEndDate)
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
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
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
