//
//  DetailAroundCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit

final class DetailAroundCell: UICollectionViewCell {
  static let identifier = "DetailAroundCell"
  weak var parent: DetailViewController? = nil
  
  private lazy var container = UIView()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
    setupConstraints()
  }
  
  func setData(data: DetailAroundItem) {
    guard let parent = parent else { return }
    let tabman = DetailAroundTabmanViewController(locationData: data, viewModel: parent.viewModel)
    parent.addChild(tabman)
    container.addSubview(tabman.view)
    tabman.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    tabman.didMove(toParent: parent)
  }
}

extension DetailAroundCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(container)
  }
  
  func setupConstraints() {
    container.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
}


