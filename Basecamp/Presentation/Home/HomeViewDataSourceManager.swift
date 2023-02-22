//
//  HomeViewDataSourceManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import UIKit
import RxSwift
import RxDataSources

struct HomeViewDataSourceManager {
  static func homeDataSource(_ parent: HomeViewController) -> RxCollectionViewSectionedReloadDataSource<HomeSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
      configureCell: { [weak parent] dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.identifier, for: indexPath) as? HomeHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(completedCount: item.completedCampsiteCount, likedCount: item.likedCampsiteCount)
          cell.viewModel(item: item)?
            .bind(to: (parent?.viewModel.headerAction)!)
            .disposed(by: cell.disposeBag)
          return cell
        case .areaSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAreaCell.identifier, for: indexPath) as? HomeAreaCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(area: item.area)
          return cell
        case .campsiteKeywordSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCampsiteCell.identifier, for: indexPath) as? HomeCampsiteCell else { return UICollectionViewCell() }
          let item = items[indexPath.row]
          cell.setData(campsite: item)
          return cell
        case .campsiteThemeSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCampsiteCell.identifier, for: indexPath) as? HomeCampsiteCell else { return UICollectionViewCell() }
          let item = items[indexPath.row]
          cell.setData(campsite: item)
          return cell
        case .festivalSection(header: _, items: let items):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFestivalCell.identifier, for: indexPath) as? HomeFestivalCell else { return UICollectionViewCell() }
        let item = items[indexPath.row]
        cell.setData(touristInfo: item)
        return cell
      
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier, for: indexPath)
          return header
        case .areaSection(header: let headerStr, _),
             .campsiteKeywordSection(header: let headerStr, _),
             .campsiteThemeSection(header: let headerStr, _),
             .festivalSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier, for: indexPath) as? HomeSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        }
      }
    )
    return dataSource
  }
}
