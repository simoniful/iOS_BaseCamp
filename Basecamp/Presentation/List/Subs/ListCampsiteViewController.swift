//
//  ListCampsiteViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListCampsiteViewController: UIViewController {
  private var disposeBag = DisposeBag()
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  func bind(_ viewModel: ListCampsiteViewModel) {
    self.rx.viewWillAppear
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)
    
    viewModel.cellData
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        let cell = self?.tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as! SearchCell
        cell.setupData(campsite: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
  }
}

extension ListCampsiteViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(tableView)
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 76
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}
