//
//  MyPageViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class MyPageViewController: UIViewController {
  public let viewModel: MyPageViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var tableView = UITableView(frame: .zero, style: .plain)
  
  private lazy var input = MyPageViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asSignal(),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(MyMenuCase.self).asSignal()
  )
    
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: MyPageViewModel) {
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
    setupAttribute()
    bind()
  }
  
  func bind() {
    output.data
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        let cell = self?.tableView.dequeueReusableCell(withIdentifier: "CellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CellId")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.imageView?.image = UIImage(systemName: element.icon)
        cell.tintColor = .mainStrong
        cell.textLabel?.text = element.title
        cell.detailTextLabel?.font = .body4R12
        cell.detailTextLabel?.textColor = .gray7
        switch element {
        case .notice, .info, .setting:
          cell.textLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
          cell.detailTextLabel?.text = nil
        case .like(let count):
          cell.detailTextLabel?.text = "\(count)곳"
        case .review(let count):
          cell.detailTextLabel?.text = "\(count)건"
        }
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
  }
}

extension MyPageViewController: ViewRepresentable {
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
  
  func setupNavigationBar() {
    setupLogo()
    navigationItem.largeTitleDisplayMode = .never
  }
  
  func setupAttribute() {
    // tableView.separatorStyle = .singleLine
    tableView.estimatedRowHeight = 80.0
    tableView.rowHeight = UITableView.automaticDimension
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
  
}
