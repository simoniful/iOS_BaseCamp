//
//  MyPageNoticeSubViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageNoticeSubViewController: UIViewController {
  public var notice: Notice?
  public var coordinator: MyPageCoordinator?
  private var disposeBag = DisposeBag()
  
  private let tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupAttribute()
    bind()
  }
  
  func bind() {
    guard let notice = notice else { return }
    Driver.just([notice])
      .drive(tableView.rx.items) {
        [weak self] tv, index, element in
        guard let cell = tv.dequeueReusableCell(withIdentifier: MyPageNoticeSubCell.identifier) as? MyPageNoticeSubCell else { return UITableViewCell()
        }
        cell.setupData(data: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

extension MyPageNoticeSubViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupAttribute() {
    tableView.register(MyPageNoticeSubCell.self, forCellReuseIdentifier: MyPageNoticeSubCell.identifier)
    tableView.register(MyPageNoticeSubHeader.self, forHeaderFooterViewReuseIdentifier: MyPageNoticeSubHeader.identifier)
  }
}

extension MyPageNoticeSubViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageNoticeSubHeader.identifier) as? MyPageNoticeSubHeader else { return UIView() }
    guard let notice = notice else { return UIView() }
    header.setupData(notice: notice)
    return header
  }
}


