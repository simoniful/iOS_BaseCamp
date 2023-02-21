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
    viewDidLoad: Observable.just(Void()).asSignal(onErrorJustReturn: Void()),
    didSelectItemAt: tableView.rx.modelAndIndexSelected(MyPageSettingCase.self).asSignal()
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
        guard let self = self else { return UITableViewCell() }
        switch element {
        case .pushControl:
          guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MyPageSettingSwitchCell.identifier) as? MyPageSettingSwitchCell else {
            return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "SettingCellId")
          }
          cell.configure(with: self.viewModel.switchCellViewModel)
          self.isPushNotificationsEnabled { isEnabled in
            DispatchQueue.main.async {
              cell.setupData(title: element.rawValue, state: isEnabled)
            }
          }
          cell.selectionStyle = .none
          return cell
        case .accessRight:
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingCellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "SettingCellId")
          cell.textLabel?.text = element.rawValue
          cell.textLabel?.font = .body2R16
          cell.accessoryType = .disclosureIndicator
          cell.selectionStyle = .none
          return cell
        case .version:
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingCellId") ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "SettingCellId")
          cell.textLabel?.text = element.rawValue
          cell.textLabel?.font = .body2R16
          cell.accessoryType = .none
          cell.detailTextLabel?.text = "1.0.0"
          cell.detailTextLabel?.font = .body2R16
          cell.detailTextLabel?.textColor = .gray7
          cell.selectionStyle = .none
          return cell
        }
      }
      .disposed(by: disposeBag)
  }
  
  func isPushNotificationsEnabled(completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .notDetermined, .denied:
        completion(false)
      case .authorized, .provisional, .ephemeral:
        completion(true)
      @unknown default:
        completion(false)
      }
    }
  }
}

extension MyPageSettingViewController: ViewRepresentable {
  func setupView() {
    [tableView].forEach {
      view.addSubview($0)
    }
    
    tableView.register(MyPageSettingSwitchCell.self, forCellReuseIdentifier: MyPageSettingSwitchCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50.0
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
