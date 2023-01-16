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

struct FilterItem: IdentifiableType, Equatable {
  var identity: String {
      return UUID().uuidString
  }

  var title: String
  var selected: Bool
}

struct FilterSubSection {
    var header: String
    var items: [Item]
}

extension FilterSubSection : AnimatableSectionModelType {
   typealias Item = FilterItem
    var identity: String {
        return header
    }

    init(original: FilterSubSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class FilterSubViewController: UIViewController {
  public var viewModel: FilterSubViewModel
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  private lazy var input = FilterSubViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(FilterItem.self).asSignal()
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
  
  var dataSource: RxTableViewSectionedAnimatedDataSource<FilterSubSection>?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupAttribute()
    bind()
  }
  
  func bind() {
    let dataSource = RxTableViewSectionedAnimatedDataSource<FilterSubSection>(
      configureCell: { ds, tv, _, item in
        guard let cell = tv.dequeueReusableCell(withIdentifier: CheckboxCell.identifier) as? CheckboxCell else { return UITableViewCell(style: .default, reuseIdentifier: "Cell")}
        cell.setupData(data: item)
        return cell
      },
      titleForHeaderInSection: { ds, index in
        return ds.sectionModels[index].header
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
      make.edges.equalToSuperview()
    }
  }
  
  func setupAttribute() {
    tableView.register(CheckboxCell.self, forCellReuseIdentifier: CheckboxCell.identifier)
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

extension FilterSubViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
}
