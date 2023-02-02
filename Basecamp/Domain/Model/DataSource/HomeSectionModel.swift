//
//  HomeSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation
import RxDataSources

enum HomeSectionModel {
  case headerSection(items: [HomeHeaderItem])
  case areaSection(header: String, items: [HomeAreaItem])
  case campsiteKeywordSection(header: String, items:[Campsite])
  case campsiteThemeSection(header: String, items:[Campsite])
  case festivalSection(header: String, items: [TouristInfo])
}

protocol HomeItem {}

struct HomeHeaderItem: HomeItem {
  var completedCampsiteCount: Int
  var likedCampsiteCount: Int
}

struct HomeAreaItem: HomeItem {
  var area: Area
}

extension HomeSectionModel: SectionModelType {
  typealias Item = HomeItem
  
  init(original: HomeSectionModel, items: [Item]) {
    self = original
  }
  
  var headers: String? {
      switch self {
      case .areaSection(let header, _),
           .campsiteKeywordSection(let header, _),
           .campsiteThemeSection(let header, _),
           .festivalSection(let header, _):
        return header
      default:
          return nil
      }
  }

  var items: [Item] {
    switch self {
    case .headerSection(let items):
      return items
    case .areaSection(_, let items):
      return items
    case .campsiteKeywordSection(_, let items):
      return items
    case .campsiteThemeSection(_, let items):
      return items
    case .festivalSection(_, let items):
      return items
    }
  }
}
