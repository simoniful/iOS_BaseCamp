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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IndicatorView.shared.show(backgoundColor: .gray1.withAlphaComponent(0.4))
  }
  
  func bind(_ viewModel: DetailAroundTabmanSubViewModel) {
    Observable.combineLatest(self.rx.viewWillAppear, Observable.just(type))
      .bind(to: viewModel.viewWillAppearWithContentType)
      .disposed(by: disposeBag)
    
    viewModel.cellData
      .do(onNext: { _ in
        IndicatorView.shared.hide()
      })
      .drive(collectionView.rx.items(
        cellIdentifier: DetailAroundSubCell.identifier,
        cellType: DetailAroundSubCell.self
      )) { index, item, cell in
        cell.setupData(data: item)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.modelAndIndexSelected(TouristInfo.self)
      .bind(to: viewModel.didSelectItemAt)
      .disposed(by: disposeBag)
  }
}

extension DetailAroundTabmanSubViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(collectionView)
    collectionView.register(DetailAroundSubCell.self, forCellWithReuseIdentifier: DetailAroundSubCell.identifier)
    collectionView.collectionViewLayout = createLayout()
    collectionView.isScrollEnabled = false
  }
  
  func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32.0)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      item.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 8)
      let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(300)), subitem: item, count: 3)
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
      return section
    }
    return layout
  }
}
