//
//  TouristInfoAreaCodeResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoAreaCodeResponseDTO: Codable {
  let response: TouristInfoAreaCodeResponseDTO_Response
}

// MARK: - Response
struct TouristInfoAreaCodeResponseDTO_Response: Codable {
  let header: TouristInfoResponseDTO_Header
  let body: TouristInfoAreaCodeResponseDTO_Body
}

// MARK: - Body
struct TouristInfoAreaCodeResponseDTO_Body: Codable {
  let items: TouristInfoAreaCodeResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct TouristInfoAreaCodeResponseDTO_Items: Codable {
  let item: [TouristInfoAreaCodeResponseDTO_Item]
}

// MARK: - Item
struct TouristInfoAreaCodeResponseDTO_Item: Codable {
  let rnum: Int?
  let code, name: String?
}

extension TouristInfoAreaCodeResponseDTO {
  func toDomain() -> [Sigungu] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension TouristInfoAreaCodeResponseDTO_Item {
  func toDomain() -> Sigungu {
    return .init(rnum: rnum, code: code, name: name)
  }
}
