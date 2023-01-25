//
//  ListTabmanViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import UIKit
import Pageboy
import Tabman

final class ListTabmanViewController: TabmanViewController {
  private var tablist = ["캠핑장", "관광정보"]
  private var vclist: [UIViewController] = []
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.isScrollEnabled = false
      self.configTabbar()
  }
  
  func bind(_ viewModel: ListTabmanViewModel) {
    tablist.forEach { type in
      
    }
  }
  
  
  func configTabbar() {
    self.dataSource = self
    let bar = TMBar.ButtonBar()
    bar.layout.transitionStyle = .snap
    bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    bar.heightAnchor.constraint(equalToConstant: 32).isActive = true
    bar.backgroundView.style = .clear
    bar.buttons.customize { (button) in
      button.selectedTintColor = .main
      button.contentInset = UIEdgeInsets(top: 0.0, left: 4, bottom: 0.0, right: 4)
    }
    bar.indicator.overscrollBehavior = .compress
    bar.indicator.weight = .medium
    bar.indicator.tintColor = .main
    addBar(bar, dataSource: self, at: .top)
  }
}

extension ListTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      let item = TMBarItem(title: tablist[index])
      return item
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vclist.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vclist[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
