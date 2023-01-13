//
//  PropertyIterable.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/13.
//

import Foundation

protocol PropertyIterable {
  func allProperties(limit: Int) -> [String: Any]
}

extension PropertyIterable {
  func allProperties(limit: Int = Int.max) -> [String: Any] {
    return props(obj: self, count: 0, limit: limit)
  }
  
  private func props(obj: Any, count: Int, limit: Int) -> [String: Any] {
    let mirror = Mirror(reflecting: obj)
    var result: [String: Any] = [:]
    for (prop, val) in mirror.children {
      guard let prop = prop else { continue }
      if limit == count {
        result[prop] = val
      } else {
        let subResult = props(obj: val, count: count + 1, limit: limit)
        result[prop] = subResult.count == 0 ? val : subResult
      }
    }
    return result
  }
}
