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
  private var viewModel: DetailViewModel?
  
  init(locationData: DetailAroundItem, viewModel: DetailViewModel) {
    self.locationData = locationData
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.isScrollEnabled = false
      tablist.forEach { type in
        let vc = setVC(type: type)
        vclist.append(vc)
      }
      self.configTabbar()
  }

  func configTabbar() {
    self.dataSource = self
    let bar = TMBar.ButtonBar()
    bar.layout.transitionStyle = .snap
    bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    bar.heightAnchor.constraint(equalToConstant: 32).isActive = true
    bar.backgroundView.style = .clear
    bar.buttons.customize { (button) in
      button.selectedTintColor =  UIColor(red: 165, green: 185, blue: 171, alpha: 1.0)
      button.contentInset = UIEdgeInsets(top: 0.0, left: 4, bottom: 0.0, right: 4)
    }
    bar.indicator.overscrollBehavior = .compress
    bar.indicator.weight = .medium
    bar.indicator.tintColor = UIColor(red: 185, green: 205, blue: 191, alpha: 1.0)
    addBar(bar, dataSource: self, at: .top)
  }
  
  func setVC(type: TouristInfoContentType) -> UIViewController {
    guard let viewModel = viewModel else { return UIViewController() }
    let vc = DetailAroundTabmanSubViewController(viewModel: viewModel, locationData: locationData)
    return vc
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

