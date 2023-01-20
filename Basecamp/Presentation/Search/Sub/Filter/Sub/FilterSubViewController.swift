//
//  FilterSubViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator


class FilterSubViewController: UIViewController {
  public var viewModel: FilterSubViewModel
  
  lazy var rightBarConfirmButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.title = "확인"
    barButton.tintColor = .gray7
    barButton.style = .plain
    return barButton
  }()
  private lazy var tableView = UITableView(frame: .zero, style: .grouped)
  
  private lazy var input = FilterSubViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(FilterItem.self).asSignal(),
    didTapConfirmButton: self.rightBarConfirmButton.rx.tap.asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: FilterSubViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let disposeBag = DisposeBag()
  
  var dataSource: RxTableViewSectionedReloadDataSource<FilterSubSection>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    setupView()
    setupConstraints()
    setupAttribute()
    bind()
  }
  
  func bind() {
    let dataSource = RxTableViewSectionedReloadDataSource<FilterSubSection>(
      configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterSubItemCell.identifier) as? FilterSubItemCell else { return UITableViewCell(style: .default, reuseIdentifier: "Cell")}
        cell.bind(item: item)
        
        cell.checkBoxButton.indexPath = indexPath
        cell.checkBoxButton.addTarget(self, action: #selector(self.checkboxSelection(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
      }
    )
    
    self.dataSource = dataSource
    
    output.data
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

extension FilterSubViewController {
  func setupView() {
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigation() {
    navigationItem.rightBarButtonItems = [
      rightBarConfirmButton
    ]
  }
  
  func setupAttribute() {
    tableView.register(FilterSubItemCell.self, forCellReuseIdentifier: FilterSubItemCell.identifier)
    tableView.register(FilterSubSectionHeader.self, forHeaderFooterViewReuseIdentifier: FilterSubSectionHeader.identifier)
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.rowHeight = 52.0
    tableView.sectionHeaderHeight = 52.0
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
  }
  
  @objc func checkboxSelection(_ sender: CheckButton) {
    guard let indexPath = sender.indexPath else { return }
    var sections = viewModel.data.value
    sections[indexPath.section].items[indexPath.row].selected.toggle()
    UIView.performWithoutAnimation {
      viewModel.data.accept(sections)
    }
  }
}

extension FilterSubViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSubSectionHeader.identifier) as? FilterSubSectionHeader else { return UIView() }
    let headerStr = viewModel.data.value[section].header
    header.setData(header: headerStr)
    return header
  }
}


