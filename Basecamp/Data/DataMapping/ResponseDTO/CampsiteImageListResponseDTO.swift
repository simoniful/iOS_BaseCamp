//
//  CampsiteImageListResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation

// MARK: - CampsiteImageListResponseDTO
struct CampsiteImageListResponseDTO: Codable {
  let response: CampsiteImageListResponseDTOResponse
}

// MARK: - Response
struct CampsiteImageListResponseDTOResponse: Codable {
  let header: Header
  let body: CampsiteImageListResponseDTOBody
}

// MARK: - Body
struct CampsiteImageListResponseDTOBody: Codable {
  let items: CampsiteImageListResponseDTOItems
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CampsiteImageListResponseDTOItems: Codable {
  let item: [CampsiteImageListResponseDTOItem]
}

// MARK: - Item
struct CampsiteImageListResponseDTOItem: Codable {
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

extension CampsiteImageListResponseDTOItem {
  func toDomain() -> String {
    guard let imageURL = imageURL else { return "" }
    return imageURL
  }
}



