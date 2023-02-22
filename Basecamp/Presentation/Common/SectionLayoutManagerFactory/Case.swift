//
//  Case.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import UIKit

enum SectionLayoutManagerType {
  case home
  case campsiteDetail
  case touristInfoDetail
}

enum ItemType {
  case whole(ratio: CGFloat)
  case specific(size :NSCollectionLayoutSize)
  
  var item: NSCollectionLayoutItem {
    switch self {
    case .whole(let ratio):
      let item = NSCollectionLayoutItem(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(Size.screenH * ratio)
        )
      )
      return item
    case .specific(let size):
      let item = NSCollectionLayoutItem(layoutSize: size)
      return item
    }
  }
}

enum GroupFlow {
  case vertical
  case horizontal
}

enum GroupType {
  case whole(ratio: CGFloat)
  case specific(size :NSCollectionLayoutSize)
  
  var groupSize: NSCollectionLayoutSize {
    switch self {
    case .whole(let ratio):
      return NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(Size.screenH * ratio)
      )
    case .specific(let size):
      return size
    }
  }
}
