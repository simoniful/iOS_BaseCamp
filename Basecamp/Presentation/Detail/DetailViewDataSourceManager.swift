//
//  DetailViewDataSourceManager.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/13.
//

import UIKit
import RxSwift
import RxDataSources

struct DetailViewDataSourceManager {
  
  static func touristInfoDataSource(_ parent: DetailViewController) -> RxCollectionViewSectionedReloadDataSource<DetailTouristInfoSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<DetailTouristInfoSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailTouristInfoHeaderCell.identifier, for: indexPath) as? DetailTouristInfoHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
//          cell.viewModel(item: item)
//            .bind(to: parent.viewModel.headerAction)
//            .disposed(by: parent.disposeBag)
          return cell
        case .locationSection(_, let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCell.identifier, for: indexPath) as? DetailLocationCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .introSection(_, let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailTouristInfoIntroCell.identifier, for: indexPath) as? DetailTouristInfoIntroCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .socialSection(_, let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSocialCell.identifier, for: indexPath) as? DetailSocialCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .aroundSection(_, let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAroundCell.identifier, for: indexPath) as? DetailAroundCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.parent = parent
          cell.setupData(data: item)
          return cell
        case .imageSection(_, let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .locationSection(let headerStr, _),
             .introSection(header: let headerStr, _),
             .socialSection(header: let headerStr, _),
             .aroundSection(header: let headerStr, _),
             .imageSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath) as? DetailSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        default:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath)
          return header
        }
      }
    )
    return dataSource
  }
  
  
  static func campsiteDataSource(_ parent: DetailViewController) -> RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCampsiteHeaderCell.identifier, for: indexPath) as? DetailCampsiteHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          cell.viewModel(item: item)?
            .bind(to: parent.viewModel.headerAction)
            .disposed(by: parent.disposeBag)
          return cell
        case .locationSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCell.identifier, for: indexPath) as? DetailLocationCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .facilitySection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFacilityCell.identifier, for: indexPath) as? DetailFacilityCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .infoSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCampsiteInfoCell.identifier, for: indexPath) as? DetailCampsiteInfoCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .socialSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSocialCell.identifier, for: indexPath) as? DetailSocialCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .aroundSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAroundCell.identifier, for: indexPath) as? DetailAroundCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.parent = parent
          cell.setupData(data: item)
          return cell
        case .imageSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection,
            .infoSection:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath)
          return header
        case .locationSection(header: let headerStr, _),
            .facilitySection(header: let headerStr, _),
            .socialSection(header: let headerStr, _),
            .aroundSection(header: let headerStr, _),
            .imageSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath) as? DetailSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        }
      }
    )
    return dataSource
  }
}
