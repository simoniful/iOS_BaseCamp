//
//  HomeCollectionView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeCollectionView: UICollectionView {
  let disposeBag = DisposeBag()
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    register()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(_ viewModel: HomeCollectionViewModel) {
    
  }
}

private extension HomeCollectionView {
  func attribute() {

  }
  
  func register() {
    self.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCell.identifier)
    self.register(HomeRegionCell.self, forCellWithReuseIdentifier: HomeRegionCell.identifier)
    self.register(HomePlaceInfoCell.self, forCellWithReuseIdentifier: HomePlaceInfoCell.identifier)
    self.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier)
  }
}
