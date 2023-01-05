//
//  NaverBlogRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/05.
//

import Foundation

struct NaverBlogRequestDTO: Codable {
  let query: String
  let display: Int
  
  var toDictionary: [String: Any] {
    let dict: [String: Any] = [
      "query": query,
      "display": display
    ]
    return dict
  }
  
  init(query: NaverBlogQuery) {
    self.query = query.query
    self.display = query.display
  }
}
