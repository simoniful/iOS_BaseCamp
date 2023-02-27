//
//  DetailViewModelTests.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/23.
//

@testable import Basecamp
import XCTest
import RxTest
import RxSwift

final class DetailViewModelTestsForCampsite: XCTestCase {
  var scheduler: TestScheduler!
  var viewModel: DetailViewModel!
  var detailCoordinator: StubDetailCoordinator!
  var detailUseCase: DetailUseCase!
  var campsiteRepository: StubCampsiteRepository!
  var realmRepository: StubRealmRepository!
  var touristInfoRepository: StubTouristInfoRepository!
  var weatherRepository: StubWeatherRepository!
  var naverBlogRepository: StubNaverBlogRepository!
  var youtubeRepository: StubYoutubeRepository!
  var disposeBag: DisposeBag!
  var mockCampsite: Campsite!
  
  private var input: DetailViewModel.Input!
  private var output: DetailViewModel.Output!
  
  // Triggers
  private let viewWillAppear = PublishSubject<Void>()
  private let isAutorizedLocation = PublishSubject<Bool>()
  private let didSelectItemAt = PublishSubject<(DetailItem, IndexPath)>()
  private let shareButtonDidTapped = PublishSubject<Void>()
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockCampsite = campsiteDummyData.toDomain().first!
    scheduler = TestScheduler(initialClock: 0)
    campsiteRepository = StubCampsiteRepository()
    realmRepository = StubRealmRepository()
    touristInfoRepository = StubTouristInfoRepository()
    weatherRepository = StubWeatherRepository()
    naverBlogRepository = StubNaverBlogRepository()
    youtubeRepository = StubYoutubeRepository()
    
    detailUseCase = DetailUseCase(
      campsiteRepository: campsiteRepository,
      realmRepository: realmRepository,
      touristInfoRepository: touristInfoRepository,
      weatherRepository: weatherRepository,
      naverBlogRepository: naverBlogRepository,
      youtubeRepository: youtubeRepository
    )
    detailCoordinator = StubDetailCoordinator(UINavigationController())
    viewModel = DetailViewModel(
      coordinator: detailCoordinator,
      detailUseCase: detailUseCase,
      style: .campsite(data: mockCampsite)
    )
    input = DetailViewModel.Input(
      viewWillAppear: viewWillAppear.asObservable(),
      isAutorizedLocation: isAutorizedLocation.asSignalOnErrorJustComplete(),
      didSelectItemAt: didSelectItemAt.asSignalOnErrorJustComplete(),
      shareButtonDidTapped: shareButtonDidTapped.asSignalOnErrorJustComplete()
    )
    disposeBag = DisposeBag()
    output = viewModel.transform(input: input)
  }
  
  override func tearDownWithError() throws {
    output = nil
    disposeBag = nil
    input = nil
    viewModel = nil
    detailCoordinator = nil
    detailUseCase = nil
    campsiteRepository = nil
    realmRepository = nil
    touristInfoRepository = nil
    weatherRepository = nil
    naverBlogRepository = nil
    youtubeRepository = nil
    mockCampsite = nil
    scheduler =  nil
    try super.tearDownWithError()
  }
  
  func test_View_생명주기_메서드_실행_시_데이터_패칭() {
    viewWillAppear.onNext(Void())
    XCTAssertEqual(viewModel.getCampsiteDataValue().count, 7)
  }
  
  func test_헤더_및_네비게이션바_Review_작성_버튼_클릭_시_리뷰_모달_인터렉션() {
    viewModel.campsiteHeaderViewModel.visitButtonDidTapped.accept(Void())
    XCTAssertEqual(detailCoordinator.showDateSelectModalCalled, true)
  }
  
  func test_헤더_및_네비게이션바_Like_버튼_클릭_시_realm_Like_반영_인터렉션() {
    viewModel.campsiteHeaderViewModel.likeButtonDidTapped.accept(Void())
    XCTAssertEqual(realmRepository.updateCampsiteCalled, true)
  }
  
  func test_pagerView_탭_인터렉션_시_해당_이미지_확대_뷰로_화면전환() {
    guard let mockImageUrlStr = campsiteImageDummyData.toDomain().first else { return }
    viewModel.campsiteHeaderViewModel.pagerViewDidTapped.accept(mockImageUrlStr)
    XCTAssertEqual(detailCoordinator.navigateToFlowZoomCalled, true)
  }
  
  func test_detail_전체_콜렉션_중_소셜_부분_탭_인터렉션_시_관련_뷰로_화면전환() {
    didSelectItemAt.onNext(
      (
        DetailSocialItem(
          socialMediaInfo:
            YoutubeInfo(
              type: "youtube",
              title: "(주)디노담양힐링파크 지점",
              url: "https://www.youtube.com/results?search_query=(주)디노담양힐링파크 지점",
              description: "YouTube 검색 결과창으로 이동",
              thumbnailUrl: ""
            )
        ),
        IndexPath(item: 0, section: 4)
      )
    )
    
    XCTAssertEqual(detailCoordinator.navigateToFlowWebCalled, true)
  }
 
  func test_detail_전체_콜렉션_중_이미지_부분_탭_인터렉션_시_관련_뷰로_화면전환() {
    guard let mockImageUrlStr = campsiteImageDummyData.toDomain().first else { return }
    didSelectItemAt.onNext(
      (
        DetailImageItem(
          image: mockImageUrlStr
        ),
        IndexPath(item: 0, section: 6))
    )
    
    XCTAssertEqual(detailCoordinator.navigateToFlowZoomCalled, true)
  }
  
  func test_detail_중_주위_관광정보_섹션_아이템_탭_인터렉션_시_detail_뷰_추가_화면전환() {
    guard let dummyData = touristInfoDummyData.toDomain().item.first else { return }
    viewModel.aroundTabmanViewModel.detailAroundTabmanSubViewModel.didSelectItemAt.accept((dummyData, IndexPath(item: 0, section: 0)))
    
    XCTAssertEqual(detailCoordinator.navigateToFlowDetailCalled, true)
  }
}
