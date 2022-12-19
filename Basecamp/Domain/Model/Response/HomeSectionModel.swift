//
//  HomeSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation
import RxDataSources

enum HomeSectionModel {
  case HeaderSection(items: [HomeHeaderItem])
  case RegionSection(items: [HomeRegionItem])
  case placeSection(header: String, items:[Campsite])
  case eventSection(items: [Festival])
}

protocol HomeItem {}

struct HomeHeaderItem: HomeItem {
  var completedPlaceCount: Int
  var likedPlaceCount: Int
}

struct HomeRegionItem: HomeItem {
  var region: Region
}

extension HomeSectionModel: SectionModelType {
  typealias Item = HomeItem
  
  init(original: HomeSectionModel, items: [Item]) {
    self = original
  }
  
  var headers: String? {
      switch self {
      case .placeSection(let header, _):
          return header
      default:
          return nil
      }
  }

  var items: [Item] {
    switch self {
    case .HeaderSection(items: let items):
      return items
    case .RegionSection(items: let items):
      return items
    case .placeSection(_, items: let items):
      return items
    case .eventSection(items: let items):
      return items
    }
  }
}
