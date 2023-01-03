//
//  YoutubeQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

enum YoutubeQueryType {
  case basic(keyword: String, maxResults: Int)
  
  var query: YoutubeQuery {
    switch self {
    case .basic(let keyword, let maxResults):
      return YoutubeQuery(
        key: APIKey.youtube.rawValue,
        q: keyword,
        maxResults: maxResults
      )
    }
  }
}

struct YoutubeQuery {
  var part: String = "snippet"
  var key: String
  var q: String
  var maxResults: Int
  var type: String = "video"
  var videoEmbeddable: String = "true"
}


