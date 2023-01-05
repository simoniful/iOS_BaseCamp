//
//  YoutubeRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/05.
//

import Foundation

struct YoutubeRequestDTO: Codable {
  let part: String
  let key: String
  let q: String
  let maxResults: Int
  let type: String
  let videoEmbeddable: String
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "part": part,
      "key": key,
      "q": q,
      "maxResults": maxResults,
      "type": type,
      "videoEmbeddable": videoEmbeddable
    ]
    return dict
  }
  
  init(query: YoutubeQuery) {
    self.part = query.part
    self.key = query.key
    self.q = query.q
    self.maxResults = query.maxResults
    self.type = query.type
    self.videoEmbeddable = query.videoEmbeddable
  }
}
