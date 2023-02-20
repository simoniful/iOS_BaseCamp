//
//  MyPageSettingViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageSettingViewController: UIViewController {
  private let viewModel: MyPageSettingViewModel
  private var disposeBag = DisposeBag()
  
  private lazy var input = MyPageSettingViewModel.Input(
    viewDidLoad: Observable.just(Void()).asSignal(onErrorJustReturn: Void())
  )
  private lazy var output = viewModel.transform(input: input)
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  init(viewModel: MyPageSettingViewModel) {
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
    output.data
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        
        switch element {
        case .pushControl:
          
        case .accessRight:
          let cell = self?.tableView.dequeueReusableCell(withIdentifier: "InfoCellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "InfoCellId")
          cell.textLabel?.text = element.rawValue
          cell.detailTextLabel?.font = .body2R16
          cell.accessoryType = .disclosureIndicator
          cell.selectionStyle = .none
          return cell
        case .version:
          let cell = self?.tableView.dequeueReusableCell(withIdentifier: "InfoCellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "InfoCellId")
          cell.textLabel?.text = element.rawValue
          cell.detailTextLabel?.font = .body2R16
          cell.selectionStyle = .none
          return cell
        }
        
      }
      .disposed(by: disposeBag)
  }
}

extension MyPageSettingViewController: ViewRepresentable {
  func setupView() {
    [tableView].forEach {
      view.addSubview($0)
    }
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
