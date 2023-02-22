//
//  HomeViewSectionLayoutManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import UIKit

struct HomeViewSectionLayoutManager: SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(Size.screenH / 3)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(Size.screenH / 3)
            )
          )
          ,containHeader: false
        )
      case 1:
        return self.areaSection()
      case 4:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalHeight(1.0)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(0.45),
              heightDimension: .fractionalWidth(0.6)
            )
          ),
          sectionInset: .init(
            top: 16.0, leading: 16.0, bottom: 32.0, trailing: 16.0
          ),
          interGroupSpacing:  8.0,
          orthogonal: .continuous
        )
      default:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalHeight(1.0)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(0.6),
              heightDimension: .fractionalWidth(0.45)
            )
          ),
          sectionInset: .init(
            top: 16.0, leading: 16.0, bottom: 32.0, trailing: 16.0
          ),
          interGroupSpacing:  8.0,
          orthogonal: .continuous
        )
      }
    }
  }
  
  func makeSection(
    itemType: ItemType,
    groupType: GroupType,
    sectionInset: NSDirectionalEdgeInsets = .init(
      top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0
    ),
    interGroupSpacing: CGFloat = 0.0,
    orthogonal: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
    containHeader: Bool = true
  ) -> NSCollectionLayoutSection {
    let item = itemType.item
    let groupSize = groupType.groupSize
    
    var group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = sectionInset
    section.orthogonalScrollingBehavior = orthogonal
    section.interGroupSpacing = interGroupSpacing
    
    if containHeader {
      let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))

      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [header]
    }
    return section
  }
  
  func areaSection() -> NSCollectionLayoutSection {
    let estimatedHeight: CGFloat = 50
    let estimatedWidth: CGFloat = (UIScreen.main.bounds.width - 8 * 5) / 6
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                          heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .estimated(estimatedHeight))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitem: item, count: 6)
    group.interItemSpacing = .fixed(8.0)
  
    let section = NSCollectionLayoutSection(group: group)
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerFooterSize,
           elementKind: UICollectionView.elementKindSectionHeader,
           alignment: .top
         )
    section.boundarySupplementaryItems = [header]
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 32.0, trailing: 16.0)
    return section
  }
}

