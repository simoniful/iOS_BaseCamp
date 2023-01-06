//
//  DetailAroundTabmanSubViewController.swift.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailAroundTabmanSubViewController: UIViewController {
  private var disposeBag = DisposeBag()
  
  private let type: TouristInfoContentType
  private let locationData: DetailAroundItem
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  init(locationData: DetailAroundItem, type: TouristInfoContentType) {
    self.type = type
    self.locationData = locationData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  func bind(_ viewModel: DetailAroundTabmanSubViewModel) {
    self.rx.viewWillAppear
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: disposeBag)
    
//    viewModel.cellData
//      .drive(collectionView.rx.items) { collectionView, item, data in
//        let index = IndexPath(item: item, section: 0)
//        // cell 구성
//        return UICollectionViewCell()
//      }
//      .disposed(by: disposeBag)
  }
}

extension DetailAroundTabmanSubViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(collectionView)
  }
  
  func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  
}
