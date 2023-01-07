//
//  DetailViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailViewController: UIViewController {
  private let name: String
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  lazy var rightBarShareButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "square.and.arrow.up")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var rightBarDropDownButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "ellipsis")
    barButton.style = .plain
    return barButton
  }()
  
  let viewModel: DetailViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var input = DetailViewModel.Input(
     viewWillAppear: self.rx.viewWillAppear.asObservable()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: DetailViewModel, name: String) {
    self.viewModel = viewModel
    self.name = name
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    setupNavigationBar()
    setViews()
    setConstraints()
    bind()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.collectionView.performBatchUpdates(nil, completion: nil)
  }
  
  func bind() {
    switch viewModel.style {
    case .campsite:
      collectionView.collectionViewLayout = createLayout()
      let dataSource = campsiteDataSource()
      output.data
        .drive(self.collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
      
    case .touristInfo:
      print("Not yet")
    }
  }
}


private extension DetailViewController {
  private func setViews() {
    view.addSubview(collectionView)
  }
  
  private func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.topItem?.title = ""
    navigationItem.title = name
    navigationItem.rightBarButtonItems = [
      rightBarShareButton,
      rightBarDropDownButton
    ]
  }

  func register() {
    self.collectionView.register(DetailHeaderCell.self, forCellWithReuseIdentifier: DetailHeaderCell.identifier)
    self.collectionView.register(DetailLocationCell.self, forCellWithReuseIdentifier: DetailLocationCell.identifier)
    self.collectionView.register(DetailFacilityCell.self, forCellWithReuseIdentifier: DetailFacilityCell.identifier)
    self.collectionView.register(DetailInfoCell.self, forCellWithReuseIdentifier: DetailInfoCell.identifier)
    self.collectionView.register(DetailSocialCell.self, forCellWithReuseIdentifier: DetailSocialCell.identifier)
    self.collectionView.register(DetailAroundCell.self, forCellWithReuseIdentifier: DetailAroundCell.identifier)
    self.collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
    self.collectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
  }
  
  func campsiteDataSource() -> RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.identifier, for: indexPath) as? DetailHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          // cell.viewModel
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
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCell.identifier, for: indexPath) as? DetailInfoCell else {
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
          cell.parent = self
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
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        return self.wholeSection(fractionalHeight: 0.7)
      case 1:
        return self.insetSectionWithHeader(fractionalHeight: 0.55)
      case 2:
        return self.facilitySection()
      case 3:
        return self.insetSection(fractionalHeight: 0.3)
      case 4:
        return self.socialSection()
      case 6:
        return self.imageSection()
      default:
        return self.insetSectionWithHeader(fractionalHeight: 0.7)
      }
    }
  }
}

private extension DetailViewController {
  func wholeSection(fractionalHeight: Double) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight)))
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight)), subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 16.0, trailing: 0.0)
    return section
  }
  
  func insetSectionWithHeader(fractionalHeight: Double) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight )))
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let group = NSCollectionLayoutGroup.vertical(layoutSize:  .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight )), subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
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
  
  func insetSection(fractionalHeight: Double) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight )))
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let group = NSCollectionLayoutGroup.vertical(layoutSize:  .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height * fractionalHeight )), subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0)
    return section
  }
  
  func facilitySection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(60),
      heightDimension: .absolute(90)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let section = NSCollectionLayoutSection(group: group)
    
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0)
    section.orthogonalScrollingBehavior = .continuous
    
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func socialSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 24, trailing: 15)
    
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func imageSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.4),
      heightDimension: .fractionalWidth(0.533)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    section.interGroupSpacing = 4.0
    section.orthogonalScrollingBehavior = .continuous
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
