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
  private var tabmanSetFlag: Bool = false
  
  private lazy var container = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
    setupConstraints()
  }
  
  func setupData(data: DetailAroundItem) {
    if tabmanSetFlag == false {
      guard let parent = parent else { return }
      let tabman = DetailAroundTabmanViewController(locationData: data)
      tabman.bind(parent.viewModel.aroundTabmanViewModel)
      parent.addChild(tabman)
      container.addSubview(tabman.view)
      tabman.view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      tabman.didMove(toParent: parent)
      tabmanSetFlag.toggle()
    }
  }
}

extension DetailAroundCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(container)
  }
  
  func setupConstraints() {
    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


