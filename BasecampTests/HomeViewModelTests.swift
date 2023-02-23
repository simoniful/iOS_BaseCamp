//
//  HomeUseCaseTests.swift
//  HomeUseCaseTests
//
//  Created by Sang hun Lee on 2023/02/21.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import Basecamp

final class HomeUseCaseTests: XCTestCase {
  
  var scheduler: TestScheduler!
  var useCase: HomeUseCase!
  var realmRepository: RealmRepositoryInterface!
  var touristInfoRepository: TouristInfoRepositoryInterface!
  var disposeBag: DisposeBag!
  
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    scheduler = TestScheduler(initialClock: 0)
    realmRepository = StubRealmRepository()
    touristInfoRepository = StubTouristInfoRepository()
    useCase = HomeUseCase(
      realmRepository: realmRepository,
      touristInfoRepository: touristInfoRepository
    )
    disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_getTouristInfoValue() {

  }
  
  
  
}

