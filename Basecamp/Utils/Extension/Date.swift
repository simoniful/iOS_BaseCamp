//
//  Date.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/30.
//

import Foundation

extension Date {
  func toString(format: String = "yyyy-MM-dd") -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  func addMonths(numberOfMonths: Int) -> Date {
    let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
    return endDate ?? Date()
  }
}
