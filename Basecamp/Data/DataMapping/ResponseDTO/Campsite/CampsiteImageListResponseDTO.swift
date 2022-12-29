//
//  CampsiteImageListResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation

// MARK: - CampsiteImageListResponseDTO
struct CampsiteImageListResponseDTO: Codable {
  let response: CampsiteImageListResponseDTO_Response
}

// MARK: - Response
struct CampsiteImageListResponseDTO_Response: Codable {
  let header: Header
  let body: CampsiteImageListResponseDTO_Body
}

// MARK: - Body
struct CampsiteImageListResponseDTO_Body: Codable {
  let items: CampsiteImageListResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CampsiteImageListResponseDTO_Items: Codable {
  let item: [CampsiteImageListResponseDTO_Item]
}

// MARK: - Item
struct CampsiteImageListResponseDTO_Item: Codable {
  let contentID, serialnum: String?
  let imageURL: String?
  let createdtime, modifiedtime: String?

  enum CodingKeys: String, CodingKey {
      case contentID = "contentId"
      case serialnum
      case imageURL = "imageUrl"
      case createdtime, modifiedtime
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.contentID = try? container.decodeIfPresent(String.self, forKey: .contentID)
    self.serialnum = try? container.decodeIfPresent(String.self, forKey: .serialnum)
    self.imageURL = try? container.decodeIfPresent(String.self, forKey: .imageURL)
    self.createdtime = try? container.decodeIfPresent(String.self, forKey: .createdtime)
    self.modifiedtime = try? container.decodeIfPresent(String.self, forKey: .modifiedtime)
  }
}

extension CampsiteImageListResponseDTO {
  func toDomain() -> [String] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension CampsiteImageListResponseDTO_Item {
  func toDomain() -> String {
    guard let imageURL = imageURL else { return "" }
    return imageURL
  }
}



