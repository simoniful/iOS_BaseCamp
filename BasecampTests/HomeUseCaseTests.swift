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
  var campsiteRepository: CampsiteRepositoryInterface!
  var touristInfoRepository: TouristInfoRepositoryInterface!
  var address: TestableObserver<String>!
  var disposeBag: DisposeBag!
  
  
    override func setUpWithError() throws {
      
      
      realmRepository = StubRealmRepository()
      touristInfoRepository = StubTouristInfoRepository()
      
      useCase = HomeUseCase(
        realmRepository: realmRepository,
        touristInfoRepository: touristInfoRepository
      )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

