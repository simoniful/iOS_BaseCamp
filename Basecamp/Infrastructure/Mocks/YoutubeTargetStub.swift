//
//  YoutubeTargetStub.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

extension YoutubeTarget {
  func stubData(_ target: YoutubeTarget) -> Data {
    switch self {
    case .getYoutube:
      return Data("a".utf8)
    }
  }
}
