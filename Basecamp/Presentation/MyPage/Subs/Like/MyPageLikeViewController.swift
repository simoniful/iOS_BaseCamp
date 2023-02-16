//
//  MyPageLikeViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageLikeViewController: UIViewController {
  private let viewModel: MyPageLikeViewModel
  private var disposeBag = DisposeBag()
  private lazy var input = MyPageLikeViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(Campsite.self).asSignal(),
    deleteAllButtonTapped:
      rightBarAllDeleteButton.rx.tap.asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  private lazy var rightBarAllDeleteButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "trash.fill")
    barButton.style = .plain
    return barButton
  }()
  
  init(viewModel: MyPageLikeViewModel) {
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
    setupNavigationBar()
    bind()
  }
  
  func bind() {
    output.data
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        guard let cell = tv.dequeueReusableCell(withIdentifier: SearchCell.identifier) as? SearchCell else { return UITableViewCell()
        }
        cell.setupData(campsite: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
    
    output.deleteAlert
      .emit(onNext: { [weak self] (title, message) in
        guard let self = self else { return }
        let alert = AlertView.init(title: title, message: message, buttonStyle: .confirmAndCancel) {
          self.viewModel.deleteAllConfirmTapped.accept(Void())
        }
        alert.showAlert()
      })
      .disposed(by: disposeBag)
  }
}

extension MyPageLikeViewController: ViewRepresentable {
  func setupView() {
    [tableView].forEach {
      view.addSubview($0)
    }
    
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [
      rightBarAllDeleteButton
    ]
  }
}
