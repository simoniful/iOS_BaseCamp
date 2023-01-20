//
//  SearchKeywordViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/19.
//

import UIKit
import RxSwift
import RxCocoa

final class KeywordViewController: UIViewController {
  let viewModel: KeywordViewModel
  let disposeBag = DisposeBag()
  
  private lazy var input = KeywordViewModel.Input()
  private lazy var output = viewModel.transform(input: input)
  
  let searchBar = UISearchBar()
  let resultList = UITableView(frame: .zero, style: .plain)
  
  init(viewModel: KeywordViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    setupView()
    setupConstraints()
    setupAttribute()
  }
  
  func bind(){
    
  }
}

extension KeywordViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(resultList)
  }
  
  func setupConstraints() {
    resultList.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigation() {
//    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.titleView = searchBar
  }
  
  func setupAttribute() {
    searchBar.sizeToFit()
  }
}
