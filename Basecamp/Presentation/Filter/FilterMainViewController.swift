//
//  TestViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FilterMainViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .plain)
  
  public var viewModel: FilterMainViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var input = FilterMainViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    didSelectItemAt: self.tableView.rx.modelAndIndexSelected(FilterCase.self).asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: FilterMainViewModel) {
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
    setupAttribute()
    bind()
  }
  
  func bind() {
    output.data
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        let cell = self?.tableView.dequeueReusableCell(withIdentifier: "CellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CellId")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = element.title
        switch element {
        case .area(let area):
          cell.detailTextLabel?.text = area != nil ? area?.abbreviation : "제한없음"
        case .environment(let env, let theme):
          if let env = env,
             let theme = theme {
            cell.detailTextLabel?.text = env.map { $0.rawValue }.joined(separator: ", ") + theme.map { $0.rawValue }.joined(separator: ", ")
          } else {
            cell.detailTextLabel?.text = "제한없음"
          }
        default:
          cell.detailTextLabel?.text = "제한없음"
        }
        return cell
      }
      .disposed(by: disposeBag)
    
    
  }
}

extension FilterMainViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupAttribute() {
    
  }
}


