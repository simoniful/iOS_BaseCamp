//
//  String.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/31.
//

import Foundation

extension String {
  func decodeUrl() -> String {
    return self.removingPercentEncoding!
  }
  
  func encodeUrl() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
  }
}
