//
//  DetailViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
  
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  lazy var rightBarShareButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "square.and.arrow.up")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var rightBarDropDownButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "ellipsis")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var leftBarDismissButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "xmark")
    barButton.style = .plain
    return barButton
  }()
  
  private let viewModel: DetailViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var input = HomeViewModel.Input(
    viewDidLoad: self.rx.viewDidLoad.asObservable(),
    viewWillAppear: self.rx.viewWillAppear.asObservable()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: DetailViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    register()
    setupNavigationBar()
    setViews()
    setConstraints()
  }
  
  func bind() {
    
  }
}


private extension DetailViewController {
  private func setViews() {
    view.addSubview(collectionView)
  }
  
  private func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = viewModel
    navigationItem.rightBarButtonItems = [
      rightBarShareButton,
      rightBarDropDownButton
    ]
    navigationItem.leftBarButtonItems = [
      leftBarDismissButton
    ]
  }

  
  func register() {
    self.collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCell.identifier)
    self.collectionView.register(HomeAreaCell.self, forCellWithReuseIdentifier: HomeAreaCell.identifier)
    self.collectionView.register(HomeCampsiteCell.self, forCellWithReuseIdentifier: HomeCampsiteCell.identifier)
    self.collectionView.register(HomeFestivalCell.self, forCellWithReuseIdentifier: HomeFestivalCell.identifier)
    self.collectionView.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier)
  }
}
