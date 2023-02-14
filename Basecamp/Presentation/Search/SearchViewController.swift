//
//  SearchViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let tableHeader = SearchHeader(
    frame:
      CGRect(
        origin: .zero,
        size: CGSize(width: UIScreen.main.bounds.width, height: 56)
      )
  )
  
  lazy var rightBarSearchButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "magnifyingglass")
    barButton.style = .plain
    return barButton
  }()
  
  private lazy var input = SearchViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    searchButtonTapped: rightBarSearchButton.rx.tap.asSignal(),
    didSelectItemAt: tableView.rx.modelAndIndexSelected(Campsite.self).asSignal()
  )
  private lazy var output = viewModel.transform(input: input)
  private let viewModel: SearchViewModel
  private let disposeBag = DisposeBag()
  
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupView()
    setupConstraints()
    bind()
    setupAttribute()
    register()
  }
  
  func bind() {
    tableHeader.bind(viewModel.searchHeaderViewModel)
    output.data
      .drive(tableView.rx.items) { [weak self] tv, index, element in
        let cell = self?.tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as! SearchCell
        cell.setupData(campsite: element)
        cell.selectionStyle = .none
        return cell
      }
      .disposed(by: disposeBag)
  }
}

extension SearchViewController: UISheetPresentationControllerDelegate { }

extension SearchViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

private extension SearchViewController {
  func setupNavigationBar() {
    setupLogo()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [
      rightBarSearchButton
    ]
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
  
  func register() {
    tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    tableView.register(SearchHeader.self, forHeaderFooterViewReuseIdentifier: SearchHeader.identifier)
  }
  
  func setupAttribute() {
    tableView.tableHeaderView = tableHeader
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 76
  }
}
