//
//  HomeView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import SnapKit

final class HomeView: UIView {
  lazy var rightBarSearchButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "magnifyingglass")
      barButton.style = .plain
      return barButton
  }()
  
  lazy var rightBarListButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "list.bullet")
      barButton.style = .plain
      return barButton
  }()
  
  lazy var rightBarMapButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "mappin.and.ellipse")
      barButton.style = .plain
      return barButton
  }()
  
  lazy var collection = HomeCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
      setupConstraints()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

extension HomeView: ViewRepresentable {
  func setupView() {
    addSubview(collection)
  }
  
  func setupConstraints() {
    collection.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
}
