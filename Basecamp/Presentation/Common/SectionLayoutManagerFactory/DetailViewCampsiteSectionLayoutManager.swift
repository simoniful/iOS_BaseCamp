//
//  DetailViewCampsiteSectionLayoutManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import UIKit

struct DetailViewCampsiteSectionLayoutManager: SectionLayoutManager {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        return makeSection(
          itemType: .whole(ratio: 0.7),
          groupType: .whole(ratio: 0.7),
          sectionInset: NSDirectionalEdgeInsets(
            top: 0.0, leading: 0.0, bottom: 16.0, trailing: 0.0
          ),
          containHeader: false
        )
      case 1:
        return makeSection(
          itemType: .whole(ratio: 0.55),
          groupType: .whole(ratio: 0.55)
        )
      case 2:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .fractionalWidth(1)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .estimated(60),
              heightDimension: .estimated(90)
            )
          ),
          orthogonal: .continuous
        )
      case 3:
        return makeSection(
          itemType: .whole(ratio: 1.0),
          groupType: .whole(ratio: 1.0),
          containHeader: false
        )
      case 4:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(100.0)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .estimated(.greatestFiniteMagnitude)
            )
          ),
          sectionInset: .init(
            top: 16.0, leading: 16.0, bottom: 32.0, trailing: 16.0
          ),
          interGroupSpacing: 8.0
        )
      case 5:
        return makeSection(
          itemType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .absolute(364.0)
            )
          ),
          groupType: .specific(
            size: .init(
              widthDimension: .fractionalWidth(1),
              heightDimension: .absolute(364.0)
            )
          )
        )
      case 6:
        return self.imageSection()
      default:
        return makeSection(
          itemType: .whole(ratio: 0.7),
          groupType: .whole(ratio: 0.7)
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
  
  func imageSection() -> NSCollectionLayoutSection {
    let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
    mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
    pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

    let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)

    let mainWithTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])
    
    let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
    tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
    let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitem: tripleItem, count: 3)
    
    let mainWithReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
    
    let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [mainWithTrailingGroup, tripleGroup, mainWithReversedGroup])

    let section = NSCollectionLayoutSection(group: nestedGroup)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    section.boundarySupplementaryItems = [header]
    return section
  }
}


