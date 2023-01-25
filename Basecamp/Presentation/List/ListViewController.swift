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

final class ListViewController: UIViewController {
  
  private lazy var areaDropDownView = DropDownView()
  private lazy var areaDropDown = DropDown()
  private lazy var sigunguDropDownView = DropDownView()
  private lazy var sigunguDropDown = DropDown()
  private lazy var tabmanView = UIView()
  
  private lazy var input = ListViewModel.Input(
    viewDidLoad: Observable.just(()).take(1)
  )
  private lazy var output = viewModel.transform(input: input)
  
  public let viewModel: ListViewModel
  private let disposeBag = DisposeBag()
  
  init(viewModel: ListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupView()
    setupConstraints()
    bind()
    setupAttribute()
    initUI()
    setDropdown()
  }
  
  func bind() {
    output.sigunguReloadSignal
      .drive { [weak self] list in
        self?.sigunguDropDownView.isHidden = false
        self?.sigunguDropDown.dataSource = list
        self?.sigunguDropDown.reloadAllComponents()
        IndicatorView.shared.hide()
      }
      .disposed(by: disposeBag)
  }
  
  func initUI() {
    areaDropDownView.backgroundColor = .white
    areaDropDownView.layer.cornerRadius = 8
    sigunguDropDownView.backgroundColor = .white
    sigunguDropDownView.layer.cornerRadius = 8
    
    DropDown.appearance().textColor = UIColor.black 
    DropDown.appearance().selectedTextColor = UIColor.red
    DropDown.appearance().backgroundColor = UIColor.white
    DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
    DropDown.appearance().setupCornerRadius(8)
    DropDown.appearance().cellHeight = 36.0
    areaDropDown.dismissMode = .automatic
    sigunguDropDown.dismissMode = .automatic
    
    areaDropDownView.textField.text = "전국"
    areaDropDownView.iconImageView.tintColor = UIColor.gray
    sigunguDropDownView.textField.text = "전체"
    sigunguDropDownView.iconImageView.tintColor = UIColor.gray
  }
  
  func setDropdown() {
    areaDropDown.dataSource = Area.allCases.map { $0.rawValue }
    areaDropDown.anchorView = self.areaDropDownView
    areaDropDown.bottomOffset = CGPoint(x: 0, y: 44.0)
    sigunguDropDown.anchorView = self.sigunguDropDownView
    sigunguDropDown.bottomOffset = CGPoint(x: 0, y: 44.0)
    
    areaDropDown.selectionAction = { [weak self] (index, item) in
      self?.viewModel.areaState.accept(Area(rawValue: item)!)
      self!.areaDropDownView.textField.text = item
      self!.areaDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
      self!.sigunguDropDownView.isHidden = true
      self!.sigunguDropDownView.textField.text = "전체"
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
    areaDropDown.show()
    self.areaDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
  }
  
  @objc func sigunguDropdownClicked(_ sender: Any) {
    sigunguDropDown.show()
    self.sigunguDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
  }
}

private extension ListViewController {
  func setupView() {
    [tabmanView, areaDropDownView, sigunguDropDownView].forEach {
      view.addSubview($0)
    }
    
  }
  func setupConstraints() {
    areaDropDownView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8.0)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.height.equalTo(44.0)
      $0.width.equalTo(140.0)
    }
    
    sigunguDropDownView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8.0)
      $0.leading.equalTo(areaDropDownView.snp.trailing).offset(16.0)
      $0.height.equalTo(44.0)
      $0.width.equalTo(140.0)
    }
  }
  
  func setupNavigationBar() {
    setupLogo()
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
    tabmanView.backgroundColor = .main
    sigunguDropDownView.isHidden = true
    areaDropDownView.selectButton.addTarget(self, action: #selector(areaDropdownClicked), for: .touchUpInside)
    sigunguDropDownView.selectButton.addTarget(self, action: #selector(sigunguDropdownClicked), for: .touchUpInside)
  }
}
