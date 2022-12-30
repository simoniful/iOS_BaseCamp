//
//  CampsiteImageListResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation

// MARK: - CampsiteImageListResponseDTO
struct CampsiteImageResponseDTO: Codable {
  let response: CampsiteImageResponseDTO_Response
}

// MARK: - Response
struct CampsiteImageResponseDTO_Response: Codable {
  let header: Header
  let body: CampsiteImageResponseDTO_Body
}

// MARK: - Body
struct CampsiteImageResponseDTO_Body: Codable {
  let items: CampsiteImageResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CampsiteImageResponseDTO_Items: Codable {
  let item: [CampsiteImageResponseDTO_Item]
}

// MARK: - Item
struct CampsiteImageResponseDTO_Item: Codable {
  let contentId, serialnum: String?
  let imageURL: String?
  let createdtime, modifiedtime: String?

  enum CodingKeys: String, CodingKey {
      case contentId, serialnum
      case imageURL = "imageUrl"
      case createdtime, modifiedtime
  }
}

extension CampsiteImageResponseDTO {
  func toDomain() -> [String] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension CampsiteImageResponseDTO_Item {
  func toDomain() -> String {
    guard let imageURL = imageURL else { return "" }
    return imageURL
  }
}



