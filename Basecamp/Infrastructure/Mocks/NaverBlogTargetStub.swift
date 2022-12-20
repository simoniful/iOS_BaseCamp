//
//  NaverBlogTargetStub.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

extension NaverBlogTarget {
  func stubData(_ target: NaverBlogTarget) -> Data {
    switch self {
    case .getNaverBlog:
      return Data("a".utf8)
    }
  }
}
