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
        cell.detailTextLabel?.font = .body3R14
        cell.selectionStyle = .none
        
        switch element {
        case .area(let area):
          cell.detailTextLabel?.text = area != nil ? area?.abbreviation : "제한없음"
        case .environment(let env, let exp):
          if env == nil && exp == nil {
            cell.detailTextLabel?.text = "제한없음"
          } else {
            let grouped = (env?.compactMap{ $0.rawValue } ?? []) + (exp?.compactMap{ $0.rawValue } ?? [])
            cell.detailTextLabel?.text = grouped.count > 2 ? "\(grouped[0...1].joined(separator: ", ")) 외 \(grouped.count - 2)개" : grouped.joined(separator: ", ")
          }
          
        case .rule(let camptype, let resv):
          if camptype == nil && resv == nil {
            cell.detailTextLabel?.text = "제한없음"
          } else {
            let grouped = (camptype?.compactMap{ $0.rawValue } ?? []) + (resv?.compactMap{ $0.rawValue } ?? [])
            cell.detailTextLabel?.text = grouped.count > 2 ? "\(grouped[0...1].joined(separator: ", ")) 외 \(grouped.count - 2)개" : grouped.joined(separator: ", ")
          }
        case .facility(let basicFctly, let sanitaryFctly, let sportsFctly):
          if basicFctly == nil && sanitaryFctly == nil && sportsFctly == nil {
            cell.detailTextLabel?.text = "제한없음"
          } else {
            let grouped = (basicFctly?.compactMap{ $0.rawValue } ?? []) + (sanitaryFctly?.compactMap{ $0.rawValue } ?? []) + (sportsFctly?.compactMap{ $0.rawValue } ?? [])
            cell.detailTextLabel?.text = grouped.count > 2 ? "\(grouped[0...1].joined(separator: ", ")) 외 \(grouped.count - 2)개" : grouped.joined(separator: ", ")
          }
        case .pet(let petEntry, let petSize):
          if petEntry == nil && petSize == nil {
            cell.detailTextLabel?.text = "제한없음"
          } else {
            let grouped = (petEntry?.compactMap{ $0.rawValue } ?? []) + (petSize?.compactMap{ $0.rawValue } ?? [])
            cell.detailTextLabel?.text = grouped.count > 2 ? "\(grouped[0...1].joined(separator: ", ")) 외 \(grouped.count - 2)개" : grouped.joined(separator: ", ")
          }
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
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupAttribute() {
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
  }
}


