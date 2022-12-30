//
//  TouristInfoImageResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoImageResponseDTO: Codable {
  let response: TouristInfoImageResponseDTO_Response
}

// MARK: - Response
struct TouristInfoImageResponseDTO_Response: Codable {
  let header: Header
  let body: TouristInfoImageResponseDTO_Body
}

// MARK: - Body
struct TouristInfoImageResponseDTO_Body: Codable {
  let items: TouristInfoImageResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct TouristInfoImageResponseDTO_Items: Codable {
  let item: [TouristInfoImageResponseDTO_Item]
}

// MARK: - Item
struct TouristInfoImageResponseDTO_Item: Codable {
  let contentId: String?
  let originImageUrl: String?
  let imageName, serialnum: String?

  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case originImageUrl = "originimgurl"
    case imageName = "imgname"
    case serialnum
  }
}

extension TouristInfoImageResponseDTO {
  func toDomain() -> [String] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension TouristInfoImageResponseDTO_Item {
  func toDomain() -> String {
    guard let originImageUrl = originImageUrl else { return "" }
    return originImageUrl
  }
}
