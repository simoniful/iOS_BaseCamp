//
//  SearchBarContainerView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/21.
//

import UIKit

final class SearchBarContainerView: UIView {
  let searchBar: UISearchBar
  init(customSearchBar: UISearchBar) {
    searchBar = customSearchBar
    super.init(frame: CGRect.zero)

    addSubview(searchBar)
  }

  override convenience init(frame: CGRect) {
    self.init(customSearchBar: UISearchBar())
    self.frame = frame
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    searchBar.frame = bounds
  }
}
