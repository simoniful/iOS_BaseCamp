//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Sang hun Lee on 2023/02/21.
//


@testable import Basecamp
import XCTest
import RxTest
import RxSwift

final class HomeViewModelTests: XCTestCase {
  
  var scheduler: TestScheduler!
  var viewModel: HomeViewModel!
  var homeCoordinator: StubHomeCoordinator!
  var homeUseCase: HomeUseCase!
  var realmRepository: RealmRepositoryInterface!
  var touristInfoRepository: TouristInfoRepositoryInterface!
  var disposeBag: DisposeBag!
  
  private var input: HomeViewModel.Input!
  private var output: HomeViewModel.Output!
  
  // Triggers
  private let viewDidLoad = PublishSubject<Void>()
  private let viewWillAppear = PublishSubject<Void>()
  private let didSelectItemAt = PublishSubject<(HomeItem, IndexPath)>()
  private let searchButtonDidTapped = PublishSubject<Void>()
  private let listButtonDidTapped = PublishSubject<Void>()
  private let mapButtonDidTapped = PublishSubject<Void>()
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    scheduler = TestScheduler(initialClock: 0)
    realmRepository = StubRealmRepository()
    touristInfoRepository = StubTouristInfoRepository()
    homeUseCase = HomeUseCase(
      realmRepository: realmRepository,
      touristInfoRepository: touristInfoRepository
    )
    homeCoordinator = StubHomeCoordinator(UINavigationController())
    viewModel = HomeViewModel(
      coordinator: homeCoordinator,
      homeUseCase: homeUseCase
    )
    input = HomeViewModel.Input(
      viewDidLoad: viewDidLoad.asObservable(),
      viewWillAppear: viewWillAppear.asObservable(),
      didSelectItemAt: didSelectItemAt.asSignalOnErrorJustComplete(),
      searchButtonDidTapped: searchButtonDidTapped.asSignalOnErrorJustComplete(),
      listButtonDidTapped: listButtonDidTapped.asSignalOnErrorJustComplete(),
      mapButtonDidTapped: mapButtonDidTapped.asSignalOnErrorJustComplete()
    )
    disposeBag = DisposeBag()
    output = viewModel.transform(input: input)
  }
  
  override func tearDownWithError() throws {
    output = nil
    disposeBag = nil
    input = nil
    viewModel = nil
    homeCoordinator = nil
    homeUseCase = nil
    touristInfoRepository = nil
    realmRepository = nil
    scheduler =  nil
    try super.tearDownWithError()
  }
  
  func test_View_생명주기_메서드_실행_시_데이터_패칭() {
    viewDidLoad.onNext(Void())
    viewWillAppear.onNext(Void())
    
    XCTAssertEqual(viewModel.data.value.count, 5)
  }
  
  func test_HeaderAction_실행_시_화면전환() {
    viewModel.headerAction.accept(.search)
    
    XCTAssertEqual(homeCoordinator.changeTabByIndexCalled, true)
    XCTAssertEqual(homeCoordinator.changedTab, 1)
  }
  
  func test_buttonAction_실행_시_화면전환() {
    searchButtonDidTapped.onNext(Void())
    
    XCTAssertEqual(homeCoordinator.changeTabByIndexCalled, true)
    XCTAssertEqual(homeCoordinator.changedTab, 1)
  }
  
  func test_didSelectItemAt_시_화면전환() {
    didSelectItemAt.onNext((HomeAreaItem(area: .서울특별시), IndexPath(item: 0, section: 1)))
    XCTAssertEqual(homeCoordinator.changeTabByIndexCalled, true)
    XCTAssertEqual(homeCoordinator.changedTab, 2)
    
    guard let data = campsiteDummyData.toDomain().first else { return }
    
    didSelectItemAt.onNext((data, IndexPath(item: 0, section: 2)))
    XCTAssertEqual(homeCoordinator.navigateToFlowDetailCalled, true)
  }
}

