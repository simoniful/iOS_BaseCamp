//
//  YoutubeResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/05.
//

import Foundation

// MARK: - YoutubeResponseDTO
struct YoutubeResponseDTO: Codable {
  let kind, etag, nextPageToken, regionCode: String?
  let pageInfo: YoutubeResponseDTO_PageInfo?
  let items: [YoutubeResponseDTO_Item]?
}

// MARK: - Item
struct YoutubeResponseDTO_Item: Codable {
    let kind, etag: String?
    let id: YoutubeResponseDTO_ID?
    let snippet: YoutubeResponseDTO_Snippet?
  
}

// MARK: - ID
struct YoutubeResponseDTO_ID: Codable {
    let kind, videoId: String?
}

// MARK: - Snippet
struct YoutubeResponseDTO_Snippet: Codable {
    let publishedAt: String?
    let channelId, title, snippetDescription: String?
    let thumbnails: YoutubeResponseDTO_Thumbnails?
    let channelTitle, liveBroadcastContent: String?
    let publishTime: String?
  
  enum CodingKeys: String, CodingKey {
    case publishedAt, channelId, title
    case snippetDescription = "description"
    case thumbnails, channelTitle, liveBroadcastContent, publishTime
  }
}

// MARK: - Thumbnails
struct YoutubeResponseDTO_Thumbnails: Codable {
  let thumbnailsDefault, medium, high: YoutubeResponseDTO_Default?
  
  enum CodingKeys: String, CodingKey {
    case thumbnailsDefault = "default"
    case medium, high
  }
}

// MARK: - Default
struct YoutubeResponseDTO_Default: Codable {
    let url: String?
    let width, height: Int?
}

// MARK: - PageInfo
struct YoutubeResponseDTO_PageInfo: Codable {
    let totalResults, resultsPerPage: Int?
}

extension YoutubeResponseDTO {
  func toDomain(keyword: String) -> [YoutubeInfo] {
    return items?.map {
      $0.toDomain()
    } ?? [YoutubeInfo(type: "youtube",
                      title: keyword,
                      url: "https://www.youtube.com/results?search_query=\(keyword)",
                      description: "YouTube 검색 결과창으로 이동",
                      thumbnailUrl: "")]
  }
}

extension YoutubeResponseDTO_Item {
  func toDomain() -> YoutubeInfo {
    .init(
      type: "youtube",
      title: snippet?.title,
      url: "https://www.youtube.com/watch?v=" + (id?.videoId)!,
      description: snippet?.snippetDescription,
      thumbnailUrl: snippet?.thumbnails?.thumbnailsDefault?.url
    )
  }
}
