//
//  SearchKeywordViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class KeywordViewController: UIViewController {
  let viewModel: KeywordViewModel
  let disposeBag = DisposeBag()
  
  private lazy var input = KeywordViewModel.Input(
    searchKeyword: searchController.searchBar.rx.value.orEmpty.asObservable(),
    cancelButtonTapped: searchController.searchBar.rx.cancelButtonClicked.asSignal(),
    searchButtonTapped: searchController.searchBar.rx.searchButtonClicked.asSignal(),
    didSelectItemAt: self.resultList.rx.modelAndIndexSelected(Campsite.self).asSignal()
  )
  private lazy var output = viewModel.transform(input: input)
  
  lazy var searchController = UISearchController()
  lazy var resultList = UITableView(frame: .zero, style: .plain)
  
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
    bind()
  }
  
  func bind(){
    output.data
      .drive(resultList.rx.items) { [weak self] tv, index, element in
      self?.resultList.backgroundView = nil
      let cell = self?.resultList.dequeueReusableCell(withIdentifier: "KeywordCell") ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "KeywordCell")
      cell.textLabel?.text = element.facltNm
      cell.textLabel?.font = .title1M16
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.text = element.addr1 ?? ""
      cell.detailTextLabel?.font = .body3R14
      cell.detailTextLabel?.textColor = .black
      cell.selectionStyle = .none
      return cell
    }
    .disposed(by: disposeBag)
    
    output.invalidKeywordSignal
      .drive { [weak self] _ in
        self?.viewModel.data.accept([])
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: (self?.resultList.bounds.size.width)!, height: (self?.resultList.bounds.size.height)!))
        noDataLabel.text          = "2글자 이상 입력 시 자동으로 결과가 보여집니다"
        noDataLabel.textColor     = .gray5
        noDataLabel.textAlignment = .center
        noDataLabel.font = .title3M14
        self?.resultList.backgroundView  = noDataLabel
        self?.resultList.separatorStyle  = .none
      }
      .disposed(by: disposeBag)
    
    output.emptyResultSignal
      .drive { [weak self] _ in
        let noDataImage: UIImageView = UIImageView(image: UIImage(named: "noResult"))
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.clipsToBounds = true
        self?.resultList.backgroundView  = noDataImage
        noDataImage.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.centerY.equalToSuperview()
          $0.width.equalTo(240.0)
          $0.height.equalTo(180.0)
        }
        self?.resultList.separatorStyle  = .none
      }
      .disposed(by: disposeBag)
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
    self.title = "키워드 검색"
    self.navigationItem.searchController = searchController
  }
  
  func setupAttribute() {
    searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
    searchController.searchBar.placeholder = "캠핑장 이름"
    searchController.searchBar.searchTextField.font = .body3R14
  }
}
