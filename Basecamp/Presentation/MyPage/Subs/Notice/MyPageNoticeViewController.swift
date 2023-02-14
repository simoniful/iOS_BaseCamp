//
//  MyPageNoticeViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageNoticeViewController: UIViewController {
  private let viewModel: MyPageNoticeViewModel
  private var disposeBag = DisposeBag()
  private lazy var input = MyPageNoticeViewModel.Input(
    viewDidLoad: Observable.just(Void()).asSignal(onErrorJustReturn: Void()),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(Notice.self).asSignal()
  )
    
  private lazy var output = viewModel.transform(input: input)
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  init(viewModel: MyPageNoticeViewModel) {
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
        guard let cell = tv.dequeueReusableCell(withIdentifier: MyPageNoticeCell.identifier) as? MyPageNoticeCell else { return UITableViewCell()
        }
        cell.setupData(data: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
  }
}

extension MyPageNoticeViewController: ViewRepresentable {
  func setupView() {
    [tableView].forEach {
      view.addSubview($0)
    }
    
    tableView.register(MyPageNoticeCell.self, forCellReuseIdentifier: MyPageNoticeCell.identifier)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
