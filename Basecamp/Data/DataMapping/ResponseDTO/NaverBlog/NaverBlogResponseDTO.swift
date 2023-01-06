//
//  NaverBlogResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/05.
//

import Foundation

// MARK: - NaverBlogResponseDTO
struct NaverBlogResponseDTO: Codable {
    let lastBuildDate: String?
    let total, start, display: Int?
    let items: [NaverBlogResponseDTO_Item]?
}

// MARK: - Item
struct NaverBlogResponseDTO_Item: Codable {
  let title: String?
  let link: String?
  let itemDescription, bloggername, bloggerlink, postdate: String?
  
  enum CodingKeys: String, CodingKey {
    case title, link
    case itemDescription = "description"
    case bloggername, bloggerlink, postdate
  }
}

extension NaverBlogResponseDTO {
  func toDomain(keyword: String) -> [NaverBlogInfo] {
    return items?.map {
      $0.toDomain()
    } ?? [NaverBlogInfo(type: "naverBlog",
                        title: keyword,
                        url: "https://section.blog.naver.com/Search/Post.naver?pageNo=1&rangeType=ALL&orderBy=sim&keyword=\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                        description: "블로그 검색 결과창으로 이동")]
  }
}

extension NaverBlogResponseDTO_Item {
  func toDomain() -> NaverBlogInfo {
    .init(
      type: "naverBlog",
      title: title,
      url: link,
      description: itemDescription
    )
  }
}
