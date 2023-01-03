//
//  NaverBlogQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

enum NaverBlogQueryType {
  case basic(keyword: String, display: Int)
  
  var query: NaverBlogQuery {
    switch self {
    case .basic(let keyword, let display):
      return NaverBlogQuery(
        query: keyword,
        display: display
      )
    }
  }
}

struct NaverBlogQuery {
  var query: String
  var display: Int
}


