//
//  FilterItem.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct FilterItem: IdentifiableType, Equatable {
  var identity: String {
    return UUID().uuidString
  }
  
  var title: String?
  var selected: Bool = false
}

extension FilterItem {
  static let empty = FilterItem(title: "")
  
  mutating func updateValue(item: FilterItem) {
    self.title = item.title
    self.selected = item.selected
  }
}

struct FilterSubSection {
  var header: String
  var items: [Item]
}

extension FilterSubSection : AnimatableSectionModelType {
  typealias Item = FilterItem
  var identity: String {
    return header
  }
  
  init(original: FilterSubSection, items: [Item]) {
    self = original
    self.items = items
  }
}
