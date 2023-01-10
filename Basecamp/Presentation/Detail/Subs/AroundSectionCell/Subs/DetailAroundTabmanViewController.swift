//
//  DetailAroundTabmanController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit
import Tabman
import Pageboy

final class DetailAroundTabmanViewController: TabmanViewController {
  var locationData: DetailAroundItem
  private var tablist = TouristInfoContentType.allCases
  private var vclist: [UIViewController] = []
  
  init(locationData: DetailAroundItem) {
    self.locationData = locationData
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
  
  func bind(_ viewModel: DetailAroundTabmanViewModel) {
    tablist.forEach { type in
      let vc = DetailAroundTabmanSubViewController(locationData: locationData, type: type)
      vc.bind(viewModel.detailAroundTabmanSubViewModel)
      vclist.append(vc)
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

extension DetailAroundTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      let item = TMBarItem(title: tablist[index].koreanTitle)
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

