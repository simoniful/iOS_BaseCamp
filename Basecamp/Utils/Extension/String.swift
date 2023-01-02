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
  
  func toDate(withFormat format: String = "yyyyMMdd") -> Date? {
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone(abbreviation: "KST")
      dateFormatter.locale = Locale(identifier: "ko_KR")
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.dateFormat = format
      let date = dateFormatter.date(from: self)

      return date
  }
}
