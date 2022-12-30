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
  case areaSection(items: [HomeAreaItem])
  case campsiteSection(header: String, items:[Campsite])
  case festivalSection(items: [TouristInfo])
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
      case .campsiteSection(let header, _):
          return header
      default:
          return nil
      }
  }

  var items: [Item] {
    switch self {
    case .headerSection(items: let items):
      return items
    case .areaSection(items: let items):
      return items
    case .campsiteSection(_, items: let items):
      return items
    case .festivalSection(items: let items):
      return items
    }
  }
}
