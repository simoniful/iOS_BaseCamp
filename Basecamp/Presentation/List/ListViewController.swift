//
//  ListViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import UIKit
import RxCocoa
import RxSwift
import DropDown
import Pageboy
import Tabman

enum ListTabBarContentType: Int, CaseIterable {
  case campsite
  case touristInfo
  
  var title: String {
    switch self {
    case .campsite:
      return "캠핑장"
    case .touristInfo:
      return "관광정보"
    }
  }
}

final class ListViewController: TabmanViewController {
  private var tablist = ListTabBarContentType.allCases
  private var vclist: [UIViewController] = []
  
  private lazy var areaDropDownView = DropDownView()
  private lazy var areaDropDown = DropDown()
  private lazy var sigunguDropDownView = DropDownView()
  private lazy var sigunguDropDown = DropDown()
  
  private lazy var input = ListViewModel.Input(
    viewDidLoad: Observable.just(()).take(1)
  )
  private lazy var output = viewModel.transform(input: input)
  
  public let viewModel: ListViewModel
  private let disposeBag = DisposeBag()
  
  init(viewModel: ListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupNavigationBar()
    setupDropdownUI()
    setupDropdown()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupAttribute()
    setupTabbar()
  }
  
  func bind() {
    let campsiteVC = ListCampsiteViewController(viewModel: viewModel.listCampsiteViewModel)
    let touristVC = ListTouristViewController(viewModel: viewModel.listTouristViewModel)
    [campsiteVC, touristVC].forEach {
      vclist.append($0)
    }
    
    output.sigunguReloadSignal
      .drive { [weak self] list in
        self?.sigunguDropDownView.isHidden = false
        self?.sigunguDropDown.dataSource = list
        self?.sigunguDropDown.reloadAllComponents()
        IndicatorView.shared.hide()
      }
      .disposed(by: disposeBag)
    
    output.dropdownSetSignal
      .drive { [weak self] (index, value) in
        guard let index = index,
              let value = value else { return }
        self?.areaDropDown.selectRow(index)
        self?.areaDropDown.selectionAction?(index, value)
      }
      .disposed(by: disposeBag)
  }
}

private extension ListViewController {
  func setupView() {
    [].forEach {
      view.addSubview($0)
    }
  }
  
  func setupConstraints() {
    areaDropDownView.snp.makeConstraints {
      $0.height.equalTo(36.0)
      $0.width.equalTo(130.0)
    }
    
    sigunguDropDownView.snp.makeConstraints {
      $0.height.equalTo(36.0)
      $0.width.equalTo(130.0)
    }
  }
  
  func setupNavigationBar() {
    setupLogo()
    let stack = UIStackView(arrangedSubviews: [areaDropDownView, sigunguDropDownView])
    stack.axis = .horizontal
    stack.spacing = 20.0
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = .init(top: 0, left: 12.0, bottom: 4.0, right: 8.0)
    navigationItem.titleView = stack
  }
  
  func setupLogo() {
    let logoImage = UIImage.init(named: "logo")
    let logoImageView = UIImageView.init(image: logoImage)
    logoImageView.frame = CGRect(x: 0.0, y: 0.0,  width: 36, height: 36.0)
    logoImageView.contentMode = .scaleAspectFit
    let imageItem = UIBarButtonItem.init(customView: logoImageView)
    logoImageView.snp.makeConstraints {
      $0.width.height.equalTo(36)
    }
    navigationItem.leftBarButtonItem = imageItem
  }
  
  func setupAttribute() {
    sigunguDropDownView.isHidden = true
    areaDropDownView.selectButton.addTarget(self, action: #selector(areaDropdownClicked), for: .touchUpInside)
    sigunguDropDownView.selectButton.addTarget(self, action: #selector(sigunguDropdownClicked), for: .touchUpInside)
  }
  
  func setupTabbar() {
    self.dataSource = self
    let bar = TMBar.ButtonBar()
    bar.layout.transitionStyle = .snap
    bar.layout.contentInset = UIEdgeInsets(top: 12.0, left: 4.0, bottom: 0.0, right: 4.0)
    bar.layout.contentMode = .fit
    bar.heightAnchor.constraint(equalToConstant: 52.0).isActive = true
    bar.backgroundView.style = .flat(color: .systemBackground)
    bar.buttons.customize { (button) in
      button.selectedTintColor = .main
    }

    bar.indicator.overscrollBehavior = .compress
    bar.indicator.weight = .medium
    bar.indicator.tintColor = .main
    addBar(bar, dataSource: self, at: .top)
  }
}

extension ListViewController {
  func setupDropdownUI() {
    areaDropDownView.backgroundColor = .white
    areaDropDownView.layer.cornerRadius = 8
    sigunguDropDownView.backgroundColor = .white
    sigunguDropDownView.layer.cornerRadius = 8
    
    DropDown.appearance().textColor = UIColor.black
    DropDown.appearance().selectedTextColor = UIColor.main
    DropDown.appearance().backgroundColor = UIColor.white
    DropDown.appearance().selectionBackgroundColor = UIColor.gray1
    DropDown.appearance().setupCornerRadius(8)
    DropDown.appearance().cellHeight = 36.0
  
    areaDropDown.dismissMode = .automatic
    sigunguDropDown.dismissMode = .automatic
    
    areaDropDownView.textField.text = "전국"
    areaDropDownView.iconImageView.tintColor = UIColor.gray
    sigunguDropDownView.textField.text = "전체"
    sigunguDropDownView.iconImageView.tintColor = UIColor.gray
  }
  
  func setupDropdown() {
    areaDropDown.dataSource = Area.allCases.map { $0.rawValue }
    areaDropDown.anchorView = self.areaDropDownView
    areaDropDown.bottomOffset = CGPoint(x: 0, y: 36.0)
    sigunguDropDown.anchorView = self.sigunguDropDownView
    sigunguDropDown.bottomOffset = CGPoint(x: 0, y: 36.0)
    
    areaDropDown.selectionAction = { [weak self] (index, item) in
      self?.viewModel.areaState.accept(Area(rawValue: item)!)
      self!.areaDropDownView.textField.text = item
      self!.areaDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
      self!.sigunguDropDownView.isHidden = true
      self!.sigunguDropDownView.textField.text = "전체"
      self?.viewModel.sigunguState.accept(nil)
      IndicatorView.shared.show(backgoundColor: .black.withAlphaComponent(0.1))
    }
    
    sigunguDropDown.selectionAction = { [weak self] (index, item) in
      guard let selected = self?.viewModel.sigunguDataSource.value.filter({ $0.name == item }).first else { return }
      self?.viewModel.sigunguState.accept(selected)
      self!.sigunguDropDownView.textField.text = item
      self!.sigunguDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
    }
    
    areaDropDown.cancelAction = { [weak self] in
      self!.areaDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
    }
    
    sigunguDropDown.cancelAction = { [weak self] in
      self!.sigunguDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
    }
  }
  
  @objc func areaDropdownClicked(_ sender: Any) {
    if areaDropDown.isHidden {
      areaDropDown.show()
      self.areaDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
    }
  }
  
  @objc func sigunguDropdownClicked(_ sender: Any) {
    if sigunguDropDown.isHidden {
      sigunguDropDown.show()
      self.sigunguDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
    }
  }
}

extension ListViewController: TMBarDataSource, PageboyViewControllerDataSource {
  func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
    let item = TMBarItem(title: tablist[index].title)
    return item
  }
  
  func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return vclist.count
  }
  
  func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
    viewModel.tabState.accept(ListTabBarContentType.init(rawValue: index)!)
    return vclist[index]
  }
  
  func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return nil
  }
}

