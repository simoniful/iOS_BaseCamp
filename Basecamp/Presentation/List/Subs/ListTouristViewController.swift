//
//  ListTouristViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListTouristViewController: UIViewController {
  private var viewModel: ListTouristViewModel
  private var disposeBag = DisposeBag()
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  init(viewModel: ListTouristViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    bind()
  }
  
  func bind() {
    self.rx.viewWillAppear
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)
    
    tableView
      .rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.cellData
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        let cell = self?.tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as! SearchCell
        cell.setupData(touristInfo: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
    
    tableView.rx.prefetchRows
      .bind(to: viewModel.prefetchRowsAt)
      .disposed(by: disposeBag)
  }
}

extension ListTouristViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(tableView)
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    tableView.register(ListTouristViewHeader.self, forHeaderFooterViewReuseIdentifier: ListTouristViewHeader.identifier)
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 76
    tableView.sectionHeaderTopPadding = 0
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension ListTouristViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListTouristViewHeader.identifier) as? ListTouristViewHeader else { return UITableViewHeaderFooterView() }
    header.setup(delegate: self)
    return header
  }
}

extension ListTouristViewController: ListTouristViewHeaderDelegate {
  func didSelectTag(_ selected: TouristInfoContentType?) {
    viewModel.currentContentType.accept(selected)
  }
}
