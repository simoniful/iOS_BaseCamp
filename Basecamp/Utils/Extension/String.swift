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
  
  func changeHtmlTag() -> String {
      let convertStr = self
          .replacingOccurrences(of: "<b>", with: "")
          .replacingOccurrences(of: "</b>", with: "")
          .replacingOccurrences(of: "&amp;", with: "&")
          .replacingOccurrences(of: "&nbsp;", with: " ")
          .replacingOccurrences(of: "&lt;", with: "<")
          .replacingOccurrences(of: "&gt;", with: ">")
          .replacingOccurrences(of: "&quot;", with: "\"")
          .replacingOccurrences(of: "&#035;", with: "#")
          .replacingOccurrences(of: "&#039;", with: "\'")
      return convertStr
  }
  
  var htmlToAttributedString: NSAttributedString? {
          guard let data = data(using: .utf8) else { return nil }
          do {
              return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
          } catch {
              return nil
          }
      }
      var htmlToString: String {
          return htmlToAttributedString?.string ?? ""
      }

}
