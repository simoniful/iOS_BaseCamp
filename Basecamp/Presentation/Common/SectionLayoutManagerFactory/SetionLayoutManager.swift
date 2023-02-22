//
//  SetionLayoutManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import UIKit

protocol SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout
  func makeSection(
    itemType: ItemType,
    groupType: GroupType,
    sectionInset: NSDirectionalEdgeInsets,
    interGroupSpacing: CGFloat,
    orthogonal: UICollectionLayoutSectionOrthogonalScrollingBehavior,
    containHeader: Bool
  ) -> NSCollectionLayoutSection
}
